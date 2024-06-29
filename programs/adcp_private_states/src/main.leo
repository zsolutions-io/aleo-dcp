/*
    Send secret shares to validators.

    contact@aleo.store - Pierre-André LONG
*/
import credits.aleo;
import adcp_public_states.aleo;

program adcp_private_states.aleo {
    struct Custody {
        initiator: address,
        custody_id: field,
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
    }


    inline hash_custody(custody: Custody) -> field {
        return BHP256::hash_to_field(custody);
    }


    transition submit_share_to_validator(
        private validator_share_data: ValidatorShareData,
        private custodied_data: Custody,
    ) -> (ValidatorShare){
        assert_eq(self.caller, data_custody_protocol.aleo);

        return ValidatorShare {
            owner: validator_share_data.validator,
            share: validator_share_data.share,
            custody: custodied_data,
            weight: validator_share_data.weight
        };
    }
    

    transition submit_request_to_validator(
        private validator: address,
        private custody_hash: field,
        private request_id: field,
        private to: address,
        private validator_fee_amount: u64,
    ) -> WithdrawRequest {
        assert_eq(self.caller, data_custody_protocol.aleo);

        return WithdrawRequest {
            owner: validator,
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            request_id: request_id
        };
    }


    async transition process_request_as_validator(
        private validator_share: ValidatorShare,
        private withdraw_request: WithdrawRequest,
    ) -> (DestinationShare, Future) {
        let custody_hash: field = hash_custody(validator_share.custody);
        assert_eq(withdraw_request.custody_hash, custody_hash);

        let destination_share: DestinationShare = DestinationShare {
            owner: withdraw_request.to,
            share: validator_share.share
        };

        let unlock_fee_future: Future = credits.aleo/transfer_public(
            self.caller,
            withdraw_request.fee_amount,
        );

        let protocol_core_future: Future = 
            adcp_public_states.aleo/process_request_as_validator(
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
        };

        return ValidatorShare {
            owner: self.signer,
            share: out_share,
            custody: validator_share_1.custody,
            weight: validator_share_1.weight + validator_share_2.weight
        };
    }
}
