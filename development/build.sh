cd ./programs/dcp_withdraw_requests
leo build
cd ../..

cd ./programs/dcp_validator_shares
leo build
cd ../..

cd ./programs/data_custody_protocol
leo build
cd ../..

cd ./programs/dcp_reconstruct_secret
leo build
cd ../..

cd ./programs/dcp_reconstruct_secret_offchain
leo build
cd ../..


cd examples/nft_marketplace/programs/arc721_example
leo build
cd ../../../..

cd examples/nft_marketplace/programs/marketplace_example
leo build
cd ../../../..

# Uncomment
# async transition process_request_as_validator(

cd programs/dcp_core_protocol
leo build --non-recursive
cd ../..



deploy_program "dcp_withdraw_requests";
deploy_program "dcp_validator_shares";
deploy_program "dcp_core_protocol";
deploy_program "data_custody_protocol";
deploy_program "dcp_reconstruct_secret";

deploy_any "./examples/nft_marketplace/programs" "arc721_example";
deploy_any "./examples/nft_marketplace/programs" "marketplace_example";


cd ./utils/snarkvm-scalar-to-viewkey
cargo build --release
cd ../..