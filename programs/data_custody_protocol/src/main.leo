/*
    Protocol to allow programs to custody and distribute private data.

    contact@aleo.store - Pierre-André LONG
*/

import adcp_public_states.aleo;
import adcp_private_states.aleo;

program data_custody_protocol.aleo {
    const MAX_VALIDATORS: u8 = 16u8;
    const MAX_VALIDATORS_MINUS_1: u8 = 15u8;

    inline hash_custody(custody: Custody) -> field {
        return BHP256::hash_to_field(custody);
    }

    inline evaluate_polynomial(
        coefficients: [field; 15], // MAX_VALIDATORS_MINUS_1
        threshold: u8,
        eval_point: field,
        secret: field
    ) -> field {
        let y: field = secret;
        let x_pow: field = 1field;
        for i: u8 in 0u8..MAX_VALIDATORS_MINUS_1 {
            x_pow *= eval_point;
            y += (i < threshold-1u8) ? coefficients[i] * x_pow : 0field;
        }
        return y;
    }

    inline is_some_coefficient_zero(coefficients: [field; 15]) -> bool { // MAX_VALIDATORS_MINUS_1
        let result: bool = false;
        for i: u8 in 0u8..MAX_VALIDATORS_MINUS_1 {
            result ||= coefficients[i] == 0field;
        }
        return result;
    }


    /*
        let secret: field = data_view_key as field;
        let data_address: address = (data_view_key * group::GEN) as address;
        let custody_id: field = BHP256::commit_to_field(data_address, data_address_obfuscator);
    */

    async transition custody_data_as_program(
        private secret: field,
        private custody_id: field,
        public maximum_requests: u128,
        private coefficients: [field; 15], // MAX_VALIDATORS_MINUS_1
        public validators: [address; 16], // MAX_VALIDATORS
        private threshold: u8,  // <= MAX_VALIDATORS
    ) -> Future {
        assert_neq(self.caller, self.signer);
        assert(is_some_coefficient_zero(coefficients).not());

        let custodied_data: Custody = Custody {
            initiator: self.caller,
            custody_id: custody_id,
            threshold: threshold
        };
        let custody_hash: field = hash_custody(custodied_data);

        for i: u8 in 0u8..MAX_VALIDATORS {
            let index: field = (i+1u8) as field;
            let validator_share: ValidatorShareData = ValidatorShareData {
                validator: validators[i],
                share: Share {
                    share_val: evaluate_polynomial(coefficients, threshold, index, secret),
                    index: index
                },
                weight: 1u64
            };
            adcp_private_states.aleo/submit_share_to_validator(
                validator_share,
                custodied_data
            );
        }

        let protocol_core_future: Future = adcp_public_states.aleo/custody_data_as_program(
            custody_hash,
            validators,
            maximum_requests
        );

        return finalize_custody_data_as_program(
            protocol_core_future
        );
    }
    async function finalize_custody_data_as_program(
        protocol_core_future: Future
    ){
        protocol_core_future.await();
    }


    async transition request_data_as_program(
        private custody_id: field,
        private request_id: field,
        private to: address,
        private threshold: u8,
        public validators: [address; 16], // MAX_VALIDATORS
        private validator_fee: u64,
        private protocol_fee_record: credits.aleo/credits,
    ) -> (credits.aleo/credits, Future) {
        assert_neq(self.caller, self.signer);
        let custodied_data: Custody = Custody {
            initiator: self.caller,
            custody_id: custody_id,
            threshold: threshold
        };
        let custody_hash: field = hash_custody(custodied_data);

        for i: u8 in 0u8..MAX_VALIDATORS {
            adcp_private_states.aleo/submit_request_to_validator(
                validators[i],
                custody_hash,
                request_id,
                to,
                validator_fee,
            );
        }

        let protocol_fee_amount: u64 = (threshold as u64) * validator_fee;
        let (protocol_fee_change, lock_fee_future): (credits.aleo/credits, Future) =
            credits.aleo/transfer_private_to_public(
                protocol_fee_record,
                adcp_private_states.aleo,
                protocol_fee_amount,
            );

        let protocol_core_future: Future = adcp_public_states.aleo/request_data_as_program(
            custody_hash,
            request_id,
            validators
        );

        let request_data_as_program_future: Future = finalize_request_data_as_program(
            protocol_core_future,
            lock_fee_future
        );
        return (protocol_fee_change, request_data_as_program_future);
    }
    async function finalize_request_data_as_program(
        protocol_core_future: Future,
        lock_fee_future: Future
    ){
        protocol_core_future.await();
        lock_fee_future.await();
    }


    // Assert at least k of n shares processed
    async transition assert_completed_as_program(
        private custody_id: field,
        public request_id: field,
        public threshold: u8,
    ) -> (
        Future
    ){
        assert_neq(self.caller, self.signer);
        let custody: Custody = Custody {
            initiator: self.caller,
            custody_id: custody_id,
            threshold: threshold
        };
        let custody_hash: field = hash_custody(custody);
        let assert_completed_as_program_future: Future
            = finalize_assert_completed_as_program(
                custody_hash,
                request_id,
                threshold
            );

        return assert_completed_as_program_future;
    }
    async function finalize_assert_completed_as_program(
        custody_hash: field,
        request_id: field,
        threshold: u8
    ) {
        let submitted: u8 = adcp_public_states.aleo/requests.get(request_id);
        assert(submitted >= threshold);
    }
}
