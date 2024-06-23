import { Account, RecordPlaintext } from '@aleohq/sdk';

export const load_aleo_account = async (privateKey) => {
  const account = new Account({ privateKey });
  return account;
}

export const serial_number = (account, plaintext, program_id, record_name) => {
  const private_key = account.privateKey();
  const record_plaintext = RecordPlaintext.fromString(plaintext);
  return record_plaintext.serialNumberString(
    private_key, program_id, record_name
  );
}