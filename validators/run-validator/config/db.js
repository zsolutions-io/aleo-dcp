// Table definitions

export const tables = {
  processed_transitions: {
    name: "processed_transitions",
    columns: "(function TEXT PRIMARY KEY, amount INT)"
  },
  request_records: {
    name: "request_records",
    columns: "(serial_number TEXT PRIMARY KEY, plaintext TEXT, spent INT, custody_key TXT, request_id TXT)"
  },
  share_records: {
    name: "share_records",
    columns: "(serial_number TEXT PRIMARY KEY, plaintext TEXT, spent INT, custody_key TXT)"
  },
  requests: {
    name: "requests",
    columns: "(request_id TEXT PRIMARY KEY, plaintext TEXT, spent INT, custody_key TXT)"
  },
  custodies: {
    name: "custodies",
    columns: "(custody_hash TEXT PRIMARY KEY, custody_key TEXT, spent INT)"
  }
};


export const db_file_name = "db.sqlite";
