import pg from 'pg';

const { Pool, Client } = pg;

import * as dotenv from 'dotenv';
dotenv.config();


export const pg_client = new Client({
  user: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
  host: process.env.POSTGRES_HOST,
  port: process.env.POSTGRES_PORT,
  database: process.env.POSTGRES_DB,
  search_path: process.env.POSTGRES_SCHEMA
})

await pg_client.connect();

await pg_client.query(`SET search_path TO '${process.env.POSTGRES_SCHEMA}';`);
