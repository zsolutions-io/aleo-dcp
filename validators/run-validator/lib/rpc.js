import 'dotenv/config';


const rpc_headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
};


export const call_rpc = async (method, params) => {
  const rawResponse = await fetch(
    process.env["RPC_URL"],
    {
      method: 'POST',
      headers: rpc_headers,
      body: JSON.stringify({
        jsonrpc: "2.0",
        id: 1,
        method,
        params: params ? params : null
      })
    }
  );
  const response = await rawResponse.json();
  if (response.error) {
    throw new Error(`RPC API:\n${response.error.message}`);
  }
  return response.result;
}

// Endpoints

export const aleoTransactionsForProgram = async ({
  programId,
  functionName,
  page,
  maxTransactions
}) => (
  await call_rpc(
    "aleoTransactionsForProgram",
    {
      programId,
      functionName,
      page,
      maxTransactions
    }
  )
);