import secret_custody_protocol.aleo;
import arc721.aleo;
import credits.aleo;


program marketplace.aleo{
    const mpc_threshold: u8 = 8u8;

    record MarketplaceNFTData {
        owner: address,
        data: [field; 4],
        edition: scalar
    }

    struct ListingData {
        price: u64,
        seller: address,
        data_custody_hash: field,
        nft_data_address: address
    }

    mapping listings: scalar => ListingData; 
                   // nft_commit => listing_data;
    mapping listings_buyer: scalar => address;
                            // nft_commit => buyer;

    inline commit_token(
        data: [field; 4],
        edition: scalar
    ) -> field {
        let data_hash: field = BHP256::hash_to_field(data);
        let commitment: field = BHP256::commit_to_field(data_hash, edition);
        return commitment;
    }


    async transition list(
        private nft: arc721.aleo/NFT,   // private nft record to list
        public price: u64,              // total price paid by seller
        private secret_random_viewkey: scalar,
        private privacy_random_coefficients: [field; 14],
        private validators: [address; 15],
    ) -> (MarketplaceNFTData, Future) {
        let (transfer_future, nft_data): (Future, arc721.aleo/NFTData) 
            = arc721.aleo/transfer_private_to_public(
                nft, self.address
            );
        let nft_data_address: address = (secret_random_viewkey * group::GEN) as address;
        let out_nft_data: MarketplaceNFTData = MarketplaceNFTData {
            owner: nft_data_address,
            data: nft.data,
            edition: nft.edition
        };
        let nft_commit: field = commit_token(nft.data, nft.edition);

        let data_custody: secret_custody_protocol.aleo/Custody = secret_custody_protocol.aleo/Custody {
            initiator: self.caller,
            data_address: nft_data_address,
            threshold: threshold,
        };

        let data_custody_hash: field = BHP256::hash_to_field(data_custody);

        let custody_data_as_program_future: Future =
            secret_custody_protocol.aleo/custody_data_as_program(
                secret_random_viewkey, // private data_view_key: scalar,
                privacy_random_coefficients, // private coefficients: [field; 14],
                validators, // private validators: [address; 15],
                threshold // private threshold: u8 <= 15
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
            out_nft_data, 
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
        nft_commit: field,
        listing_data: ListingData,
        validators: [address; 15]
        /*
            Validators associated with the listing can be retrieved using: 
                protocol_validators.aleo/validator_sets.get(
                    secret_custody_protocol.aleo/custodies.get(
                        listing_data.data_custody_hash
                    )
                )
        */
    ) -> Future {
        let pay_marketplace_future: Future =
            credits.aleo/transfer_public(
                listing_data.seller,
                listing_data.price
            );

        let request_data_as_program_future: Future =
            secret_custody_protocol.aleo/request_data_as_program(
                listing_data.nft_data_address, // private data_address: address,
                self.signer, // private to: address,
                mpc_threshold, // private threshold: u8,
                validators,// public validators: [address; 15],
            );
        let accept_listing_future: Future = finalize_accept_listing(
            self.caller,
            nft_commit,
            listing_data,
            pay_marketplace_future,
            request_data_as_program_future,
        );
        return (
            accept_listing_future,
            accepted_listing
        );
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
        nft_data: [field; 4],
        nft_edition: scalar,
        listing_data: ListingData
        /*
            Validators associated with the listing can be retrieved using: 
                protocol_validators.aleo/validator_sets.get(
                    secret_custody_protocol.aleo/custodies.get(
                        listing_data.data_custody_hash
                    )
                )
        */
    ) -> (arc721.aleo/NFT, AcceptedListing, Future) {
        let nft_commit: field = commit_token(nft_data, nft_edition);
        
        let (
            purshased_nft,
            transfer_nft_to_buyer_future
        ): (arc721.aleo/NFT, Future) = arc721.aleo/transfer_public_to_private(
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
            accept_listing_future,
            accepted_listing
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

