
import { pg_client } from "./db.js";


export const chainStatus = async () => {
  return {
    "online": true,
    "statusTitle": "Everything is working as expected",
    "statusMessage": "There may be some temporary issues with the blockchain, but everything should be working as expected.",
    "time": Date.now()
  }
}

export const aleoTransactionsForProgram = async (params) => {
  const {
    programId,
    functionName,
    page,
    maxTransactions,
  } = params;
  const sql_query = `

  WITH transition_inputs AS (
      SELECT 
          ts.id AS transition_id,
          jsonb_agg(i) AS inputs
      FROM transition ts
      JOIN LATERAL get_transition_inputs(ts.id) i ON true
      GROUP BY ts.id
  ),
  transition_outputs AS (
      SELECT 
          ts.id AS transition_id,
          jsonb_agg(o) AS outputs
      FROM transition ts
      JOIN LATERAL get_transition_outputs(ts.id) o ON true
      GROUP BY ts.id
  ),
  transitions AS (
      SELECT
          ts.transition_id as id,
          ts.transaction_execute_id,
          ts.function_name as function,
          ts.program_id as program,
          tsi.inputs,
          tso.outputs
      FROM transaction_execute te
      JOIN transition ts ON te.id = ts.transaction_execute_id
      LEFT JOIN transition_inputs tsi ON ts.id = tsi.transition_id
      LEFT JOIN transition_outputs tso ON ts.id = tso.transition_id
  )
  SELECT 
      b.height,
      b.timestamp as finalizedAt,
      ct.type,
      t.id as index,
      jsonb_build_object(
          'type', ct.type,
          'id', t.original_transaction_id,
          'execution', jsonb_build_object(
              'transitions', jsonb_agg(ots),
              'global_state_root', te.global_state_root,
              'proof', te.proof
          )
      ) as transaction
  FROM transaction t
  JOIN transaction_execute te on te.transaction_id = t.id
  JOIN confirmed_transaction ct on t.confirmed_transaction_id = ct.id
  JOIN transition ts on te.id = ts.transaction_execute_id
  JOIN transitions ots on te.id = ots.transaction_execute_id
  JOIN block b on ct.block_id = b.id
  WHERE ts.program_id = '${programId}'
  AND ts.function_name = '${functionName}'
  group by t.id, b.height, b.timestamp, te.global_state_root, te.proof, ct.type
  ORDER BY b.height
  LIMIT ${maxTransactions} OFFSET ${page}*${maxTransactions};
  `;
  const query_res = await pg_client.query(sql_query);
  return query_res.rows ? query_res.rows.map(reformat_aleo_transaction) : [];
}

const reformat_aleo_transaction = (raw_db_tx) => {
  const [status, type] = extractFirstTwoWords(raw_db_tx.type);
  raw_db_tx.status = status;
  raw_db_tx.type = type;
  raw_db_tx.transaction.type = type;
  const transitions = raw_db_tx?.transaction?.execution?.transitions;
  if (raw_db_tx?.transaction?.execution == null || transitions == null) {
    return raw_db_tx;
  }
  raw_db_tx.transaction.execution.transitions
    = raw_db_tx.transaction.execution.transitions.map(reformat_aleo_transition);
  return raw_db_tx;
}


const reformat_aleo_transition = (raw_db_ts) => {
  raw_db_ts.inputs = raw_db_ts.inputs || [];
  raw_db_ts.outputs = raw_db_ts.outputs || [];

  const inputs = raw_db_ts.inputs.map(reformat_aleo_input);
  const outputs = raw_db_ts.outputs.map(reformat_aleo_output);

  return {
    ...raw_db_ts,
    inputs,
    outputs
  }
}


const reformat_aleo_input = (raw_db_input) => {
  if (raw_db_input.type == 'Private') {
    return {
      type: 'private',
      id: raw_db_input.ciphertext_hash,
      value: raw_db_input.ciphertext
    };
  }
  if (raw_db_input.type == 'Public') {
    return {
      type: 'public',
      id: raw_db_input.plaintext_hash,
      value: raw_db_input.plaintext,
    };
  }
  if (raw_db_input.type == 'Record') {
    return {
      type: 'record',
      id: raw_db_input.serial_number,
      value: '',
      tag: raw_db_input.tag
    };
  }
  if (raw_db_input.type == 'ExternalRecord') {
    return {
      type: 'external_record',
      id: raw_db_input.commitment,
      value: ''
    };
  }
}

const reformat_aleo_output = (raw_db_output) => {
  if (raw_db_output.type == 'Private') {
    return {
      type: 'private',
      id: raw_db_output.ciphertext_hash,
      value: raw_db_output.ciphertext
    };
  }
  if (raw_db_output.type == 'Public') {
    return {
      type: 'public',
      id: raw_db_output.plaintext_hash,
      value: raw_db_output.plaintext
    };
  }
  if (raw_db_output.type == 'Record') {
    return {
      type: 'record',
      id: raw_db_output.commitment,
      checksum: raw_db_output.checksum,
      value: raw_db_output.record_ciphertext
    };
  }
  if (raw_db_output.type == 'ExternalRecord') {
    return {
      type: 'external_record',
      id: raw_db_output.external_record_commitment,
      value: ''
    };
  }
  if (raw_db_output.type == 'Future') {
    return {
      type: 'future',
      id: raw_db_output.future_hash,
      value: null
    };
  }
}


function extractFirstTwoWords(text) {
  const regex = /^([A-Z]?[a-z]+)([A-Z][a-z]*|\s+[A-Za-z]+)/;
  const match = text.match(regex);

  if (match) {
    // Combine the first and second captured groups, trim any extra spaces.
    return [match[1].toLowerCase(), match[2].trim().toLowerCase()];
  }
  return ['', ''];
}