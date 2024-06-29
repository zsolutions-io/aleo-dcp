import { aleoTransactionsForProgram } from "./rpc.js"
import {
  save_db, insert_into_table, select_from_table, update_in_table
} from "./db.js"
import { remove_whitespaces } from "./string.js"
import { serial_number } from "./aleo.js"
import { sql_string } from "./string.js";


// Programs variable names
const protocol_transfers_program = "adcp_private_states.aleo";
const share_record = "ValidatorShare";
const request_record = "WithdrawRequest";

const sstv_function = "submit_shares_to_validators";
const jsav_function = "join_shares_as_validator";
const srtv_function = "submit_requests_to_validators";
const prav_function = "process_request_as_validator";

// Tables
const record_tables = {
  [share_record]: "share_records",
  [request_record]: "request_records",
}
const processed_transitions_table = "processed_transitions";

// RPC
const transaction_per_batch = 20;


const load_transactions_page = async (functionName, page) => (
  await aleoTransactionsForProgram(
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
  function_name, apply_to_transition, processed_already
) => {
  let page = Math.floor(processed_already / transaction_per_batch);
  let starting_index = processed_already % transaction_per_batch;
  while (true) {
    const transactions = await load_transactions_page(
      function_name, page
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
    const values = [serial, plaintext, 0];
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
  const elements = await select_from_table(db, processed_transitions_table);
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
      await insert_into_table(db, processed_transitions_table, values);
    } else {
      const where = `function = ${function_name}`;
      const udpate = { amount };
      await update_in_table(db, processed_transitions_table, udpate, where);
    }
  }
}


export const sync_db_with_blockchain = async (db, account) => {
  const processed_transitions = await load_processed_transitions(db);
  await Promise.all([
    sync_sstv_transitions(db, account, processed_transitions),
    sync_jsav_transitions(db, account, processed_transitions),
    sync_srtv_transitions(db, account, processed_transitions),
    sync_prav_transitions(db, account, processed_transitions),
  ]);
  await update_processed_transitions(db, processed_transitions);
  await save_db(db);
}


const sync_sstv_transitions = async (db, account, processed_transitions) => {
  const apply_to_sstv_transition = async ({ inputs, outputs }) => {
    const owned_records = owned_records_from_outputs(account, outputs);
    await Promise.all(owned_records.map(async (record) => (
      await tag_record_received(db, account, share_record, record)
    )));
  };
  processed_transitions[sstv_function] = await travel_transaction_pages(
    sstv_function,
    apply_to_sstv_transition,
    processed_transitions[sstv_function]
  );
}


const sync_jsav_transitions = async (db, account, processed_transitions) => {
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
    jsav_function,
    apply_to_jsav_transition,
    processed_transitions[jsav_function]
  );
}


const sync_srtv_transitions = async (db, account, processed_transitions) => {
  const apply_to_srtv_transition = async ({ inputs, outputs }) => {
    const owned_records = owned_records_from_outputs(account, outputs);
    await Promise.all(owned_records.map(async (record) => (
      await tag_record_received(db, account, request_record, record)
    )));
  };
  processed_transitions[srtv_function] = await travel_transaction_pages(
    srtv_function,
    apply_to_srtv_transition,
    processed_transitions[srtv_function]
  );
}


const sync_prav_transitions = async (db, account, processed_transitions) => {
  const apply_to_prav_transition = async ({ inputs, outputs }) => {
    await Promise.all([
      tag_record_spent(db, share_record, inputs[0].id),
      tag_record_spent(db, request_record, inputs[1].id)
    ]);
  };
  processed_transitions[prav_function] = await travel_transaction_pages(
    prav_function,
    apply_to_prav_transition,
    processed_transitions[prav_function]
  );
}


/*
  ----------
  Inputs/Outputs of Interest
  ----------

  (adcp_private_states.aleo, submit_shares_to_validators)
    - outputs[0]: ValidatorShare
    - outputs[1]: ValidatorShare
    ...
    - outputs[15]: ValidatorShare

  (adcp_private_states.aleo, join_shares_as_validator)
    - inputs[0]: ValidatorShare
    - inputs[1]: ValidatorShare
    - outputs[0]: ValidatorShare

  (adcp_private_states.aleo, submit_requests_to_validators)
    - outputs[0]: WithdrawRequest
    - outputs[1]: WithdrawRequest
    ...
    - outputs[15]: WithdrawRequest

  (adcp_private_states.aleo, process_request_as_validator)
    - inputs[0]: ValidatorShare
    - inputs[1]: WithdrawRequest

*/
