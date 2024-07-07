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

cd ./programs/dcp_hash_custody_offchain
leo build
cd ../../../..

cd examples/nft_marketplace/programs/arc721_example
leo build
cd ../../../..

cd examples/nft_marketplace/programs/marketplace_example
leo build
cd ../../../..


# In './programs/dcp_core_protocol/src/main.leo' Uncomment transition :
# transition process_request_as_validator(
# This is due to: https://github.com/ProvableHQ/leo/issues/28192

while true; do
    read -p "In './programs/dcp_core_protocol/src/main.leo', uncomment transition 'process_request_as_validator'. Is it done (yes/no)?" yn
    case $yn in
        [Yy]* ) make install; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done


cd programs/dcp_core_protocol
leo build --non-recursive
cd ../..

cd ./utils/snarkvm-scalar-to-viewkey
cargo build --release
cd ../..