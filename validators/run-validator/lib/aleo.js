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


const extract_value = (segment) => {
  segment = segment.trim();
  if (segment.startsWith('{') && segment.endsWith('}')) {
    return parse_record_plaintext(segment);
  } else if (segment.startsWith('[') && segment.endsWith(']')) {
    return segment.slice(1, -1).split(',').map(
      item => item.trim().replace(/(\.private|\.public)$/, '')
    );
  }
  return segment.replace(/(\.private|\.public)$/, '');
}


export const parse_record_plaintext = (plaintext) => {
  const obj = {};
  let content = plaintext.slice(1, -1);
  let matches;
  const keyValueRegex =
    /([^:{},\[\]]+):([^:{},\[\]]+|{[^{}]*}|(\[[^\[\]]*\]))/g;
  while ((matches = keyValueRegex.exec(content)) !== null) {
    let key = matches[1].trim();
    let value = matches[2].trim();
    obj[key] = extract_value(value);
  }
  return obj;
}