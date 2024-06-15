/*
    Protocol to allow programs to custody and distribute private data.

    Next Step:
        - Multiple aleo credits

    Limit:
    15 validators maximum limit (16 max transition outputs - 1 future).
    Solvable by using multiple transactions...

    contact@aleo.store - Pierre-André LONG
*/

import protocol_core.aleo;
import protocol_transfers.aleo;

program secret_custody_protocol.aleo {
    inline hash_custody(custody: Custody) -> field {
        return BHP256::hash_to_field(custody);
    }

    inline evaluate_polynomial(
        coefficients: [field; 15],
        threshold: u8,
        eval_point: field,
        secret: field
    ) -> field {
        let y: field = secret;
        let x_pow: field = 1field;
        for i: u8 in 0u8..14u8 {
            x_pow *= eval_point;
            y += (i < threshold-1u8) ? coefficients[i] * x_pow : 0field;
        }
        return y;
    }

    /*
        Child program simultanuously (in same transaction):
            - calls receive_precord_as_program(data_view_key)
            - sends any record to ((data_view_key * group::GEN) as address)
        /!\ record becomes read only
    */
    async transition custody_data_as_program(
        private data_view_key: scalar,
        private coefficients: [field; 15],
        public validators: [address; 16],
        private threshold: u8  // <= 15
    ) -> Future {
        assert_neq(self.caller, self.signer);
        assert(
            coefficients[0u8] != 0field
            && coefficients[1u8] != 0field
            && coefficients[2u8] != 0field
            && coefficients[3u8] != 0field
            && coefficients[4u8] != 0field
            && coefficients[5u8] != 0field
            && coefficients[6u8] != 0field
            && coefficients[7u8] != 0field
            && coefficients[8u8] != 0field
            && coefficients[9u8] != 0field
            && coefficients[10u8] != 0field
            && coefficients[11u8] != 0field
            && coefficients[12u8] != 0field
            && coefficients[13u8] != 0field
            && coefficients[14u8] != 0field
        );
        let secret: field = data_view_key as field;

        let data_address: address = (data_view_key * group::GEN) as address;
        let custodied_data: Custody = Custody {
            initiator: self.caller,
            data_address: data_address,
            threshold: threshold
        };
        let custody_hash: field = hash_custody(custodied_data);

        let index_0: field = 1field;
        let validator_share_0: ValidatorShareData = ValidatorShareData {
            validator: validators[0u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_0, secret),
                index: index_0
            }
        };

        let index_1: field = 2field;
        let validator_share_1: ValidatorShareData = ValidatorShareData {
            validator: validators[1u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_1, secret),
                index: index_1
            }
        };

        let index_2: field = 3field;
        let validator_share_2: ValidatorShareData = ValidatorShareData {
            validator: validators[2u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_2, secret),
                index: index_2
            }
        };

        let index_3: field = 4field;
        let validator_share_3: ValidatorShareData = ValidatorShareData {
            validator: validators[3u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_3, secret),
                index: index_3
            }
        };
        
        let index_4: field = 5field;
        let validator_share_4: ValidatorShareData = ValidatorShareData {
            validator: validators[4u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_4, secret),
                index: index_4
            }
        };

        let index_5: field = 6field;
        let validator_share_5: ValidatorShareData = ValidatorShareData {
            validator: validators[5u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_5, secret),
                index: index_5
            }
        };

        let index_6: field = 7field;
        let validator_share_6: ValidatorShareData = ValidatorShareData {
            validator: validators[6u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_6, secret),
                index: index_6
            }
        };

        let index_7: field = 8field;
        let validator_share_7: ValidatorShareData = ValidatorShareData {
            validator: validators[7u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_7, secret),
                index: index_7
            }
        };

        let index_8: field = 9field;
        let validator_share_8: ValidatorShareData = ValidatorShareData {
            validator: validators[8u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_8, secret),
                index: index_8
            }
        };
        
        let index_9: field = 10field;
        let validator_share_9: ValidatorShareData = ValidatorShareData {
            validator: validators[9u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_9, secret),
                index: index_9
            }
        };

        let index_10: field = 11field;
        let validator_share_10: ValidatorShareData = ValidatorShareData {
            validator: validators[10u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_10, secret),
                index: index_10
            }
        };

        let index_11: field = 12field;
        let validator_share_11: ValidatorShareData = ValidatorShareData {
            validator: validators[11u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_11, secret),
                index: index_11
            }
        };

        let index_12: field = 13field;
        let validator_share_12: ValidatorShareData = ValidatorShareData {
            validator: validators[12u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_12, secret),
                index: index_12
            }
        };

        let index_13: field = 14field;
        let validator_share_13: ValidatorShareData = ValidatorShareData {
            validator: validators[13u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_13, secret),
                index: index_13
            }
        };
        
        let index_14: field = 15field;
        let validator_share_14: ValidatorShareData = ValidatorShareData {
            validator: validators[14u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_14, secret),
                index: index_14
            }
        };

        let index_15: field = 16field;
        let validator_share_15: ValidatorShareData = ValidatorShareData {
            validator: validators[15u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_15, secret),
                index: index_15
            }
        };

        let validator_shares: [ValidatorShareData; 16] = [
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
            validator_share_15,
        ];
        protocol_transfers.aleo/submit_shares_to_validators(
            validator_shares,
            custodied_data
        );

        let protocol_core_future: Future = protocol_core.aleo/custody_data_as_program(
            custody_hash,
            validators
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
        private data_address: address,
        private to: address,
        private threshold: u8,
        public validators: [address; 16],
        public validator_fee: u64,
        private protocol_fee_record: credits.aleo/credits,
    ) -> (credits.aleo/credits, Future) {
        assert_neq(self.caller, self.signer);
        let custodied_data: Custody = Custody {
            initiator: self.caller,
            data_address: data_address,
            threshold: threshold
        };
        let custody_hash: field = hash_custody(custodied_data);

        let validators_0: [address; 16] = [
            validators[0u8],
            validators[1u8],
            validators[2u8],
            validators[3u8],
            validators[4u8],
            validators[5u8],
            validators[6u8],
            validators[7u8],
            validators[8u8],
            validators[9u8],
            validators[10u8],
            validators[11u8],
            validators[12u8],
            validators[13u8],
            validators[14u8],
            validators[15u8]
        ];
        protocol_transfers.aleo/submit_requests_to_validators(
            validators_0,
            custody_hash,
            to
        );

        let protocol_fee_amount: u64 = (threshold as u64) * validator_fee;
        let (protocol_fee_change, lock_fee_future): (credits.aleo/credits, Future) =
            credits.aleo/transfer_private_to_public(
                protocol_fee_record,
                self.address,
                protocol_fee_amount,
            );

        let protocol_core_future: Future = protocol_core.aleo/request_data_as_program(
            custody_hash,
            validators,
            validator_fee
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
        private data_address: address,
        public threshold: u8,
    ) -> (
        Future
    ){
        assert_neq(self.caller, self.signer);
        let custody: Custody = Custody {
            initiator: self.caller,
            data_address: data_address,
            threshold: threshold
        };
        let custody_hash: field = hash_custody(custody);
        let assert_completed_as_program_future: Future
            = finalize_assert_completed_as_program(
                custody_hash,
                threshold
            );

        return assert_completed_as_program_future;
    }
    async function finalize_assert_completed_as_program(
        custody_hash: field,
        threshold: u8
    ) {
        let submitted: u8 = protocol_core.aleo/custodies.get(custody_hash).submitted_shares;
        assert(submitted >= threshold);
    }
}
