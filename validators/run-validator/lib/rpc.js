import 'dotenv/config';


const rpc_headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
};


export class LiveRpcProvider {
  constructor(url) {
    this.url = url;
  }

  async from_url(url) {
    const instance = new LiveRpcProvider(url);
    const status_res = await instance.chainStatus();
    if (!status_res?.online) {
      throw new Error(
        `RPC unavailable at '${url}'.`,
        status_res?.statusTitle,
        status_res?.statusMessage
      );
    }
    return instance;
  }

  async call_rpc(method, params) {
    const rawResponse = await fetch(
      this.url,
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
    return response?.result;
  }

  // Endpoints
  async aleoTransactionsForProgram({
    programId,
    functionName,
    page,
    maxTransactions
  }) {
    return await this.call_rpc(
      "aleoTransactionsForProgram",
      { programId, functionName, page, maxTransactions }
    );
  }

  async chainStatus() {
    return await this.call_rpc("chainStatus");
  }
}

