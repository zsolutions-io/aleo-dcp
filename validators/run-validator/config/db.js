// Table definitions

export const tables = {
  processed_transitions: {
    name: "processed_transitions",
    columns: "(function TEXT PRIMARY KEY, amount INT)"
  },
  request_records: {
    name: "request_records",
    columns: "(serial_number TEXT PRIMARY KEY, plaintext TEXT, spent INT, custody_id TXT, request_id TXT)"
  },
  share_records: {
    name: "share_records",
    columns: "(serial_number TEXT PRIMARY KEY, plaintext TEXT, spent INT, custody_id TXT)"
  },
  requests: {
    name: "requests",
    columns: "(request_id TEXT PRIMARY KEY, plaintext TEXT, spent INT, custody_id TXT)"
  },
  custodies: {
    name: "custodies",
    columns: "(custody_hash TEXT PRIMARY KEY, custody_id TEXT, spent INT, custody_id TXT)"
  }
};


export const db_file_name = "db.sqlite";
