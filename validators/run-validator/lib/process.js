import {
  share_record,
  request_record,
  process_request_function,
  consider_record_spent_after_tx_during_s,
} from "../config/programs.js";

import {
  call_process_request
} from './programs.js';

import { record_table } from "./sync.js";
import { run_select_request } from "./db.js";


export const process_requests = async (rpc_provider, db, account) => {
  const validator_address = account.address().to_string();

  // const joinable_couples = ...;

  // TODO IMPLEMENT JOIN WITH HELPERS ALL IN ONE TRANSACTION

  const query = `
    SELECT
      req.serial_number req_serial,
      share.serial_number share_serial,
      req.plaintext req_plaintext,
      share.plaintext share_plaintext,
      share.weight weight, 
      req.fee_amount as fee
    FROM ${record_table(request_record)} req
    JOIN ${record_table(share_record)} share
    ON share.custody_hash = req.custody_hash
    WHERE
      share.spent = 0
      AND 
      req.spent = 0
      AND
      share.owner = '${validator_address}'
      AND
      req.owner = '${validator_address}'
      AND
      share.weight = req.expected_weight
    GROUP BY req_serial;
  `;

  const executable_couples = await run_select_request(db, query);

  // TODO IMPLEMENT CHOICE CONSIDERING LIVENESS INCENTIVE
  const couple_to_execute = get_highest_fee_couple(executable_couples);

  console.log(couple_to_execute);
  // execute process_private_request on couple_to_execute
  await process_request(account, couple_to_execute);

  const expire_timestamp = (
    Date.now() + consider_record_spent_after_tx_during_s * 1000
  );
  await Promise.all([
    tag_record_spent(
      db, request_record, couple_to_execute.req_serial, expire_timestamp
    ),
    tag_record_spent(
      db, share_record, couple_to_execute.share_serial, expire_timestamp
    )
  ]);
};


const process_request = async (account, couple_to_execute) => {
  await call_process_request(
    account,
    couple_to_execute.share_plaintext,
    couple_to_execute.req_plaintext
  )
}


function get_highest_fee_couple(couples) {
  if (!couples || couples.length === 0) return null;

  return couples.reduce((maxFeeObject, currentObject) => {
    const currentFee = parseInt(currentObject.fee.replace('u64', ''));
    const maxFee = parseInt(maxFeeObject.fee.replace('u64', ''));

    return currentFee > maxFee ? currentObject : maxFeeObject;
  }, couples[0]);
}