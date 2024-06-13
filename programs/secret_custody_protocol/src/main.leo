
/*
    Protocol to allow programs to custody and distribute private data.

    Next Step:
        - Validator credits incentive
            + add request_data_as_program transition a credits record input, and k*amount
            + distribute amount/k on process_request_as_validator

    Limit:
    15 validators maximum limit (16 max transition outputs - 1 future).
    Solvable by using multiple transactions...

    contact@aleo.store - Pierre-André LONG
*/

import protocol_validators.aleo;

program secret_custody_protocol.aleo {
    // hash(Custody) => CustodyState
    mapping custodies: field => CustodyState;
    // hash(Custody) => Amount of shares submitted from validators to destination
    mapping submitted_shares: field => u8;

    struct CustodyState {
        validator_set_index: u64,
        requested: bool
    }

    struct Custody {
        initiator: address,
        data_address: address,
        threshold: u8,
    }

    struct Share {
        share_val: field,
        index: field,
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


    function evaluate_polynomial(
        coefficients: [field; 14],
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
        private coefficients: [field; 14],
        private validators: [address; 15],
        private threshold: u8  // <= 15
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
        Future
    ){
        assert_neq(self.caller, self.signer); // caller must be a program
        let secret: field = data_view_key as field;

        let data_address: address = (data_view_key * group::GEN) as address;
        let custodied_data: Custody = Custody {
            initiator: self.caller,
            data_address: data_address,
            threshold: threshold
        };
        let custody_hash: field = hash_custody(custodied_data);

        let index_0: field = 1field;
        let validator_share_0: ValidatorShare = ValidatorShare {
            owner: validators[0u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_0, secret),
                index: index_0
            },
            custody: custodied_data
        };

        let index_1: field = 2field;
        let validator_share_1: ValidatorShare = ValidatorShare {
            owner: validators[1u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_1, secret),
                index: index_1
            },
            custody: custodied_data
        };

        let index_2: field = 3field;
        let validator_share_2: ValidatorShare = ValidatorShare {
            owner: validators[2u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_2, secret),
                index: index_2
            },
            custody: custodied_data
        };

        let index_3: field = 4field;
        let validator_share_3: ValidatorShare = ValidatorShare {
            owner: validators[3u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_3, secret),
                index: index_3
            },
            custody: custodied_data
        };
        
        let index_4: field = 5field;
        let validator_share_4: ValidatorShare = ValidatorShare {
            owner: validators[4u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_4, secret),
                index: index_4
            },
            custody: custodied_data
        };

        let index_5: field = 6field;
        let validator_share_5: ValidatorShare = ValidatorShare {
            owner: validators[5u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_5, secret),
                index: index_5
            },
            custody: custodied_data
        };

        let index_6: field = 7field;
        let validator_share_6: ValidatorShare = ValidatorShare {
            owner: validators[6u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_6, secret),
                index: index_6
            },
            custody: custodied_data
        };

        let index_7: field = 8field;
        let validator_share_7: ValidatorShare = ValidatorShare {
            owner: validators[7u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_7, secret),
                index: index_7
            },
            custody: custodied_data
        };

        let index_8: field = 9field;
        let validator_share_8: ValidatorShare = ValidatorShare {
            owner: validators[8u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_8, secret),
                index: index_8
            },
            custody: custodied_data
        };
        
        let index_9: field = 10field;
        let validator_share_9: ValidatorShare = ValidatorShare {
            owner: validators[9u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_9, secret),
                index: index_9
            },
            custody: custodied_data
        };

        let index_10: field = 11field;
        let validator_share_10: ValidatorShare = ValidatorShare {
            owner: validators[10u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_10, secret),
                index: index_10
            },
            custody: custodied_data
        };

        let index_11: field = 12field;
        let validator_share_11: ValidatorShare = ValidatorShare {
            owner: validators[11u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_11, secret),
                index: index_11
            },
            custody: custodied_data
        };

        let index_12: field = 13field;
        let validator_share_12: ValidatorShare = ValidatorShare {
            owner: validators[12u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_12, secret),
                index: index_12
            },
            custody: custodied_data
        };

        let index_13: field = 14field;
        let validator_share_13: ValidatorShare = ValidatorShare {
            owner: validators[13u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_13, secret),
                index: index_13
            },
            custody: custodied_data
        };
        
        let index_14: field = 15field;
        let validator_share_14: ValidatorShare = ValidatorShare {
            owner: validators[14u8],
            share: Share {
                share_val: evaluate_polynomial(coefficients, threshold, index_14, secret),
                index: index_14
            },
            custody: custodied_data
        };


        let custody_data_as_program_future: Future = finalize_custody_data_as_program(
            custody_hash,
            validators
        );

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
            custody_data_as_program_future
        );
    }
    async function finalize_custody_data_as_program(
        custody_hash: field,
        validators: [address; 15],
    ){
        assert(custodies.contains(custody_hash).not());

        let validator_sets_len: u64 = 
            protocol_validators.aleo/validator_sets_length.get(true);
        let validator_set_index: u64 = validator_sets_len - 1u64;
        let validator_set: [address; 15] =
            protocol_validators.aleo/validator_sets.get(validator_set_index);
        assert_eq(validators, validator_set);

        let custody_state: CustodyState = CustodyState {
            validator_set_index: validator_set_index,
            requested: false
        };
        custodies.set(custody_hash, custody_state);
    }


    async transition request_data_as_program(
        private data_address: address,
        private to: address,
        private threshold: u8,
        public validators: [address; 15],
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
        Future
    ){
        assert_neq(self.caller, self.signer); // caller must be a program
        let custodied_data: Custody = Custody {
            initiator: self.caller,
            data_address: data_address,
            threshold: threshold
        };
        let custody_hash: field = hash_custody(custodied_data);

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

        let request_data_as_program_future: Future = finalize_request_data_as_program(
            custody_hash,
            validators
        );

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
            request_data_as_program_future
        );
    }
    async function finalize_request_data_as_program(
        custody_hash: field,
        validators: [address; 15],
    ){
        let custody_state: CustodyState = custodies.get(custody_hash);

        assert(custody_state.requested.not());

        let validator_set: [address; 15] =
            protocol_validators.aleo/validator_sets.get(custody_state.validator_set_index);
        assert_eq(validators, validator_set);

        let new_custody_state: CustodyState = CustodyState {
            validator_set_index: custody_state.validator_set_index,
            requested: true
        };
        custodies.set(custody_hash, new_custody_state);
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

        let process_request_as_validator_future: Future = 
            finalize_process_request_as_validator(
                custody_hash
            );
        
        return (
            destination_share,
            process_request_as_validator_future
        );
    }
    async function finalize_process_request_as_validator(
        custody_hash: field
    ) {
        let submitted: u8 = submitted_shares.get_or_use(custody_hash, 0u8);
        submitted_shares.set(custody_hash, submitted + 1u8);
    }


    // Assert at least k of n shares processed
    async transition assert_completed_as_program(
        private data_address: address,
        public threshold: u8,
    ) -> (
        Future
    ){
        assert_neq(self.caller, self.signer); // caller must be a program
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
        let submitted: u8 = submitted_shares.get_or_use(custody_hash, 0u8);
        assert(submitted >= threshold);
    }
}
