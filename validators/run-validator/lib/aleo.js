import {
  Account, RecordPlaintext, ProgramManager,
  initThreadPool, AleoKeyProvider, ProvingKey, VerifyingKey
} from '@aleohq/sdk';

import { data_dir } from "./path.js";
import fsExists from 'fs.promises.exists';
import fs from 'fs.promises';

await initThreadPool();

const keyProvider = new AleoKeyProvider();
keyProvider.useCache(true);

export const load_aleo_account = async (privateKey) => {
  const account = new Account({ privateKey });

  const programManager = new ProgramManager(null, keyProvider);
  programManager.setAccount(account);
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


export const synthetize_program_keys = async (
  account, program_name, program_source, function_name, inputs
) => {
  const proving_key_path = `${data_dir}/${program_name}_${function_name}.prover`;
  const verifying_key_path = `${data_dir}/${program_name}_${function_name}.verifier`;

  if (await fsExists(proving_key_path) && await fsExists(verifying_key_path)) {
    return;
  }
  const [proving_key, verifying_key] = await account.programManager.synthesizeKeys(
    program_source,
    function_name,
    inputs,
    account.privateKey()
  );
  await fs.writeFile(proving_key_path, proving_key.toBytes());
  await fs.writeFile(verifying_key_path, verifying_key.toBytes());
}


export const load_program_keys = async (program_name, function_name) => {
  const proving_key_path = `${data_dir}/${program_name}_${function_name}.prover`;
  const verifying_key_path = `${data_dir}/${program_name}_${function_name}.verifier`;

  const proving_key = ProvingKey.fromBytes(
    new Uint8Array(await fs.readFile(proving_key_path))
  );
  const verifying_key = VerifyingKey.fromBytes(
    new Uint8Array(await fs.readFile(verifying_key_path))
  );

  return [proving_key, verifying_key];
}


