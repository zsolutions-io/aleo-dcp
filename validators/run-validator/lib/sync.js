import {
  save_db, insert_into_table, select_from_table, update_in_table
} from "./db.js"
import { remove_whitespaces } from "./string.js"
import { serial_number, parse_record_plaintext } from "./aleo.js"
import { sql_string } from "./string.js";

import {
  protocol_transfers_program,
  share_record,
  request_record,
  sstv_function,
  jsav_function,
  srtv_function,
  prav_function
} from "../config/programs.js";
import { tables } from "../config/db.js"
import { transaction_per_batch } from "../config/rpc.js"


const record_tables = {
  [share_record]: tables.share_records.name,
  [request_record]: tables.request_records.name,
}


export const sync_db_with_blockchain = async (rpc_provider, db, account) => {
  const processed_transitions = await load_processed_transitions(db);
  await Promise.all([
    sync_sstv_transitions(rpc_provider, db, account, processed_transitions),
    sync_jsav_transitions(rpc_provider, db, account, processed_transitions),
    sync_srtv_transitions(rpc_provider, db, account, processed_transitions),
    sync_prav_transitions(rpc_provider, db, account, processed_transitions),
  ]);
  await update_processed_transitions(db, processed_transitions);

  await save_db(db);
}


const load_transactions_page = async (rpc_provider, functionName, page) => (
  await rpc_provider.aleoTransactionsForProgram(
    {
      programId: protocol_transfers_program,
      functionName: functionName,
      page,
      maxTransactions: transaction_per_batch
    }
  )
);


const record_table = (record_name) => {
  const table_name = record_tables?.[record_name];
  if (!table_name) {
    throw new Error("Unknown record name.");
  }
  return table_name;
}


export const travel_transaction_pages = async (
  rpc_provider, function_name, apply_to_transition, processed_already
) => {
  let page = Math.floor(processed_already / transaction_per_batch);
  let starting_index = processed_already % transaction_per_batch;
  while (true) {
    const transactions = await load_transactions_page(
      rpc_provider, function_name, page
    );
    const transitions = transactions.reduce(
      (acc, transaction, index) => {
        if (index < starting_index) {
          return acc;
        }
        const filtered_transitions = transaction
          .transaction.execution.transitions.filter(
            (transition) => (
              transition.program === protocol_transfers_program
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


const get_record_data_columns = (record_name, plaintext) => {
  const record_object = parse_record_plaintext(plaintext);
  if (record_name == share_record) {
    return [record_object.custody_id.slice(0, -"field".length)];
  }
  else if (record_name == request_record) {
    return [
      record_object.custody_id.slice(0, -"field".length),
      record_object.request_id.slice(0, -"field".length)
    ];
  } else {
    throw new Error("Unknown record name.")
  }
}


const owned_records_from_outputs = (account, outputs) => (
  outputs
    .filter((output) => account.ownsRecordCiphertext(output.value))
    .map((output) => account.decryptRecord(output.value))
);


const retrieve_record_from_serial = async (db, record_name, serial) => {
  const table_name = record_table(record_name);
  const where = `serial_number = ${sql_string(serial)}`;
  const found = await select_from_table(db, table_name, where);
  return found.length ? found[0] : null;
}


const tag_record_received = async (
  db, account, record_name, record_string
) => {
  const plaintext = remove_whitespaces(record_string);
  const serial = serial_number(
    account, record_string, protocol_transfers_program, record_name
  );
  const found = await retrieve_record_from_serial(db, record_name, serial);
  if (found == null) {
    const data_columns = get_record_data_columns(record_name, plaintext);
    const values = [serial, plaintext, 0, ...data_columns];
    await insert_into_table(db, table_name, values);
  }
};


const tag_record_spent = async (db, record_name, serial) => {
  const found = await retrieve_record_from_serial(db, record_name, serial);
  if (found != null) {
    const table_name = record_table(record_name);
    const where = `serial_number = ${sql_string(serial)}`;
    await update_in_table(db, table_name, { spent: 1 }, where);
  } else {
    const values = [serial, null, 1];
    await insert_into_table(db, table_name, values);
  }
}


const retrieve_processed_transitions = async (db) => {
  const elements = await select_from_table(db, tables.processed_transitions.name);
  return !found.length ? null : Object.fromEntries(
    elements.map(
      (element) => (
        [element.function, element.page]
      )
    )
  );
}


const load_processed_transitions = async (db) => {
  const found = await retrieve_processed_transitions(db);
  return (found != null) ? found : {
    sstv_function: 0,
    jsav_function: 0,
    srtv_function: 0,
    prav_function: 0
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
      const where = `function = ${function_name}`;
      const udpate = { amount };
      await update_in_table(db, tables.processed_transitions.name, udpate, where);
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


const sync_prav_transitions = async (
  rpc_provider, db, account, processed_transitions
) => {
  const apply_to_prav_transition = async ({ inputs, outputs }) => {
    await Promise.all([
      tag_record_spent(db, share_record, inputs[0].id),
      tag_record_spent(db, request_record, inputs[1].id)
    ]);
  };
  processed_transitions[prav_function] = await travel_transaction_pages(
    rpc_provider,
    prav_function,
    apply_to_prav_transition,
    processed_transitions[prav_function]
  );
}


/*
  ----------
  Inputs/Outputs of Interest
  ----------

  (dcp_private_states.aleo, submit_shares_to_validators)
    - outputs[0]: ValidatorShare
    - outputs[1]: ValidatorShare
    ...
    - outputs[15]: ValidatorShare

  (dcp_private_states.aleo, join_shares_as_validator)
    - inputs[0]: ValidatorShare
    - inputs[1]: ValidatorShare
    - outputs[0]: ValidatorShare

  (dcp_private_states.aleo, submit_requests_to_validators)
    - outputs[0]: WithdrawRequest
    - outputs[1]: WithdrawRequest
    ...
    - outputs[15]: WithdrawRequest

  (dcp_private_states.aleo, process_request_as_validator)
    - inputs[0]: ValidatorShare
    - inputs[1]: WithdrawRequest

*/
