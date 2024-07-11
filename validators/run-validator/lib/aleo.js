import {
  Account, RecordPlaintext, ProgramManager,
  initThreadPool, AleoKeyProvider, ProvingKey, VerifyingKey,
  AleoNetworkClient, NetworkRecordProvider
} from '@aleohq/sdk';

import { data_dir, programs_dir } from "./path.js";
import fsExists from 'fs.promises.exists';
import fs from 'fs.promises';

import * as dotenv from 'dotenv';
dotenv.config();

await initThreadPool();

const keyProvider = new AleoKeyProvider();
keyProvider.useCache(true);


export const load_aleo_account = async (privateKey) => {
  const account = new Account({ privateKey });
  const networkClient = new AleoNetworkClient(`${process.env.NODE_URL}`);
  const recordProvider = new NetworkRecordProvider(account, networkClient);
  const programManager = new ProgramManager(
    `${process.env.NODE_URL}`, keyProvider, recordProvider
  );

  // await programManager.networkClient.getLatestHeight();

  programManager.setAccount(account);
  programManager.networkClient.fs = fs;
  programManager.networkClient.programs_dir = programs_dir;
  account.programManager = programManager;
  return account;
}


export const serial_number = (account, plaintext, program_id, record_name) => {
  const private_key = account.privateKey();
  const record_plaintext = RecordPlaintext.fromString(plaintext);
  return record_plaintext.serialNumberString(
    private_key, program_id, record_name
  );
}


const extract_value = (segment) => {
  segment = segment.trim();
  if (segment.startsWith('{') && segment.endsWith('}')) {
    return parse_record_plaintext(segment);
  } else if (segment.startsWith('[') && segment.endsWith(']')) {
    return segment.slice(1, -1).split(',').map(
      item => item.trim().replace(/(\.private|\.public)$/, '')
    );
  }
  return segment.replace(/(\.private|\.public)$/, '');
}


export const parse_record_plaintext = (plaintext) => {
  const obj = {};
  let content = plaintext.slice(1, -1);
  let matches;
  const keyValueRegex =
    /([^:{},\[\]]+):([^:{},\[\]]+|{[^{}]*}|(\[[^\[\]]*\]))/g;
  while ((matches = keyValueRegex.exec(content)) !== null) {
    let key = matches[1].trim();
    let value = matches[2].trim();
    obj[key] = extract_value(value);
  }
  return obj;
}


export const struct_repr = (struct) => {
  if (typeof struct === "string") return struct;
  const struct_content = Object
    .entries(
      struct
    ).map(
      ([key, val]) => (
        `${key}: ${typeof val === "string" ? val : struct_repr(val)
        }`
      )
    ).join(",");
  return `{${struct_content}}`;
}


export const execute_program_offchain = async (
  account,
  program_source,
  program_name,
  function_name,
  inputs,
) => {
  const [
    proving_key,
    verifying_key
  ] = await load_program_keys(program_name, function_name);

  const executionResponse = await account.programManager.run(
    program_source,
    function_name,
    inputs,
    false,
    [],
    null,
    proving_key,
    verifying_key
  );
  const result = executionResponse.getOutputs();
  return result;
}


export const execute_program_onchain = async (
  account,
  program_id,
  function_name,
  inputs,
  fee,
) => {
  const program_name = program_id.split(".")[0];
  const [
    proving_key,
    verifying_key
  ] = await load_program_keys(program_name, function_name);

  const transaction = await account.programManager.buildExecutionTransaction(
    program_id,
    function_name,
    fee,
    false,
    inputs,
    null,
    null,
    null,
    proving_key,
    verifying_key,
    account.privateKey(),
    null,
  );
  const result = await account.programManager.networkClient.submitTransaction(transaction);
  console.log(`Submited: ${result}`)
  return result;
}



const get_key_paths = (program_name, function_name) => {
  const proving_key_path =
    `${data_dir}/${program_name}_${function_name}.prover`;
  const verifying_key_path =
    `${data_dir}/${program_name}_${function_name}.verifier`;

  return [proving_key_path, verifying_key_path]
}


export const synthetize_program_keys = async (
  account, program_name, program_source, function_name, inputs
) => {
  const [proving_key_path, verifying_key_path] = get_key_paths(
    program_name, function_name
  );

  if (await fsExists(proving_key_path) && await fsExists(verifying_key_path)) {
    return;
  }
  const [proving_key, verifying_key] =
    await account
      .programManager
      .synthesizeKeys(
        program_source,
        function_name,
        inputs,
        account.privateKey()
      );
  await fs.writeFile(proving_key_path, proving_key.toBytes());
  await fs.writeFile(verifying_key_path, verifying_key.toBytes());
}


export const load_program_keys = async (program_name, function_name) => {
  const [proving_key_path, verifying_key_path] = get_key_paths(
    program_name, function_name
  );
  const proving_key = ProvingKey.fromBytes(
    new Uint8Array(await fs.readFile(proving_key_path))
  );
  const verifying_key = VerifyingKey.fromBytes(
    new Uint8Array(await fs.readFile(verifying_key_path))
  );

  return [proving_key, verifying_key];
}


const record_attributes = (record) => (
  Object.values(record).map(struct_repr)
);


const snarkvm_int_pattern = /^(\-*\d+)((i|u)(\d+))$/;
const convert_snarkvm_value = (col_value) => {
  const matches_int = col_value.match(snarkvm_int_pattern);
  if (matches_int) {
    const [, number1, type, number2] = matches_int;
    return BigInt(number1, 10);
  }
  return col_value;
}


export const converted_record_attributes = (record) => (
  record_attributes(record).map(convert_snarkvm_value)
);
