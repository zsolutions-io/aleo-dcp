

source ./development/.env

TRANSACTION_ENDPOINT="$NODE_URL/testnet/transaction";


# Initialize validators
{
    validators="[
        $ADDRESS,
        $ADDRESS,
        $ADDRESS,
        $ADDRESS,
        $ADDRESS,
        $ADDRESS,
        $ADDRESS,
        $ADDRESS,
        $ADDRESS,
        $ADDRESS,
        $ADDRESS,
        $ADDRESS,
        $ADDRESS,
        $ADDRESS,
        $ADDRESS,
        $ADDRESS
    ]"
    initiate_validators_tx_id=$(
        snarkos developer execute \
            --private-key $PRIVATE_KEY \
            --query $NODE_URL \
            --priority-fee 0 \
            --broadcast "$NODE_URL/testnet/transaction/broadcast" \
            --network 1 \
            "dcp_public_states.aleo" \
            "initiate_validators" \
            "[
                $ADDRESS,
                $ADDRESS,
                $ADDRESS,
                $ADDRESS,
                $ADDRESS,
                $ADDRESS,
                $ADDRESS,
                $ADDRESS,
                $ADDRESS,
                $ADDRESS,
                $ADDRESS,
                $ADDRESS,
                $ADDRESS,
                $ADDRESS,
                $ADDRESS,
                $ADDRESS
            ]" \
            1u8 \
        | awk 'NR==6'
    );

    curl $TRANSACTION_ENDPOINT/$initiate_validators_tx_id \
    | jq;
}



# NFT Mint
{
    mint_tx_id=$(
        snarkos developer execute \
            --private-key $PRIVATE_KEY \
            --query $NODE_URL \
            --priority-fee 0 \
            --broadcast "$TRANSACTION_ENDPOINT/broadcast" \
            --network 1 \
            "arc721_example.aleo" \
            "mint" \
            "{metadata:[0field,1field,2field,3field]}" \
            1234567scalar \
        | awk 'NR==6'
    );
    nft_record_ciphertext=$(
        curl $TRANSACTION_ENDPOINT/$mint_tx_id \
        | jq --raw-output '.execution.transitions[0].outputs[0].value'
    );
    nft_record_plaintext=$(
        snarkos developer decrypt \
            --view-key $VIEW_KEY \
            --ciphertext $nft_record_ciphertext
    );
}


# List NFT
{
    secret_random_viewkey="$((1 + $RANDOM % 100000))scalar"
    list_tx_id=$(
        snarkos developer execute \
            --private-key $PRIVATE_KEY \
            --query $NODE_URL \
            --priority-fee 0 \
            --broadcast "$TRANSACTION_ENDPOINT/broadcast" \
            --network 1 \
            "marketplace_example.aleo" \
            "list" \
            "$nft_record_plaintext" \
            1000000u64 \
            "$secret_random_viewkey" \
            "[
                $((1 + $RANDOM % 100000))field,
                $((1 + $RANDOM % 100000))field,
                $((1 + $RANDOM % 100000))field,
                $((1 + $RANDOM % 100000))field,
                $((1 + $RANDOM % 100000))field,
                $((1 + $RANDOM % 100000))field,
                $((1 + $RANDOM % 100000))field,
                $((1 + $RANDOM % 100000))field,
                $((1 + $RANDOM % 100000))field,
                $((1 + $RANDOM % 100000))field,
                $((1 + $RANDOM % 100000))field,
                $((1 + $RANDOM % 100000))field,
                $((1 + $RANDOM % 100000))field,
                $((1 + $RANDOM % 100000))field,
                $((1 + $RANDOM % 100000))field
            ]" \
            "$validators" \
        | awk 'NR==6'
    );
    nft_record_ciphertext=$(
        curl $TRANSACTION_ENDPOINT/$list_tx_id \
        | jq --raw-output '.execution.transitions[0].outputs[0].value'
    );
    nft_record_plaintext=$(
        snarkos developer decrypt \
            --view-key $VIEW_KEY \
            --ciphertext $nft_record_ciphertext
    );
    nft_commit=$(
        curl $TRANSACTION_ENDPOINT/$list_tx_id \
        | jq --raw-output '.execution.transitions[0].outputs[1].value' \
        | awk 'NR==6' \
        | tr -d " \t\r\n," 
    );
}


# Transfer Credits
{
    transfer_public_to_private_tx_id=$(
        snarkos developer execute \
            --private-key $PRIVATE_KEY \
            --query $NODE_URL \
            --priority-fee 0 \
            --broadcast "$TRANSACTION_ENDPOINT/broadcast" \
            --network 1 \
            "credits.aleo" \
            "transfer_public_to_private" \
            "$BUYER_ADDRESS" \
            "10000000u64" \
        | awk 'NR==6'
    );
    credits_ciphertext=$(
        curl "$TRANSACTION_ENDPOINT/$transfer_public_to_private_tx_id" \
        | jq --raw-output '.execution.transitions[0].outputs[0].value'
    );
    credits_plaintext=$(
        snarkos developer decrypt \
            --view-key $BUYER_VIEW_KEY \
            --ciphertext $credits_ciphertext
    );
}

price=$(
    curl $TRANSACTION_ENDPOINT/$list_tx_id \
    | jq --raw-output '.execution.transitions[19].outputs[1].value' \
    | awk 'NR==6' \
    | tr -d " \t\r\n," 
);
seller_address=$(
    curl $TRANSACTION_ENDPOINT/$list_tx_id \
    | jq --raw-output '.execution.transitions[19].outputs[1].value' \
    | awk 'NR==7' \
    | tr -d " \t\r\n," 
);
data_custody_hash=$(
    curl $TRANSACTION_ENDPOINT/$list_tx_id \
    | jq --raw-output '.execution.transitions[19].outputs[1].value' \
    | awk 'NR==8' \
    | tr -d " \t\r\n," 
);
nft_data_address=$(
    curl $TRANSACTION_ENDPOINT/$list_tx_id \
    | jq --raw-output '.execution.transitions[19].outputs[1].value' \
    | awk 'NR==9' \
    | tr -d " \t\r\n," 
);

# Accept listing
{
    accept_listing_tx_id=$(
        snarkos developer execute \
            --private-key $BUYER_PRIVATE_KEY \
            --query $NODE_URL \
            --priority-fee 0 \
            --broadcast "$TRANSACTION_ENDPOINT/broadcast" \
            --network 1 \
            "marketplace_example.aleo" \
            "accept_listing" \
            "$nft_commit" \
            "$((1 + $RANDOM % 100000))field" \
            "{
                price: $price,
                seller: $seller_address,
                data_custody_hash: $data_custody_hash,
                nft_data_address: $nft_data_address
            }" \
            "$validators" \
            "1000u64" \
            "$credits_plaintext"
        | awk 'NR==6'
    );

    curl $TRANSACTION_ENDPOINT/$accept_listing_tx_id \
    | jq;
}


