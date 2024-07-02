

cd ./programs/dcp_public_states;
leo build;
cd ../..;

cd ./programs/dcp_private_states;
leo build;
cd ../..;

cd ./programs/data_custody_protocol;
leo build;
cd ../..;

cd ./programs/dcp_reconstruct_secret;
leo build;
cd ../..;

cd ./examples/nft_marketplace/programs/arc721_example;
leo build;
cd ../../../../;

cd ./examples/nft_marketplace/programs/marketplace_example;
leo build;
cd ../../../../;

