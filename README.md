# Aleo DCP: Data Custody Protocol

A MPC protocol built on Aleo to **allow any program to custody arbitrary private data** that can be programatically withdrawn.

It supports any maximum amount of validators decided on deployment of protocol programs.

Validators that can be dynamically updated through a voting gouvernance mechanism. They are incentivized with aleo credits fees paid by requester of cusodied data.

## Use Cases

It enables use cases such as private data NFT marketplace with one click buy or decentralised data broker.

## How it works?

1. An arbitrary Aleo record (from any program) containing the private data is transferred to an address, which random View Key is splitted in shares among N validators using the Shamir Secret Sharing algorithm. This is the **Custody** step.
2. This view key can later be requested to be sent privately to any destination address, by initial program. This is the **Request** step.
3. A decentralized network of [validators](#validators) can then process the query immediatly. It consists of peers running bot JS script, that provide their respective share to the destination address. This is the **Submit** step.
4. The requestor can then reconstruct the View Key offchain using k of n shares and decipher the private data from the original record. This is the **Reconstruct** step.

**Request**, **Execute**, and **Submit** stepd can all happen without awaiting validation from the original caller of **Custody** step transaction.

![alt text](aleo-dcp-schema.png)

## Protocol Governance

### Validators

Protocol has **N Validators** and a **vote threshold**, initiated by deployer.

Validators propose and vote for **Proposals**, consisting of a new set of Validators and next vote threshold.

[Check implementation of **`protocol_core.leo`**.](programs/protocol_core/src/main.leo)

### Run validator

Incoming js implementation.

## Usage

### How to call it from any other program?

For a program to custody private data, it must import **`data_custody_protocol.aleo`**.

1. To custody data, it must:
    - Call `data_custody_protocol.aleo/custody_data_as_program(data_view_key, threshold, ...)`
    - Send any records to `(data_view_key * group::GEN) as address`
2. It can then call `data_custody_protocol.aleo/request_data_as_program` to initiate a data request.
3. Validator bots automatically call `protocol_transfers.aleo/process_request_as_validator` to accept the data request.
4. `data_custody_protocol.aleo/assert_completed_as_program` can then be used by the program to check if data was effectively transmitted.

### Example

Marketplace program for exchanging NFTs with secret data, which standard is detailed at [**`arc721_example.leo`**](/examples/nft_marketplace/programs/arc721_example/src/main.leo):

```rust
import data_custody_protocol.aleo;
import arc721_example.aleo;
import credits.aleo;

program marketplace_example.aleo {
    const mpc_threshold: u8 = 8u8;

    struct ListingData {
        price: u64,
        seller: address,
        data_custody_hash: field,
        nft_data_address: address
    }
    
    record NFTView{
        owner: address,
        data: data,
        edition: scalar
    }


    mapping listings: field => ListingData; 
    // nft_commit => listing_data;

    mapping listings_buyer: field => address;
    // nft_commit => buyer;


    inline commit_nft(
        nft_data: data,
        nft_edition: scalar
    ) -> field {
        let data_hash: field = BHP256::hash_to_field(nft_data);
        let commitment: field = BHP256::commit_to_field(data_hash, nft_edition);
        return commitment;
    }


    async transition list(
        private nft: arc721_example.aleo/NFT,   // private nft record to list
        public price: u64,              // total price paid by seller
        private secret_random_viewkey: scalar,
        private privacy_random_coefficients: [field; 15],
        private validators: [address; 16],
    ) -> (NFTView, Future) {
        let (nft_view, transfer_future): (arc721_example.aleo/NFTView, Future) 
            = arc721_example.aleo/transfer_private_to_public(
                nft, self.address
            );
        let nft_data_address: address = (secret_random_viewkey * group::GEN) as address;
        let out_nft_view: NFTView = NFTView {
            owner: nft_data_address,
            data: nft.data,
            edition: nft.edition
        };
        let nft_commit: field = commit_nft(nft.data, nft.edition);

        let data_custody: Custody = Custody {
            initiator: self.caller,
            data_address: nft_data_address,
            threshold: mpc_threshold,
        };

        let data_custody_hash: field = BHP256::hash_to_field(data_custody);

        let custody_data_as_program_future: Future =
            data_custody_protocol.aleo/custody_data_as_program(
                secret_random_viewkey, // private data_view_key: scalar,
                privacy_random_coefficients, // private coefficients: [field; 15],
                validators, // private validators: [address; 16],
                mpc_threshold // private threshold: u8 <= 16
            );

        let list_future: Future = finalize_list(
            nft_commit,
            price,
            self.caller,
            data_custody_hash,
            nft_data_address,
            transfer_future,
            custody_data_as_program_future
        );
        return (
            out_nft_view, 
            list_future,
        );
    }
    async function finalize_list(
        nft_commit: field,
        price: u64,
        seller: address,
        custody_hash: field,
        nft_data_address: address,
        transfer_future: Future,
        custody_data_as_program_future: Future
    ) {
        transfer_future.await();
        custody_data_as_program_future.await();

        let listing_data: ListingData = ListingData{
            price: price,
            seller: seller,
            data_custody_hash: custody_hash,
            nft_data_address: nft_data_address
        };
        listings.set(nft_commit, listing_data);
    }


    async transition accept_listing(
        public nft_commit: field,
        private listing_data: ListingData,
        public validators: [address; 16],
        public validator_fee: u64,
        private protocol_fee_record: credits.aleo/credits,
        /*
            Validators associated with the listing can be retrieved using: 
                protocol_core.aleo/validator_sets.get(
                    protocol_core.aleo/custodies.get(
                        listing_data.data_custody_hash
                    )
                )
        */
    ) -> (credits.aleo/credits, Future) {
        let pay_marketplace_future: Future =
            credits.aleo/transfer_public(
                listing_data.seller,
                listing_data.price
            );

        let (
            change,
            request_data_as_program_future
        ): (
            credits.aleo/credits,
            Future
        ) =
            data_custody_protocol.aleo/request_data_as_program(
                listing_data.nft_data_address, // private data_address: address,
                self.signer, // private to: address,
                mpc_threshold, // private threshold: u8,
                validators,// public validators: [address; 15],
                validator_fee,
                protocol_fee_record,
            );
        let accept_listing_future: Future = finalize_accept_listing(
            self.caller,
            nft_commit,
            listing_data,
            pay_marketplace_future,
            request_data_as_program_future,
        );
        return (change, accept_listing_future);
    }
    async function finalize_accept_listing(
        caller: address,
        nft_commit: field,
        listing_data: ListingData,
        pay_marketplace_future: Future,
        request_data_as_program_future: Future
    ) {
        let retrieved_listing_data: ListingData = listings.get(nft_commit);
        assert_eq(retrieved_listing_data, listing_data);
        assert(listings_buyer.contains(nft_commit).not());
        listings_buyer.set(nft_commit, caller);
        
        pay_marketplace_future.await();
        request_data_as_program_future.await();
    }


    // {nft_data, nft_edition} are retrieved by executing 'reconstruct_secret.aleo' offchain on shares sent to buyer by validators
    async transition withdraw_nft(
        nft_data: data,
        nft_edition: scalar,
        listing_data: ListingData
        /*
            Validators associated with the listing can be retrieved using: 
                protocol_validators.aleo/validator_sets.get(
                    data_custody_protocol.aleo/custodies.get(
                        listing_data.data_custody_hash
                    )
                )
        */
    ) -> (arc721_example.aleo/NFT, Future) {
        let nft_commit: field = commit_nft(nft_data, nft_edition);
        
        let (
            purshased_nft,
            transfer_nft_to_buyer_future
        ): (arc721_example.aleo/NFT, Future) = arc721_example.aleo/transfer_public_to_private(
            nft_data,
            nft_edition,
            self.caller,
        );

        let accept_listing_future: Future = finalize_withdraw_nft(
            self.caller,
            nft_commit,
            listing_data,
            transfer_nft_to_buyer_future,
        );
        return (
            purshased_nft,
            accept_listing_future
        );
    }
    async function finalize_withdraw_nft(
        caller: address,
        nft_commit: field,
        listing_data: ListingData,
        transfer_nft_to_buyer_future: Future,
    ) {
        let retrieved_listing_data: ListingData = listings.get(nft_commit);
        assert_eq(retrieved_listing_data, listing_data);
        assert_eq(listings_buyer.get(nft_commit), caller);
        listings_buyer.remove(nft_commit);
        listings.remove(nft_commit);
        transfer_nft_to_buyer_future.await();
    }
}
```

*This is a very simplified marketplace to focus on the `data_custody_protocol.aleo` program usage. This is why seller/buyer privacy as well as offers are not implemented here.*

## Future Improvements

- **Allow any amount of *request* steps, amount defined at `custody` step**
