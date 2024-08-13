cd ./programs/dcp_open_requests
leo build --network testnet --endpoint "https://api.explorer.aleo.org/v1"
cd ../..

cd ./programs/dcp_validator_shares
leo build --network testnet --endpoint "https://api.explorer.aleo.org/v1"
cd ../..

cd ./programs/data_custody_protocol
leo build --network testnet --endpoint "https://api.explorer.aleo.org/v1"
cd ../..

cd ./programs/dcp_reconstruct_secret
leo build --network testnet --endpoint "https://api.explorer.aleo.org/v1"
cd ../..

cd ./programs/dcp_reconstruct_secret_offchain
leo build --network testnet --endpoint "https://api.explorer.aleo.org/v1"
cd ../..

cd ./programs/dcp_hash_custody_offchain
leo build --network testnet --endpoint "https://api.explorer.aleo.org/v1"
cd ../..

cd examples/nft_marketplace/programs/arc721_example
leo build --network testnet --endpoint "https://api.explorer.aleo.org/v1"
cd ../../../..

cd examples/nft_marketplace/programs/marketplace_example
leo build --network testnet --endpoint "https://api.explorer.aleo.org/v1"
cd ../../../..

cd programs/dcp_core_protocol
leo build --network testnet --endpoint "https://api.explorer.aleo.org/v1"
cd ../..

cd ./utils/snarkvm-scalar-to-viewkey
cargo build --release
cd ../..
