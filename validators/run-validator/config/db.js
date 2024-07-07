// Table definitions

export const tables = {
  processed_transitions: {
    name: "processed_transitions",
    columns: "(function TEXT PRIMARY KEY, amount INT)"
  },
  request_records: {
    name: "request_records",
    columns: "(serial_number TEXT PRIMARY KEY, plaintext TEXT, spent INT, owner TXT, custody_hash TXT, to_address TXT, fee_amount TXT, expected_weight TXT, _nonce TXT)"
  },
  share_records: {
    name: "share_records",
    columns: "(serial_number TEXT PRIMARY KEY, plaintext TEXT, custody_hash TXT, spent INT, owner TXT, share TXT, custody TXT, weight TXT, _nonce TXT)"
  }
};


export const db_file_name = "db.sqlite";

/*


record ValidatorShare {
  owner: address,
  share: Share,
  custody: Custody,
  weight: u64
}


record WithdrawRequest {
    owner: address,
    custody_hash: field,
    to: address,
    fee_amount: u64,
    expected_weight: u64
}


*/