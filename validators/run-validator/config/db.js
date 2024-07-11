// Table definitions

export const tables = {
  processed_transitions: {
    name: "processed_transitions",
    columns: "(function TEXT PRIMARY KEY, amount INT)"
  },
  request_records: {
    name: "request_records",
    columns: "(serial_number TEXT PRIMARY KEY, plaintext TEXT, spent INT, owner TXT, custody_hash TXT, to_address TXT, fee_amount INT, expected_weight INT, expire INT, _nonce TXT)"
  },
  share_records: {
    name: "share_records",
    columns: "(serial_number TEXT PRIMARY KEY, plaintext TEXT, spent INT, custody_hash TXT, owner TXT, share TXT, custody TXT, weight INT, _nonce TXT)"
  },
  fee_records: {
    name: "fee_records",
    columns: "(serial_number TEXT PRIMARY KEY, plaintext TEXT, spent INT, owner TXT, microcredits INT, expire INT, _nonce TXT)"
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

record Fee {
    owner: address,
    microcredits: u64,
    expire: u32
}

*/