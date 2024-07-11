// Programs variable names

export const share_record = "dcp_validator_shares.aleo/ValidatorShare";
export const request_record = "dcp_withdraw_requests.aleo/WithdrawRequest";

export const sstv_function = "dcp_validator_shares.aleo/submit_shares_to_validators";
export const jsav_function = "dcp_validator_shares.aleo/join_shares_as_validator";
export const srtv_function = "dcp_withdraw_requests.aleo/submit_requests_to_validators";
export const swr_function = "dcp_withdraw_requests.aleo/spend_withdraw_request";

export const process_request_function = "dcp_core_protocol.aleo/process_request_as_validator";

export const hash_custody_function = "dcp_hash_custody_offchain.aleo/hash_custody";

export const record_data_columns_amounts = {
  [share_record]: 5,
  [request_record]: 5
};

export const consider_record_spent_after_tx_during_s = 300;