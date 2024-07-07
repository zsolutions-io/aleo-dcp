
import fs from 'fs/promises';
import initSqlJs from 'sql.js';
import { data_dir, create_dir_if_not_exists, } from "./path.js";
import { sql_string } from "./string.js";
import { tables, db_file_name } from "../config/db.js";

const db_path = `${data_dir}/${db_file_name}`;


const create_tables_if_not_exists = async (db) => {
  return (
    await Promise.all(
      Object.values(tables).map(
        async (table) => await create_table_if_not_exists(db, table)
      )
    )
  ).some(x => x);
}


const create_table_if_not_exists = async (db, table) => {
  try {
    db.prepare(`SELECT * FROM ${table.name}`);
    return false;
  } catch (e) {
    if (e.message.startsWith("no such table:")) {
      const sql_cmd = `CREATE TABLE ${table.name}${table.columns}`;
      console.log(`Executing: \`${sql_cmd}\``)
      db.run(sql_cmd);
      return true;
    } else {
      throw (e);
    }
  }
}


export const convert_js_to_sql = (value) => {
  if (typeof value === "string") {
    return sql_string(value);
  }
  else if (value == null) {
    return "NULL";
  }
  return value;
}


export const insert_into_table = async (db, table, values) => {
  for (let i = 0; i < values.length; i++) {
    values[i] = convert_js_to_sql(values[i]);
  }
  const sql_cmd = `INSERT INTO ${table} VALUES (${values.join(",")})`;
  console.log(`Executing: \`${sql_cmd}\``)
  db.run(sql_cmd);
}


export const update_in_table = async (db, table, updates, where) => {
  if (updates == null || Object.keys(updates).length === 0) {
    throw new Error("Invalid table updates.");
  }
  const updates_expr = Object
    .entries(updates)
    .map(([key, value]) => `${key} = ${convert_js_to_sql(value)}`)
    .join(",");
  const where_expr = (where == null) ? "" : ` WHERE ${where}`
  const sql_cmd = `UPDATE ${table} SET ${updates_expr}${where_expr}`;
  console.log(`Executing: \`${sql_cmd}\``)
  db.run(sql_cmd);
}


export const select_from_table = async (db, table, where) => {
  const where_expr = (where == null) ? "" : ` WHERE ${where}`
  const sql_cmd = `SELECT * FROM ${table}${where_expr}`;
  console.log(`Executing: \`${sql_cmd}\``)
  const result = db.exec(sql_cmd);
  if (result.length === 0) {
    return [];
  }
  const { columns, values: rows } = result[0];
  return rows.map(
    (row) => (
      Object.fromEntries(
        columns.map(
          (value, index) => [value, row[index]]
        )
      )
    )
  );
}


export const save_db = async (db) => {
  const data = db.export();
  const buffer = Buffer.from(data);
  await create_dir_if_not_exists(data_dir);
  await fs.writeFile(db_path, buffer);
}


export const load_database = async () => {
  const SQL = await initSqlJs({});
  let db = new SQL.Database();
  try {
    const filebuffer = await fs.readFile(db_path);
    db = new SQL.Database(filebuffer);
  } catch (e) { }
  const updates = await create_tables_if_not_exists(db);
  if (updates) {
    await save_db(db);
  }
  return db;
}

