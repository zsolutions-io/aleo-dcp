/*
    Record definitions and transitions

    contact@aleo.store - Pierre-André LONG
*/
import credits.aleo;
import dcp_public_states.aleo;


program dcp_private_states.aleo {
    const MAX_SHARES: u8 = 16u8;
    const MAX_ON_CHAIN_RECONSTRUCT_SHARES: u8 = 14u8;
    
    struct Custody {
        origin: address,
        custody_key: field,
        threshold: u8,
    }

    struct Share {
        share_val: field,
        index: field
    }

    struct ValidatorShareData {
        validator: address,
        share: Share,
        weight: u64
    }

    record ValidatorShare {
        owner: address,
        share: Share,
        custody: Custody,
        weight: u64
    }

    record WithdrawRequest {
        owner: address,
        custody_hash: field,
        to: address,
        fee_amount: u64,
        request_id: field
    }

    record DestinationShare {
        owner: address,
        share: Share,
        custody_hash: field
    }


    record ReconstructedSecret{
        owner: address,
        secret: field,
        custody_hash: field
    }


    inline hash_custody(custody: Custody) -> field {
        return BHP256::hash_to_field(custody);
    }


    // Inverse field but will invert 0field to 1field to avoid constraint error
    
    inline reconstruct(shares: [Share; 14]) -> field { // MAX_ON_CHAIN_RECONSTRUCT_SHARES
        let secret: field = 0field;
        for i: u8 in 0u8..MAX_ON_CHAIN_RECONSTRUCT_SHARES{
            let lagrange_coeff: field = 1field;
            let x_i: field = shares[i].index;
            for j: u8 in 0u8..MAX_ON_CHAIN_RECONSTRUCT_SHARES{
                let x_j: field = shares[j].index;
                let to_mul: field = 
                    (i != j && x_j != 0field) ? 
                        (x_j * safe_inv(x_j - x_i)) :
                        1field;
                lagrange_coeff *= to_mul;
            }
            let y_i: field = shares[i].share_val;
            secret += (x_i != 0field) ?
                    (y_i * lagrange_coeff) :
                    0field;
        }
        return secret;
    }


    inline safe_inv(f: field) -> field { 
        return ((f == 0field) ? 1field : f).inv();
    }


    inline count_relevant_shares(shares: [Share; 14]) -> u8{ // MAX_ON_CHAIN_RECONSTRUCT_SHARES
        let non_zero_shares: u8 = 0u8;
        for i: u8 in 0u8..MAX_ON_CHAIN_RECONSTRUCT_SHARES{
            non_zero_shares += (shares[i].index != 0field) as u8;
        }
        return non_zero_shares;
    }

    transition submit_shares_to_validators(
        private validator_shares: [ValidatorShareData; 16],
        private custodied_data: Custody,
    ) -> (
        ValidatorShare,
        ValidatorShare,
        ValidatorShare,
        ValidatorShare,
        ValidatorShare,
        ValidatorShare,
        ValidatorShare,
        ValidatorShare,
        ValidatorShare,
        ValidatorShare,
        ValidatorShare,
        ValidatorShare,
        ValidatorShare,
        ValidatorShare,
        ValidatorShare,
        ValidatorShare,
    ){
        assert_eq(self.caller, data_custody_protocol.aleo);

        let validator_share_0: ValidatorShare = ValidatorShare {
            owner: validator_shares[0u8].validator,
            share: validator_shares[0u8].share,
            custody: custodied_data,
            weight: validator_shares[0u8].weight
        };
        let validator_share_1: ValidatorShare = ValidatorShare {
            owner: validator_shares[1u8].validator,
            share: validator_shares[1u8].share,
            custody: custodied_data,
            weight: validator_shares[1u8].weight
        };
        let validator_share_2: ValidatorShare = ValidatorShare {
            owner: validator_shares[2u8].validator,
            share: validator_shares[2u8].share,
            custody: custodied_data,
            weight: validator_shares[2u8].weight
        };
        let validator_share_3: ValidatorShare = ValidatorShare {
            owner: validator_shares[3u8].validator,
            share: validator_shares[3u8].share,
            custody: custodied_data,
            weight: validator_shares[3u8].weight
        };
        let validator_share_4: ValidatorShare = ValidatorShare {
            owner: validator_shares[4u8].validator,
            share: validator_shares[4u8].share,
            custody: custodied_data,
            weight: validator_shares[4u8].weight
        };
        let validator_share_5: ValidatorShare = ValidatorShare {
            owner: validator_shares[5u8].validator,
            share: validator_shares[5u8].share,
            custody: custodied_data,
            weight: validator_shares[5u8].weight
        };
        let validator_share_6: ValidatorShare = ValidatorShare {
            owner: validator_shares[6u8].validator,
            share: validator_shares[6u8].share,
            custody: custodied_data,
            weight: validator_shares[6u8].weight
        };
        let validator_share_7: ValidatorShare = ValidatorShare {
            owner: validator_shares[7u8].validator,
            share: validator_shares[7u8].share,
            custody: custodied_data,
            weight: validator_shares[7u8].weight
        };
        let validator_share_8: ValidatorShare = ValidatorShare {
            owner: validator_shares[8u8].validator,
            share: validator_shares[8u8].share,
            custody: custodied_data,
            weight: validator_shares[8u8].weight
        };
        let validator_share_9: ValidatorShare = ValidatorShare {
            owner: validator_shares[9u8].validator,
            share: validator_shares[9u8].share,
            custody: custodied_data,
            weight: validator_shares[9u8].weight
        };
        let validator_share_10: ValidatorShare = ValidatorShare {
            owner: validator_shares[10u8].validator,
            share: validator_shares[10u8].share,
            custody: custodied_data,
            weight: validator_shares[10u8].weight
        };
        let validator_share_11: ValidatorShare = ValidatorShare {
            owner: validator_shares[11u8].validator,
            share: validator_shares[11u8].share,
            custody: custodied_data,
            weight: validator_shares[11u8].weight
        };
        let validator_share_12: ValidatorShare = ValidatorShare {
            owner: validator_shares[12u8].validator,
            share: validator_shares[12u8].share,
            custody: custodied_data,
            weight: validator_shares[12u8].weight
        };
        let validator_share_13: ValidatorShare = ValidatorShare {
            owner: validator_shares[13u8].validator,
            share: validator_shares[13u8].share,
            custody: custodied_data,
            weight: validator_shares[13u8].weight
        };
        let validator_share_14: ValidatorShare = ValidatorShare {
            owner: validator_shares[14u8].validator,
            share: validator_shares[14u8].share,
            custody: custodied_data,
            weight: validator_shares[14u8].weight
        };
        let validator_share_15: ValidatorShare = ValidatorShare {
            owner: validator_shares[15u8].validator,
            share: validator_shares[15u8].share,
            custody: custodied_data,
            weight: validator_shares[15u8].weight
        };

        return (
            validator_share_0,
            validator_share_1,
            validator_share_2,
            validator_share_3,
            validator_share_4,
            validator_share_5,
            validator_share_6,
            validator_share_7,
            validator_share_8,
            validator_share_9,
            validator_share_10,
            validator_share_11,
            validator_share_12,
            validator_share_13,
            validator_share_14,
            validator_share_15
        );
    }
    

    transition submit_requests_to_validators(
        private validators: [address; 16],
        private custody_hash: field,
        private request_id: field,
        private to: address,
        private validator_fee_amount: u64,
    ) -> (
        WithdrawRequest,
        WithdrawRequest,
        WithdrawRequest,
        WithdrawRequest,
        WithdrawRequest,
        WithdrawRequest,
        WithdrawRequest,
        WithdrawRequest,
        WithdrawRequest,
        WithdrawRequest,
        WithdrawRequest,
        WithdrawRequest,
        WithdrawRequest,
        WithdrawRequest,
        WithdrawRequest,
        WithdrawRequest
    ){
        assert_eq(self.caller, data_custody_protocol.aleo);

        let withdraw_request_0: WithdrawRequest = WithdrawRequest {
            owner: validators[0u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
        let withdraw_request_1: WithdrawRequest = WithdrawRequest {
            owner: validators[1u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
        let withdraw_request_2: WithdrawRequest = WithdrawRequest {
            owner: validators[2u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
        let withdraw_request_3: WithdrawRequest = WithdrawRequest {
            owner: validators[3u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
        let withdraw_request_4: WithdrawRequest = WithdrawRequest {
            owner: validators[4u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
        let withdraw_request_5: WithdrawRequest = WithdrawRequest {
            owner: validators[5u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
        let withdraw_request_6: WithdrawRequest = WithdrawRequest {
            owner: validators[6u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
        let withdraw_request_7: WithdrawRequest = WithdrawRequest {
            owner: validators[7u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
        let withdraw_request_8: WithdrawRequest = WithdrawRequest {
            owner: validators[8u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
        let withdraw_request_9: WithdrawRequest = WithdrawRequest {
            owner: validators[9u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
        let withdraw_request_10: WithdrawRequest = WithdrawRequest {
            owner: validators[10u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
        let withdraw_request_11: WithdrawRequest = WithdrawRequest {
            owner: validators[11u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
        let withdraw_request_12: WithdrawRequest = WithdrawRequest {
            owner: validators[12u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
        let withdraw_request_13: WithdrawRequest = WithdrawRequest {
            owner: validators[13u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
        let withdraw_request_14: WithdrawRequest = WithdrawRequest {
            owner: validators[14u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
        let withdraw_request_15: WithdrawRequest = WithdrawRequest {
            owner: validators[15u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };

        return (
            withdraw_request_0,
            withdraw_request_1,
            withdraw_request_2,
            withdraw_request_3,
            withdraw_request_4,
            withdraw_request_5,
            withdraw_request_6,
            withdraw_request_7,
            withdraw_request_8,
            withdraw_request_9,
            withdraw_request_10,
            withdraw_request_11,
            withdraw_request_12,
            withdraw_request_13,
            withdraw_request_14,
            withdraw_request_15,
        );
    }


    async transition process_request_as_validator(
        private validator_share: ValidatorShare,
        private withdraw_request: WithdrawRequest,
    ) -> (DestinationShare, ValidatorShare, Future) {
        let custody_hash: field = hash_custody(validator_share.custody);
        assert_eq(withdraw_request.custody_hash, custody_hash);

        let destination_share: DestinationShare = DestinationShare {
            owner: withdraw_request.to,
            share: validator_share.share,
            custody_hash: custody_hash
        };
        let out_validator_share: ValidatorShare = ValidatorShare {
            owner: validator_share.owner,
            share: validator_share.share,
            custody: validator_share.custody,
            weight: validator_share.weight,
        };

        let unlock_fee_future: Future = credits.aleo/transfer_public(
            self.caller,
            withdraw_request.fee_amount,
        );

        let protocol_core_future: Future = 
            dcp_public_states.aleo/process_request_as_validator(
                custody_hash,
                withdraw_request.request_id,
                validator_share.custody.threshold,
                validator_share.weight
            );
        let process_request_as_validator_future: Future =
            finalize_process_request_as_validator(
                protocol_core_future,
                unlock_fee_future
            );
        
        return (
            destination_share,
            out_validator_share,
            process_request_as_validator_future
        );
    }
    async function finalize_process_request_as_validator(
        protocol_core_future: Future,
        unlock_fee_future: Future,
    ) {
        protocol_core_future.await();
        unlock_fee_future.await();
    }


    transition mint_null_destination_share(
        custody_hash: field,
    ) -> DestinationShare{
        return DestinationShare{
            owner: self.signer,
            share: Share{
                share_val: 0field,
                index: 0field,
            },
            custody_hash: custody_hash
        };
    }


    // Due to snarkvm limits,
    // secret can be reconstructed "on chain" only from 14 shares

    // This feature can alternatively be reproduced, for any amount of shares,
    // with a commitment scheme:
    // - Client program calls custody data twice, with:
    //   + The actual stored value.
    //   + A blinding factor.
    // - Client program publishes committment of blinding factor
    // - After data withdraw and offchain reconstruction of both stored value
    // and blinding factor, they can be used as transition inputs and be proven
    // valid within the transition by checking that commitment matches the one
    // published earlier.

    transition reconstruct_secret(
        destination_share_0: DestinationShare,
        destination_share_1: DestinationShare,
        destination_share_2: DestinationShare,
        destination_share_3: DestinationShare,
        destination_share_4: DestinationShare,
        destination_share_5: DestinationShare,
        destination_share_6: DestinationShare,
        destination_share_7: DestinationShare,
        destination_share_8: DestinationShare,
        destination_share_9: DestinationShare,
        destination_share_10: DestinationShare,
        destination_share_11: DestinationShare,
        destination_share_12: DestinationShare,
        destination_share_13: DestinationShare,
        custody_key: field,
        threshold: u8,
    ) -> ReconstructedSecret {
        let custody: Custody = Custody{
            origin: self.caller,
            custody_key: custody_key,
            threshold: threshold
        };
        assert_eq(hash_custody(custody), destination_share_0.custody_hash);
        // TODO DETERMINE IF WE SHOULD: only allow origin custodier program to reconstruct the share
        // assert_eq(self.caller, custody.origin);
        let shares: [Share; 14] = [ // MAX_ON_CHAIN_RECONSTRUCT_SHARES
            destination_share_0.share,
            destination_share_1.share,
            destination_share_2.share,
            destination_share_3.share,
            destination_share_4.share,
            destination_share_5.share,
            destination_share_6.share,
            destination_share_7.share,
            destination_share_8.share,
            destination_share_9.share,
            destination_share_10.share,
            destination_share_11.share,
            destination_share_12.share,
            destination_share_13.share,
        ];
        let non_zero_shares: u8 = count_relevant_shares(shares);
        assert(non_zero_shares >= custody.threshold);
        let secret: field = reconstruct(shares);
        let reconstructed_secret: ReconstructedSecret = ReconstructedSecret {
            owner: self.caller,
            secret: secret,
            custody_hash: destination_share_0.custody_hash
        };
        return reconstructed_secret;
    }


    transition join_shares_as_validator(
        private validator_share_0: ValidatorShare,
        private validator_share_1: ValidatorShare,
    ) -> ValidatorShare {
        assert(validator_share_0.custody == validator_share_1.custody);
        assert(validator_share_0.share.index == validator_share_1.share.index);

        let out_share: Share = Share {
            share_val: (
                validator_share_0.share.share_val
                + validator_share_1.share.share_val
            ),
            index: validator_share_0.share.index,
        };

        return ValidatorShare {
            owner: self.signer,
            share: out_share,
            custody: validator_share_0.custody,
            weight: validator_share_0.weight + validator_share_1.weight
        };
    }

    // ...
    

    transition join_16_shares_as_validator(
        private validator_share_0: ValidatorShare,
        private validator_share_1: ValidatorShare,
        private validator_share_2: ValidatorShare,
        private validator_share_3: ValidatorShare,
        private validator_share_4: ValidatorShare,
        private validator_share_5: ValidatorShare,
        private validator_share_6: ValidatorShare,
        private validator_share_7: ValidatorShare,
        private validator_share_8: ValidatorShare,
        private validator_share_9: ValidatorShare,
        private validator_share_10: ValidatorShare,
        private validator_share_11: ValidatorShare,
        private validator_share_12: ValidatorShare,
        private validator_share_13: ValidatorShare,
        private validator_share_14: ValidatorShare,
        private validator_share_15: ValidatorShare,
    ) -> ValidatorShare {
        assert(validator_share_0.custody == validator_share_1.custody);
        assert(validator_share_0.custody == validator_share_2.custody);
        assert(validator_share_0.custody == validator_share_3.custody);
        assert(validator_share_0.custody == validator_share_4.custody);
        assert(validator_share_0.custody == validator_share_5.custody);
        assert(validator_share_0.custody == validator_share_6.custody);
        assert(validator_share_0.custody == validator_share_7.custody);
        assert(validator_share_0.custody == validator_share_8.custody);
        assert(validator_share_0.custody == validator_share_9.custody);
        assert(validator_share_0.custody == validator_share_10.custody);
        assert(validator_share_0.custody == validator_share_11.custody);
        assert(validator_share_0.custody == validator_share_12.custody);
        assert(validator_share_0.custody == validator_share_13.custody);
        assert(validator_share_0.custody == validator_share_14.custody);
        assert(validator_share_0.custody == validator_share_15.custody);

        assert(validator_share_0.share.index == validator_share_1.share.index);
        assert(validator_share_0.share.index == validator_share_2.share.index);
        assert(validator_share_0.share.index == validator_share_3.share.index);
        assert(validator_share_0.share.index == validator_share_4.share.index);
        assert(validator_share_0.share.index == validator_share_5.share.index);
        assert(validator_share_0.share.index == validator_share_6.share.index);
        assert(validator_share_0.share.index == validator_share_7.share.index);
        assert(validator_share_0.share.index == validator_share_8.share.index);
        assert(validator_share_0.share.index == validator_share_9.share.index);
        assert(validator_share_0.share.index == validator_share_10.share.index);
        assert(validator_share_0.share.index == validator_share_11.share.index);
        assert(validator_share_0.share.index == validator_share_12.share.index);
        assert(validator_share_0.share.index == validator_share_13.share.index);
        assert(validator_share_0.share.index == validator_share_14.share.index);
        assert(validator_share_0.share.index == validator_share_15.share.index);

        let share_val: field = (
            validator_share_0.share.share_val
            + validator_share_1.share.share_val
            + validator_share_2.share.share_val
            + validator_share_3.share.share_val
            + validator_share_4.share.share_val
            + validator_share_5.share.share_val
            + validator_share_6.share.share_val
            + validator_share_7.share.share_val
            + validator_share_8.share.share_val
            + validator_share_9.share.share_val
            + validator_share_10.share.share_val
            + validator_share_11.share.share_val
            + validator_share_12.share.share_val
            + validator_share_13.share.share_val
            + validator_share_14.share.share_val
            + validator_share_15.share.share_val
        );
        let out_share: Share = Share {
            share_val: share_val,
            index: validator_share_0.share.index,
        };

        return ValidatorShare {
            owner: self.signer,
            share: out_share,
            custody: validator_share_0.custody,
            weight: (
                validator_share_0.weight
                + validator_share_1.weight
                + validator_share_2.weight
                + validator_share_3.weight
                + validator_share_4.weight
                + validator_share_5.weight
                + validator_share_6.weight
                + validator_share_7.weight
                + validator_share_8.weight
                + validator_share_9.weight
                + validator_share_10.weight
                + validator_share_11.weight
                + validator_share_12.weight
                + validator_share_13.weight
                + validator_share_14.weight
                + validator_share_15.weight
            )
        };
    }
}
