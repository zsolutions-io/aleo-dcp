import { sync_db_with_blockchain } from "./lib/sync.js";
import { load_database } from "./lib/db.js";
import { load_aleo_account } from "./lib/aleo.js";
import 'dotenv/config';
import { select_from_table, insert_into_table, update_in_table } from "./lib/db.js";

import 'dotenv/config';


const main = async () => {
  const db = await load_database();
  const account = await load_aleo_account(process.env["PRIVATE_KEY"]);
  const address = account.address().to_string();
  console.log("Aleo account found:", address);
  await sync_db_with_blockchain(db, account);

  /*
  await insert_into_table(db, "request_records", ["test", "content", 0]);

  await update_in_table(db, "request_records", { spent: 1 }, "serial_number = 'test'")
  const res = await select_from_table(db, "request_records");
  console.log(res);
  */
}


await main();
