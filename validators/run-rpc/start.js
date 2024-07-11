import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import * as methods from './methods.js';

import * as dotenv from 'dotenv';
dotenv.config();


const app = express();
app.use(cors());
app.use(bodyParser.json({ limit: '150kb' }));
app.use(express.urlencoded({ extended: true }));
const port = Number(process.env.RPC_API_PORT || 3000);

const server = app.listen(port, () => {
  console.log('RPC server started on port: ' + port);
});


server.timeout = 60_000; // milliseconds
server.headersTimeout = server.timeout;
server.requestTimeout = server.timeout;


const call_rpc_method = async (method_name, params) => {
  const method = methods?.[method_name];
  if (method == null) {
    throw new Error(`RPC method '${method_name}' not found.`);
  }
  return await method(params);
}

const rpc_base = {
  jsonrpc: "2.0",
  id: 1
};

const try_call_rpc_method = async (rpc_request) => {
  const method = rpc_request?.method;
  const result = await call_rpc_method(method, rpc_request?.params);
  return {
    ...rpc_base,
    result
  };
}



app.post("/", async (req, res) => {
  const rpc_request = req.body;
  try {
    const response = await try_call_rpc_method(rpc_request)
    return res.json(response);
  } catch (e) {
    const response = {
      ...rpc_base,
      error: e + ''
    };

    return res.status(400).send(response,);
  }
});

/*
app.get(
  "*", async (req, res) => {
    try {
      console.log(req);
    } catch (e) {
      const response = {
        ...rpc_base,
        error: e + ''
      };

      return res.status(400).send(response,);
    }
  }
);

*/