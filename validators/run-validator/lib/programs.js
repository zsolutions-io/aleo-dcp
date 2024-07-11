import {
  execute_program_onchain, execute_program_offchain, synthetize_program_keys,
} from "./aleo.js"
import {
  hash_custody_function,
  process_request_function
} from "../config/programs.js";

import { programs_dir } from "./path.js";
import fs from 'fs.promises';

export const hash_custody = async (account, custody) => {
  const outputs = await execute_program_offchain(
    account,
    hash_custody_program_source,
    hash_custody_program_name,
    hash_custody_function_name,
    [custody]
  );
  return outputs[0];
}

export const call_process_request = async (
  account, share_record_plaintext, request_record_plaintext
) => {
  const outputs = await execute_program_onchain(
    account,
    process_request_program_id,
    process_request_function_name,
    [share_record_plaintext, request_record_plaintext],
    0.0037,
  );
  return outputs;
}


export const synthetize_programs_keys = async (account) => {
  const address = account.address().to_string();
  await synthetize_program_keys(
    account,
    hash_custody_program_name,
    hash_custody_program_source,
    hash_custody_function_name,
    ["{origin: aleo1050n3kd4x3spur952m58v56a572uxw8dlnxvmtn9qcjcqnjkty9q0xu8x5,custody_key: 7828field,threshold: 8u8}"]
  );
  await synthetize_program_keys(
    account,
    process_request_program_name,
    process_request_program_source,
    process_request_function_name,
    [
      `{owner:${address}.private,share:{share_val:4752445field.private,index:2field.private},custody:{origin:aleo1050n3kd4x3spur952m58v56a572uxw8dlnxvmtn9qcjcqnjkty9q0xu8x5.private,custody_key:7828field.private,threshold:8u8.private},weight:1u64.private,_nonce:6208724562062762170079864327493571698285315802189525497653082774780201029904group.public}`,
      `{owner:${address}.private,custody_hash:7326020223694610699177037627683577570584146866729959130032521342380501061531field.private,to:aleo1m3p4haa2zv8f7qlvds53jle72r5f46lqgpk8jh5zvl350zcu9gxqxrua6e.private,fee_amount:1000u64.private,expected_weight:1u64.private,_nonce:5671608015959128205727583363521834414137213520861986854184800923741662679496group.public}`,
    ]
  );
}


const load_program_source = async (program_id) => {
  const program_name = program_id.split(".")[0];
  const program_path = `${programs_dir}/${program_name}/build/main.aleo`;
  try {
    return await fs.readFile(program_path, "utf-8");
  }
  catch (e) {
    throw new Error(
      `'${program_id}' build not found,`
      + `start by executing './development/build.sh' from project root.`
    );
  }
}


const [
  hash_custody_program_id,
  hash_custody_function_name
] = hash_custody_function.split("/");
const hash_custody_program_name = hash_custody_program_id.split(".")[0];
const hash_custody_program_source = await load_program_source(hash_custody_program_id);

const [
  process_request_program_id,
  process_request_function_name
] = process_request_function.split("/");
const process_request_program_name = process_request_program_id.split(".")[0];
const process_request_program_source = await load_program_source(process_request_program_id);
