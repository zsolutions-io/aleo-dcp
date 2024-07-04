

source ./development/.env

TRANSACTION_ENDPOINT="$NODE_URL/testnet/transaction";
BROADCAST_ENDPOINT="$TRANSACTION_ENDPOINT/broadcast";

SLEEP_BETWEEN_TX=10


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
            --broadcast $BROADCAST_ENDPOINT \
            --network 1 \
            "dcp_core_protocol.aleo" \
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
    sleep $SLEEP_BETWEEN_TX;
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
            --broadcast $BROADCAST_ENDPOINT \
            --network 1 \
            "arc721_example.aleo" \
            "mint" \
            "{metadata:[0field,1field,2field,3field]}" \
            1234567890scalar \
        | awk 'NR==6'
    );
    sleep $SLEEP_BETWEEN_TX;
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
            --broadcast $BROADCAST_ENDPOINT \
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
    sleep $SLEEP_BETWEEN_TX;
    list_raw_tx=$(curl $TRANSACTION_ENDPOINT/$list_tx_id)
    nft_record_ciphertext=$(
        echo $list_raw_tx \
        | jq --raw-output '.execution.transitions[0].outputs[0].value'
    );
    nft_record_plaintext=$(
        snarkos developer decrypt \
            --view-key $VIEW_KEY \
            --ciphertext $nft_record_ciphertext
    );
    nft_commit=$(
        echo $list_raw_tx \
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
            --broadcast $BROADCAST_ENDPOINT \
            --network 1 \
            "credits.aleo" \
            "transfer_public_to_private" \
            "$BUYER_ADDRESS" \
            "10000000u64" \
        | awk 'NR==6'
    );
    sleep $SLEEP_BETWEEN_TX;
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

# Transfer credits for fees
snarkos developer execute \
    --private-key $PRIVATE_KEY \
    --query $NODE_URL \
    --priority-fee 0 \
    --broadcast $BROADCAST_ENDPOINT \
    --network 1 \
    "credits.aleo" \
    "transfer_public" \
    "$BUYER_ADDRESS" \
    "50000000u64";
sleep $SLEEP_BETWEEN_TX;


price=$(
    echo $list_raw_tx \
    | jq --raw-output '.execution.transitions[4].outputs[1].value' \
    | awk 'NR==6' \
    | tr -d " \t\r\n," 
);
seller_address=$(
    echo $list_raw_tx \
    | jq --raw-output '.execution.transitions[4].outputs[1].value' \
    | awk 'NR==7' \
    | tr -d " \t\r\n," 
);
data_custody_hash=$(
    echo $list_raw_tx \
    | jq --raw-output '.execution.transitions[4].outputs[1].value' \
    | awk 'NR==8' \
    | tr -d " \t\r\n," 
);
nft_data_address=$(
    echo $list_raw_tx \
    | jq --raw-output '.execution.transitions[4].outputs[1].value' \
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
            --broadcast $BROADCAST_ENDPOINT \
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
            "$credits_plaintext" \
        | awk 'NR==6'
    );
    sleep $SLEEP_BETWEEN_TX;
    accept_listing_raw_tx=$(curl $TRANSACTION_ENDPOINT/$accept_listing_tx_id)
}



echo $list_raw_tx \
    | jq --raw-output ".execution.transitions[1].outputs[$i].value"

share_records=()

for i in {0..7}
do
    share_record_ciphertext=$(
        echo $list_raw_tx \
            | jq --raw-output ".execution.transitions[1].outputs[$i].value"
    )
    share_record_plaintext=$(
        snarkos developer decrypt \
            --view-key $VIEW_KEY \
            --ciphertext $share_record_ciphertext
    );
    share_records+=("$share_record_plaintext")
done


accept_listing_raw_tx=$(curl $TRANSACTION_ENDPOINT/$accept_listing_tx_id)
request_records=()

for i in {0..7}
do
    request_record_ciphertext=$(
        echo $accept_listing_raw_tx \
            | jq --raw-output ".execution.transitions[1].outputs[$i].value"
    )
    request_record_plaintext=$(
        snarkos developer decrypt \
            --view-key $VIEW_KEY \
            --ciphertext $request_record_ciphertext
    );
    request_records+=("$request_record_plaintext")
done


# echo ${request_records[0]}



# Process Requests
{
    process_tx_ids=()
    for i in {0..7}
    do
        share_plaintext=${share_records[$i]}
        request_plaintext=${request_records[$i]}
        process_tx_id=$(
            snarkos developer execute \
                --private-key $PRIVATE_KEY \
                --query $NODE_URL \
                --priority-fee 0 \
                --broadcast $BROADCAST_ENDPOINT \
                --network 1 \
                "dcp_core_protocol.aleo" \
                "process_request_as_validator" \
                "$share_plaintext" \
                "$request_plaintext" \
            | awk 'NR==6'
        );
        process_tx_ids+=("$process_tx_id")
    done
}


# Get shares
destination_shares=()
for i in {0..7}
do
    destination_share_ciphertext=$(
        curl $TRANSACTION_ENDPOINT/${process_tx_ids[$i]} \
            | jq --raw-output ".execution.transitions[2].outputs[0].value"
    )
    sleep 1;
    destination_share_plaintext=$(
        snarkos developer decrypt \
            --view-key $BUYER_VIEW_KEY \
            --ciphertext $destination_share_ciphertext
    );
    destination_shares+=("$destination_share_plaintext")
done


shares=()
for i in {0..7}
do
    share=$(
        echo ${destination_shares[$i]} | \
            sed 's/.*share_val: \([0-9]*\)field.private, index: \([0-9]*\)field.private.*/{ share_val: \1field, index: \2field }/g' | \
            tr -d '\n' | \
            sed 's/}\s*{/}, {/g'
    )
    shares+=("$share")
done

for i in {8..15}
do
    shares+=("{share_val: 0field, index: 0field}")
done

joined_shares=$(IFS=, ; echo "${shares[*]}")

cd ./programs/dcp_reconstruct_secret_offchain/build/
nft_data_view_key_number=$(
    snarkvm run reconstruct_secret_offchain \
        "[$joined_shares]" \
        | awk 'NR==8 {print $2+0}'
)
cd ../../..

nft_data_view_key_scalar="${nft_data_view_key_number}scalar"
nft_data_view_key=$(
    ./utils/snarkvm-scalar-to-viewkey/target/release/snarkvm-scalar-to-viewkey \
        $nft_data_view_key_scalar
)

nft_view_record_ciphertext=$(
    echo $list_raw_tx \
    | jq --raw-output '.execution.transitions[4].outputs[0].value'
);

nft_view_record_plaintext=$(
    snarkos developer decrypt \
        --view-key $nft_data_view_key \
        --ciphertext $nft_view_record_ciphertext
);