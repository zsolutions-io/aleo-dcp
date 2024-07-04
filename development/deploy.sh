
source ./development/.env


deploy_any () {
    build_path="$1/$2/build"
    cd $build_path;
    snarkos developer deploy \
        --private-key $PRIVATE_KEY \
        --query $NODE_URL \
        --priority-fee 0 \
        --broadcast "$NODE_URL/testnet/transaction/broadcast" \
        --network 1 \
        "$2.aleo";
    only_slash="${build_path//[^\/]}";
    slash_amount="${#only_slash}";
    back_steps=$(printf '../%.0s' $(seq 1 $slash_amount));
    cd $back_steps;
}

deploy_program () {
    deploy_any "./programs" $1;
}

deploy_program "dcp_withdraw_requests";
deploy_program "dcp_validator_shares";
deploy_program "dcp_core_protocol";
deploy_program "data_custody_protocol";
deploy_program "dcp_reconstruct_secret";

deploy_any "./examples/nft_marketplace/programs" "arc721_example";
deploy_any "./examples/nft_marketplace/programs" "marketplace_example";


