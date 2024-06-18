/*
    Send secret shares to validators.

    contact@aleo.store - Pierre-André LONG
*/
import credits.aleo;
import protocol_core.aleo;

program protocol_transfers.aleo {
    struct Custody {
        initiator: address,
        custody_id: field,
        threshold: u8,
    }

    struct Share {
        share_val: field,
        index: field,
        weight: u64
    }

    struct ValidatorShareData {
        validator: address,
        share: Share
    }

    record ValidatorShare {
        owner: address,
        share: Share,
        custody: Custody,
    }

    record WithdrawRequest {
        owner: address,
        custody_hash: field,
        to: address,
    }

    record DestinationShare {
        owner: address,
        share: Share,
    }


    inline hash_custody(custody: Custody) -> field {
        return BHP256::hash_to_field(custody);
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
        };
        let validator_share_1: ValidatorShare = ValidatorShare {
            owner: validator_shares[1u8].validator,
            share: validator_shares[1u8].share,
            custody: custodied_data,
        };
        let validator_share_2: ValidatorShare = ValidatorShare {
            owner: validator_shares[2u8].validator,
            share: validator_shares[2u8].share,
            custody: custodied_data,
        };
        let validator_share_3: ValidatorShare = ValidatorShare {
            owner: validator_shares[3u8].validator,
            share: validator_shares[3u8].share,
            custody: custodied_data,
        };
        let validator_share_4: ValidatorShare = ValidatorShare {
            owner: validator_shares[4u8].validator,
            share: validator_shares[4u8].share,
            custody: custodied_data,
        };
        let validator_share_5: ValidatorShare = ValidatorShare {
            owner: validator_shares[5u8].validator,
            share: validator_shares[5u8].share,
            custody: custodied_data,
        };
        let validator_share_6: ValidatorShare = ValidatorShare {
            owner: validator_shares[6u8].validator,
            share: validator_shares[6u8].share,
            custody: custodied_data,
        };
        let validator_share_7: ValidatorShare = ValidatorShare {
            owner: validator_shares[7u8].validator,
            share: validator_shares[7u8].share,
            custody: custodied_data,
        };
        let validator_share_8: ValidatorShare = ValidatorShare {
            owner: validator_shares[8u8].validator,
            share: validator_shares[8u8].share,
            custody: custodied_data,
        };
        let validator_share_9: ValidatorShare = ValidatorShare {
            owner: validator_shares[9u8].validator,
            share: validator_shares[9u8].share,
            custody: custodied_data,
        };
        let validator_share_10: ValidatorShare = ValidatorShare {
            owner: validator_shares[10u8].validator,
            share: validator_shares[10u8].share,
            custody: custodied_data,
        };
        let validator_share_11: ValidatorShare = ValidatorShare {
            owner: validator_shares[11u8].validator,
            share: validator_shares[11u8].share,
            custody: custodied_data,
        };
        let validator_share_12: ValidatorShare = ValidatorShare {
            owner: validator_shares[12u8].validator,
            share: validator_shares[12u8].share,
            custody: custodied_data,
        };
        let validator_share_13: ValidatorShare = ValidatorShare {
            owner: validator_shares[13u8].validator,
            share: validator_shares[13u8].share,
            custody: custodied_data,
        };
        let validator_share_14: ValidatorShare = ValidatorShare {
            owner: validator_shares[14u8].validator,
            share: validator_shares[14u8].share,
            custody: custodied_data,
        };
        let validator_share_15: ValidatorShare = ValidatorShare {
            owner: validator_shares[15u8].validator,
            share: validator_shares[15u8].share,
            custody: custodied_data,
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
        private to: address,
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
            to: to
        };
        let withdraw_request_1: WithdrawRequest = WithdrawRequest {
            owner: validators[1u8],
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_2: WithdrawRequest = WithdrawRequest {
            owner: validators[2u8],
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_3: WithdrawRequest = WithdrawRequest {
            owner: validators[3u8],
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_4: WithdrawRequest = WithdrawRequest {
            owner: validators[4u8],
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_5: WithdrawRequest = WithdrawRequest {
            owner: validators[5u8],
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_6: WithdrawRequest = WithdrawRequest {
            owner: validators[6u8],
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_7: WithdrawRequest = WithdrawRequest {
            owner: validators[7u8],
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_8: WithdrawRequest = WithdrawRequest {
            owner: validators[8u8],
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_9: WithdrawRequest = WithdrawRequest {
            owner: validators[9u8],
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_10: WithdrawRequest = WithdrawRequest {
            owner: validators[10u8],
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_11: WithdrawRequest = WithdrawRequest {
            owner: validators[11u8],
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_12: WithdrawRequest = WithdrawRequest {
            owner: validators[12u8],
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_13: WithdrawRequest = WithdrawRequest {
            owner: validators[13u8],
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_14: WithdrawRequest = WithdrawRequest {
            owner: validators[14u8],
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_15: WithdrawRequest = WithdrawRequest {
            owner: validators[15u8],
            custody_hash: custody_hash,
            to: to
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
        public validator_fee: u64,
    ) -> (DestinationShare, Future) {
        let custody_hash: field = hash_custody(validator_share.custody);
        assert_eq(withdraw_request.custody_hash, custody_hash);

        let destination_share: DestinationShare = DestinationShare {
            owner: withdraw_request.to,
            share: validator_share.share
        };

        let unlock_fee_future: Future = credits.aleo/transfer_public(
            self.caller,
            validator_fee,
        );

        let protocol_core_future: Future = 
            protocol_core.aleo/process_request_as_validator(
                custody_hash,
                validator_fee,
                validator_share.custody.threshold,
                validator_share.share.weight
            );
        let process_request_as_validator_future: Future =
            finalize_process_request_as_validator(
                protocol_core_future,
                unlock_fee_future
            );
        
        return (
            destination_share,
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


    transition join_shares_as_validator(
        private validator_share_1: ValidatorShare,
        private validator_share_2: ValidatorShare,
    ) -> ValidatorShare {
        assert(
            validator_share_1.custody == validator_share_2.custody
            && validator_share_1.share.index == validator_share_2.share.index
        );

        let out_share: Share = Share {
            share_val: validator_share_1.share.share_val + validator_share_2.share.share_val,
            index: validator_share_1.share.index,
            weight: validator_share_1.share.weight + validator_share_2.share.weight
        };

        return ValidatorShare {
            owner: self.signer,
            share: out_share,
            custody: validator_share_1.custody,
        };
    }
}
