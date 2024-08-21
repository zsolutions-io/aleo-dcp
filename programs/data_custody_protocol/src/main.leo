/*
    Protocol to allow programs to custody and distribute private data.

    contact@aleo.store - Pierre-André LONG
*/

import dcp_core_protocol.aleo;
import dcp_validator_shares.aleo;
import dcp_open_requests.aleo;
import credits.aleo;

program data_custody_protocol.aleo {
    const MAX_VALIDATORS: u8 = 16u8;
    const MAX_VALIDATORS_MINUS_1: u8 = 15u8;
    const VALIDATORS_PER_BATCH: u8 = 16u8;

    // 1 block every 5s
    const INCENTIVE_TTL: u32 = 180u32; // blocks, ~15min
    const HEIGHT_MARGIN: u32 = 60u32; // blocks, ~5min


    struct Operation {
        is_addition: bool,
        operand_value: field,
        is_operand_private: bool
    }

    inline hash_custody(custody: Custody) -> field {
        return BHP256::hash_to_field(custody);
    }

    inline compute_trace(operation: Operation, obfuscator: scalar) -> field {
        let operation_hash: field = BHP256::hash_to_field(operation);
        return (
            operation.is_operand_private ? 
            BHP256::commit_to_field(operation_hash, obfuscator) :
            operation_hash
        );
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
        const address_gen: group = 
            522678458525321116977504528531602186870683848189190546523208313015552693483group;
        inline viewkey_to_address(view_key: scalar) -> address {
            return (view_key * address_gen) as address;
        }
        ...
        
        let secret: field = data_view_key as field;
        let data_address: address = viewkey_to_address(data_view_key);
        let custody_key: field = BHP256::commit_to_field(
            data_address, data_address_obfuscator
        );
    */
 
    async transition add_or_mul_private(
        private value_: field,
        private is_addition: bool,
        private custody_key: field,
        private coefficients: [field; 15], // MAX_VALIDATORS_MINUS_1
        public validators: [address; 16], // MAX_VALIDATORS
        private threshold: u8,  // <= MAX_VALIDATORS
        private obfuscator: scalar
    ) -> Future {
        assert(is_some_coefficient_zero(coefficients).not());

        let operation: Operation = Operation {
            is_addition: is_addition,
            operand_value: value_,
            is_operand_private: true
        };

        // initial operation_hash

        let operation_hash: field = BHP256::hash_to_field(operation);
        let operation_trace: field = BHP256::commit_to_field(
            operation_hash, obfuscator
        );

        let custody: Custody = Custody {
            origin: self.caller,
            custody_key: custody_key,
            threshold: threshold
        };
        let custody_hash: field = hash_custody(custody);

        let index_0: field = 1field;
        let validator_share_0: ValidatorShareData = ValidatorShareData {
            validator: validators[0u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_0, value_),
                index: index_0
            }
        };

        let index_1: field = 2field;
        let validator_share_1: ValidatorShareData = ValidatorShareData {
            validator: validators[1u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_1, value_),
                index: index_1
            }
        };

        let index_2: field = 3field;
        let validator_share_2: ValidatorShareData = ValidatorShareData {
            validator: validators[2u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_2, value_),
                index: index_2
            }
        };

        let index_3: field = 4field;
        let validator_share_3: ValidatorShareData = ValidatorShareData {
            validator: validators[3u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_3, value_),
                index: index_3
            }
        };
        
        let index_4: field = 5field;
        let validator_share_4: ValidatorShareData = ValidatorShareData {
            validator: validators[4u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_4, value_),
                index: index_4
            }
        };

        let index_5: field = 6field;
        let validator_share_5: ValidatorShareData = ValidatorShareData {
            validator: validators[5u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_5, value_),
                index: index_5
            }
        };

        let index_6: field = 7field;
        let validator_share_6: ValidatorShareData = ValidatorShareData {
            validator: validators[6u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_6, value_),
                index: index_6
            }
        };

        let index_7: field = 8field;
        let validator_share_7: ValidatorShareData = ValidatorShareData {
            validator: validators[7u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_7, value_),
                index: index_7
            }
        };

        let index_8: field = 9field;
        let validator_share_8: ValidatorShareData = ValidatorShareData {
            validator: validators[8u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_8, value_),
                index: index_8
            }
        };
        
        let index_9: field = 10field;
        let validator_share_9: ValidatorShareData = ValidatorShareData {
            validator: validators[9u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_9, value_),
                index: index_9
            }
        };

        let index_10: field = 11field;
        let validator_share_10: ValidatorShareData = ValidatorShareData {
            validator: validators[10u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_10, value_),
                index: index_10
            }
        };

        let index_11: field = 12field;
        let validator_share_11: ValidatorShareData = ValidatorShareData {
            validator: validators[11u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_11, value_),
                index: index_11
            }
        };

        let index_12: field = 13field;
        let validator_share_12: ValidatorShareData = ValidatorShareData {
            validator: validators[12u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_12, value_),
                index: index_12
            }
        };

        let index_13: field = 14field;
        let validator_share_13: ValidatorShareData = ValidatorShareData {
            validator: validators[13u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_13, value_),
                index: index_13
            }
        };
        
        let index_14: field = 15field;
        let validator_share_14: ValidatorShareData = ValidatorShareData {
            validator: validators[14u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_14, value_),
                index: index_14
            }
        };

        let index_15: field = 16field;
        let validator_share_15: ValidatorShareData = ValidatorShareData {
            validator: validators[15u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_15, value_),
                index: index_15
            }
        };

        let validator_shares: [ValidatorShareData; 16] = [ // VALIDATORS_PER_BATCH
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
        dcp_validator_shares.aleo/submit_shares_to_validators(
            validator_shares,
            custody,
            operation_trace,
            is_addition ? 0u8 : 2u8
        );

        let protocol_core_future: Future = dcp_core_protocol.aleo/custody_data_as_program(
            custody_hash,
            validators,
            operation_trace
        );

        return finalize_add_or_mul_private(
            protocol_core_future
        );
    }
    async function finalize_add_or_mul_private(
        protocol_core_future: Future
    ){
        protocol_core_future.await();
    }


    async transition add_or_mul_public(
        private value_: field,
        private is_addition: bool,
        private custody_key: field,
        public validators: [address; 16], // MAX_VALIDATORS
        private threshold: u8,  // <= MAX_VALIDATORS
    ) -> Future {
        let operation: Operation = Operation {
            is_addition: is_addition,
            operand_value: value_,
            is_operand_private: false
        };
        let operation_trace: field = BHP256::hash_to_field(operation);

        let custody: Custody = Custody {
            origin: self.caller,
            custody_key: custody_key,
            threshold: threshold
        };
        let custody_hash: field = hash_custody(custody);

        let index_0: field = 1field;
        let validator_share_0: ValidatorShareData = ValidatorShareData {
            validator: validators[0u8],
            share: Share {
                share_val: value_,
                index: index_0
            }
        };

        let index_1: field = 2field;
        let validator_share_1: ValidatorShareData = ValidatorShareData {
            validator: validators[1u8],
            share: Share {
                share_val: value_,
                index: index_1
            }
        };

        let index_2: field = 3field;
        let validator_share_2: ValidatorShareData = ValidatorShareData {
            validator: validators[2u8],
            share: Share {
                share_val: value_,
                index: index_2
            }
        };

        let index_3: field = 4field;
        let validator_share_3: ValidatorShareData = ValidatorShareData {
            validator: validators[3u8],
            share: Share {
                share_val: value_,
                index: index_3
            }
        };
        
        let index_4: field = 5field;
        let validator_share_4: ValidatorShareData = ValidatorShareData {
            validator: validators[4u8],
            share: Share {
                share_val: value_,
                index: index_4
            }
        };

        let index_5: field = 6field;
        let validator_share_5: ValidatorShareData = ValidatorShareData {
            validator: validators[5u8],
            share: Share {
                share_val: value_,
                index: index_5
            }
        };

        let index_6: field = 7field;
        let validator_share_6: ValidatorShareData = ValidatorShareData {
            validator: validators[6u8],
            share: Share {
                share_val: value_,
                index: index_6
            }
        };

        let index_7: field = 8field;
        let validator_share_7: ValidatorShareData = ValidatorShareData {
            validator: validators[7u8],
            share: Share {
                share_val: value_,
                index: index_7
            }
        };

        let index_8: field = 9field;
        let validator_share_8: ValidatorShareData = ValidatorShareData {
            validator: validators[8u8],
            share: Share {
                share_val: value_,
                index: index_8
            }
        };
        
        let index_9: field = 10field;
        let validator_share_9: ValidatorShareData = ValidatorShareData {
            validator: validators[9u8],
            share: Share {
                share_val: value_,
                index: index_9
            }
        };

        let index_10: field = 11field;
        let validator_share_10: ValidatorShareData = ValidatorShareData {
            validator: validators[10u8],
            share: Share {
                share_val: value_,
                index: index_10
            }
        };

        let index_11: field = 12field;
        let validator_share_11: ValidatorShareData = ValidatorShareData {
            validator: validators[11u8],
            share: Share {
                share_val: value_,
                index: index_11
            }
        };

        let index_12: field = 13field;
        let validator_share_12: ValidatorShareData = ValidatorShareData {
            validator: validators[12u8],
            share: Share {
                share_val: value_,
                index: index_12
            }
        };

        let index_13: field = 14field;
        let validator_share_13: ValidatorShareData = ValidatorShareData {
            validator: validators[13u8],
            share: Share {
                share_val: value_,
                index: index_13
            }
        };
        
        let index_14: field = 15field;
        let validator_share_14: ValidatorShareData = ValidatorShareData {
            validator: validators[14u8],
            share: Share {
                share_val: value_,
                index: index_14
            }
        };

        let index_15: field = 16field;
        let validator_share_15: ValidatorShareData = ValidatorShareData {
            validator: validators[15u8],
            share: Share {
                share_val: value_,
                index: index_15
            }
        };

        let validator_shares: [ValidatorShareData; 16] = [ // VALIDATORS_PER_BATCH
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
        dcp_validator_shares.aleo/submit_shares_to_validators(
            validator_shares,
            custody,
            operation_trace,
            is_addition ? 0u8 : 1u8
        );

        let protocol_core_future: Future = dcp_core_protocol.aleo/custody_data_as_program(
            custody_hash,
            validators,
            operation_trace
        );

        return finalize_add_or_mul_public(
            protocol_core_future
        );
    }
    async function finalize_add_or_mul_public(
        protocol_core_future: Future
    ){
        protocol_core_future.await();
    }


    async transition request_open(
        private custody_key: field,
        private to: address,
        private threshold: u8,
        public custody_trace: field,
        public validators: [address; 16], // MAX_VALIDATORS
        private validator_fee: u64,
        private protocol_fee_record: credits.aleo/credits,
        public transaction_geneneration_height: u32
    ) -> (credits.aleo/credits, Future) {
        let custody: Custody = Custody {
            origin: self.caller,
            custody_key: custody_key,
            threshold: threshold
        };
        let custody_hash: field = hash_custody(custody);

        let validators_0: [address; 16] = [  // VALIDATORS_PER_BATCH
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
        // Submit batch 1
        dcp_open_requests.aleo/submit_requests_to_validators(
            validators_0,
            custody_hash,
            to,
            validator_fee,
            custody_trace,
            transaction_geneneration_height + HEIGHT_MARGIN + INCENTIVE_TTL
        );

        let protocol_fee_amount: u64 = (MAX_VALIDATORS as u64) * validator_fee;
        let (protocol_fee_change, lock_fee_future): (
            credits.aleo/credits, Future
        ) =
            credits.aleo/transfer_private_to_public(
                protocol_fee_record,
                dcp_validator_fee.aleo,
                protocol_fee_amount,
            );

        let protocol_core_future: Future = dcp_core_protocol.aleo/request_open(
            custody_hash,
            validators,
            custody_trace
        );

        let request_open_future: Future = finalize_request_open(
            transaction_geneneration_height,
            protocol_core_future,
            lock_fee_future
        );
        return (protocol_fee_change, request_open_future);
    }
    async function finalize_request_open(
        pretended_geneneration_height: u32,
        protocol_core_future: Future,
        lock_fee_future: Future
    ){
        let actual_height: u32 = block.height;
        assert(pretended_geneneration_height <= actual_height);
        assert(actual_height <= pretended_geneneration_height + HEIGHT_MARGIN);
        /*

        -------|----------------|---------------------|------------------|---->
         TX gen height   Actual TX height   Max accepted TX height  Incentive dies
                <------------------------------------>
                            HEIGHT_MARGIN
                                                      <----------------->
                                                          INCENTIVE_TTL
        
        */
        protocol_core_future.await();
        lock_fee_future.await();
    }
}
