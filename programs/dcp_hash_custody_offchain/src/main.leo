

program dcp_hash_custody_offchain.aleo {
    struct Custody {
        origin: address,
        custody_key: field,
        threshold: u8,
    }

    transition hash_custody(custody: Custody) -> field {
        return BHP256::hash_to_field(custody);
    }
}


/*
import { Account, ProgramManager } from '@aleohq/sdk';

const programManager = new ProgramManager();
const account = new Account();
programManager.setAccount(account);

const secret_santa_v001_program = `INSERT SOURCE FOR import secret_santa_v001.aleo HERE`;

function add_gift_tag_bulk_inputs(pairs){
  return (
      "[" 
      + pairs.map(
        ([addr1, addr2]) => `[${addr1}, ${addr2}]`
       ).join(", ") 
      + "]"
  );
}

async function add_gift_tags(pairs) {
  const program = generate_add_gift_tag_function(pairs.length);
  const inputs = add_gift_tag_bulk_inputs(pairs);
  const executionResponse = await programManager.executeOffline(
    program, 
    "add_gift_tag_bulk", 
    inputs,
    false,
    {
      "secret_santa_v001.aleo": secret_santa_v001_program
    }
  );
  const result = executionResponse.getOutputs();
  return result;
}
*/