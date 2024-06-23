

export const remove_whitespaces = (str) => (
  str.replace(/\s+/g, '')
);

export const sql_string = (value) => (
  `'${String(value).replace(/'/g, "''")}'`
);