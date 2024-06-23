import { Account, Program } from '@aleohq/sdk';

const programManager = new ProgramManager();
const account = new Account();
programManager.setAccount(account);

const imported_program_source = ``;


async function add_gift_tags(pairs) {
  const executionResponse = await programManager.executeOffline(
    program,
    "add_gift_tag_bulk",
    inputs,
    false,
    {
      "secret_santa_v001.aleo": imported_program_source
    }
  );
  const result = executionResponse.getOutputs();
  return result;
}