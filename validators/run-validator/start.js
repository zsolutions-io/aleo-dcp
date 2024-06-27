import { sync_db_with_blockchain } from "./lib/sync.js";
import { load_database } from "./lib/db.js";
import { load_aleo_account } from "./lib/aleo.js";
import 'dotenv/config';


const main = async () => {
  const db = await load_database();
  const account = await load_aleo_account(process.env["PRIVATE_KEY"]);
  const address = account.address().to_string();
  console.log("Aleo account found:", address);
  await sync_db_with_blockchain(db, account);
}


await main();
