import {
  save_db, insert_into_table, select_from_table, update_in_table
} from "./db.js"
import { remove_whitespaces } from "./string.js"
import {
  serial_number, parse_record_plaintext, struct_repr, converted_record_attributes
} from "./aleo.js"
import { sql_string } from "./string.js";
import { hash_custody } from "./programs.js";

import {
  share_record,
  request_record,
  sstv_function,
  jsav_function,
  srtv_function,
  swr_function,
  record_data_columns_amounts,
} from "../config/programs.js";
import { tables } from "../config/db.js"
import { transaction_per_batch } from "../config/rpc.js"



const record_tables = {
  [share_record]: tables.share_records.name,
  [request_record]: tables.request_records.name,
}


export const remove_actually_unspent_records = async (db) => {
  await Promise.all(
    Object.keys(record_tables).map(
      async (record_id) => await remove_actually_unspent_record(db, record_id)
    )
  );
}


const remove_actually_unspent_record = async (db, record_id) => {
  const table_name = record_table(record_id);
  const now = Date.now();
  const where = `spent > 1 AND spent <= ${now}`;
  await update_in_table(db, table_name, { spent: 0 }, where);
}


export const sync_db_with_blockchain = async (rpc_provider, db, account) => {
  const processed_transitions = await load_processed_transitions(db);
  await Promise.all([
    sync_sstv_transitions(rpc_provider, db, account, processed_transitions),
    sync_jsav_transitions(rpc_provider, db, account, processed_transitions),
    sync_srtv_transitions(rpc_provider, db, account, processed_transitions),
    sync_swr_transitions(rpc_provider, db, account, processed_transitions),
  ]);
  await update_processed_transitions(db, processed_transitions);

  await save_db(db);
}


const load_transactions_page = async (rpc_provider, programId, functionName, page) => {
  return await rpc_provider.aleoTransactionsForProgram(
    {
      programId,
      functionName,
      page,
      maxTransactions: transaction_per_batch
    }
  )
};


export const record_table = (record_id) => {
  const table_name = record_tables?.[record_id];
  if (!table_name) {
    throw new Error("Unknown record name.");
  }
  return table_name;
}


export const travel_transaction_pages = async (
  rpc_provider, function_id, apply_to_transition, processed_already
) => {
  let page = Math.floor(processed_already / transaction_per_batch);
  let starting_index = processed_already % transaction_per_batch;
  const [program_id, function_name] = function_id.split("/");
  while (true) {
    const transactions = await load_transactions_page(
      rpc_provider, program_id, function_name, page
    );
    const transitions = transactions.reduce(
      (acc, transaction, index) => {
        if (index < starting_index) {
          return acc;
        }
        const filtered_transitions = transaction
          .transaction.execution.transitions.filter(
            (transition) => (
              transition.program === program_id
              && transition.function === function_name
            )
          );
        acc.push(...filtered_transitions);
        return acc;
      }, []
    );
    await Promise.all(transitions.map(apply_to_transition));
    const len = transactions?.length;
    if (len === null) {
      throw new Error("Invalid RPC response.");
    }
    if (len < transaction_per_batch) {
      return page * transaction_per_batch + len;
    }
  }
}


const get_record_data_columns = async (account, record_id, plaintext) => {
  const record = parse_record_plaintext(plaintext);
  if (record_id == share_record) {
    const custody = struct_repr(record.custody);
    const custody_hash = await hash_custody(account, custody);
    return [
      custody_hash,
      ...converted_record_attributes(record)
    ];
  }
  else if (record_id == request_record) {
    return converted_record_attributes(record);
  }
  else {
    throw new Error("Unknown record name.")
  }
}


const owned_records_from_outputs = (account, outputs) => (
  outputs
    .filter((output) => account.ownsRecordCiphertext(output.value))
    .map((output) => account.decryptRecord(output.value))
);


const retrieve_record_from_serial = async (db, record_id, serial) => {
  const table_name = record_table(record_id);
  const where = `serial_number = ${sql_string(serial)}`;
  const found = await select_from_table(db, table_name, where);
  return found.length ? found[0] : null;
}


const tag_record_received = async (
  db, account, record_id, record_string
) => {
  const plaintext = remove_whitespaces(record_string);
  const [program_id, record_name] = record_id.split("/");
  const serial = serial_number(
    account, plaintext, program_id, record_name
  );
  const found = await retrieve_record_from_serial(db, record_id, serial);

  if (found == null) {
    const data_columns = await get_record_data_columns(account, record_id, plaintext);
    const values = [serial, plaintext, 0, ...data_columns];
    const table_name = record_table(record_id);
    await insert_into_table(db, table_name, values);
  }
};


const tag_record_spent = async (db, record_id, serial, expire_timestamp) => {
  const found = await retrieve_record_from_serial(db, record_id, serial);
  const table_name = record_table(record_id);
  if (found != null) {
    const where = `serial_number = ${sql_string(serial)}`;
    const spent = (expire_timestamp == null) ? 1 : expire_timestamp;
    await update_in_table(db, table_name, { spent }, where);
  } else {
    const values = [serial, null, 1, ...(new Array(record_data_columns_amounts[record_id]).fill(null))];
    await insert_into_table(db, table_name, values);
  }
}


const retrieve_processed_transitions = async (db) => {
  const elements = await select_from_table(db, tables.processed_transitions.name);
  return !elements.length ? null : Object.fromEntries(
    elements.map(
      (element) => (
        [element.function, element.amount]
      )
    )
  );
}


const load_processed_transitions = async (db) => {
  const found = await retrieve_processed_transitions(db);
  return (found != null) ? found : {
    [sstv_function]: 0,
    [jsav_function]: 0,
    [srtv_function]: 0,
    [swr_function]: 0
  }
}


const update_processed_transitions = async (db, processed_transitions) => {
  const found = await retrieve_processed_transitions(db);
  for (
    const [function_name, amount]
    of Object.entries(processed_transitions)
  ) {
    if (found == null) {
      const values = [function_name, amount];
      await insert_into_table(db, tables.processed_transitions.name, values);
    } else {
      const where = `function = '${function_name}'`;
      const update = { amount };
      await update_in_table(db, tables.processed_transitions.name, update, where);
    }
  }
}


const sync_sstv_transitions = async (
  rpc_provider, db, account, processed_transitions
) => {
  const apply_to_sstv_transition = async ({ inputs, outputs }) => {
    const owned_records = owned_records_from_outputs(account, outputs);
    await Promise.all(owned_records.map(async (record) => (
      await tag_record_received(db, account, share_record, record)
    )));
  };
  processed_transitions[sstv_function] = await travel_transaction_pages(
    rpc_provider,
    sstv_function,
    apply_to_sstv_transition,
    processed_transitions[sstv_function]
  );
}


const sync_jsav_transitions = async (
  rpc_provider, db, account, processed_transitions
) => {
  const apply_to_jsav_transition = async ({ inputs, outputs }) => {
    const owned_records = owned_records_from_outputs(account, outputs);
    await Promise.all(owned_records.map(async (record) => (
      await tag_record_received(db, account, share_record, record)
    )));
    await Promise.all(inputs.map(async (input) => (
      await tag_record_spent(db, share_record, input.id)
    )));
  };
  processed_transitions[jsav_function] = await travel_transaction_pages(
    rpc_provider,
    jsav_function,
    apply_to_jsav_transition,
    processed_transitions[jsav_function]
  );
}


const sync_srtv_transitions = async (
  rpc_provider, db, account, processed_transitions
) => {
  const apply_to_srtv_transition = async ({ inputs, outputs }) => {
    const owned_records = owned_records_from_outputs(account, outputs);
    await Promise.all(owned_records.map(async (record) => (
      await tag_record_received(db, account, request_record, record)
    )));
  };
  processed_transitions[srtv_function] = await travel_transaction_pages(
    rpc_provider,
    srtv_function,
    apply_to_srtv_transition,
    processed_transitions[srtv_function]
  );
}


const sync_swr_transitions = async (
  rpc_provider, db, account, processed_transitions
) => {
  const apply_to_swr_transition = async ({ inputs, outputs }) => {
    await Promise.all([
      tag_record_spent(db, request_record, inputs[0].id)
    ]);
  };
  processed_transitions[swr_function] = await travel_transaction_pages(
    rpc_provider,
    swr_function,
    apply_to_swr_transition,
    processed_transitions[swr_function]
  );
}



/*
  ----------
  Inputs/Outputs of Interest
  ----------

  (dcp_destination_shares.aleo, submit_shares_to_validators)
    - outputs[0]: ValidatorShare
    - outputs[1]: ValidatorShare
    ...
    - outputs[15]: ValidatorShare

  (dcp_destination_shares.aleo, join_shares_as_validator)
    - inputs[0]: ValidatorShare
    - inputs[1]: ValidatorShare
    - outputs[0]: ValidatorShare

  (dcp_open_requests.aleo, submit_requests_to_validators)
    - outputs[0]: OpenRequest
    - outputs[1]: OpenRequest
    ...
    - outputs[15]: OpenRequest

  (dcp_open_requests.aleo, spend_open_request)
    - inputs[0]: OpenRequest

*/
