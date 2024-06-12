
/* 
    Protocol to allow programs to custody and distribute private data.

    15 validators maximum limit (16 max transition outputs - 1 future).

    Next Steps:
        - Validator credits incentive
            + add request_data_as_program transition a credits record input.
            + distribute this input
        - Dynamic validators update (through vote system).
*/

program secret_custody_protocol.aleo {
    const validator_1: address = aleo1rupdxnwys2qktts6dqy7l4pjvng0ruapjxsht6ftsjlcmupl6c8sezw5n3; // APrivateKey1zkpGLq4y2tb8f54kkc1hKN3SWtcGDBikqWoHdx5xw2iLoLd
    const validator_2: address = aleo1euegv9rw05xgkwrlsx4dy5kqn8su0pld3ufslucdrssc57mwkg8q4p43vc; // APrivateKey1zkp3Giu2Jd5L8VTiqVj3grFwaBtmfYdk558F7dTQRJxqJes
    const validator_3: address = aleo1q00cjh3mzqydlt42z8duljxecxvtvz5zh84qs9u2pxzacatucvzsp4jzhq; // APrivateKey1zkp4gdof5nDnAKk4obyoWFBDREzbFZTEoAjJzKKq73YQrDa
    const validator_4: address = aleo1z3vr8t088cwgezuw06g327yawwej7vyvvfmp5q598pvz4h9chczsjr6cwr; // APrivateKey1zkpAjA9UguqqCRYvCfZCKjF8wwp6U1TeYxo8HHV67prV357
    const validator_5: address = aleo1pusq67wsnw0jhrpv9t2qu7mm2keh428udk7psjnkckyx59sp3g9s9mjnet; // APrivateKey1zkp3rJqDo8vV7KrGk8dSS68L2hrwy2eYv2tr2sPXtM9BphK

    const validators_threshold: u8 = 3u8;

    // hash(Custody) => bool
    mapping data_requested: field => bool;
    // hash(WithdrawRequestData) => bool
    mapping data_submitted: field => bool;


    struct Custody {
        initiator: address,
        data_address: address,
    }

    struct Share {
        share_val: field,
        index: field,
    }

    struct WithdrawRequestData {
        custody_hash: field,
        to: address,
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


    inline hash_withdraw(withdraw_request_data: WithdrawRequestData) -> field {
        return BHP256::hash_to_field(withdraw_request_data);
    }

    // Update with (validators_threshold - 1) instead of 2
    function evaluate_polynomial(
        coefficients: [field; 2], eval_point: field, secret: field
    ) -> field {
        let y: field = secret;
        let x_pow: field = 1field;
        for i: u8 in 0u8..2u8 {
            x_pow *= eval_point;
            y += coefficients[i] * x_pow;
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
        private coefficients: [field; 2], // Update with (validators_threshold - 1) instead of 2
    ) -> (
        ValidatorShare, ValidatorShare, ValidatorShare, ValidatorShare, ValidatorShare, Future
    ){
        assert_neq(self.caller, self.signer); // caller must be a program
        let secret: field = data_view_key as field;

        let data_address: address = (data_view_key * group::GEN) as address;
        let custodied_data: Custody = Custody {
            initiator: self.caller,
            data_address: data_address
        };
        let custody_hash: field = hash_custody(custodied_data);

        let index_1: field = 1field;
        let validator_share_1: ValidatorShare = ValidatorShare {
            owner: validator_1,
            share: Share {
                share_val: evaluate_polynomial(coefficients, index_1, secret),
                index: index_1
            },
            custody: custodied_data
        };

        let index_2: field = 2field;
        let validator_share_2: ValidatorShare = ValidatorShare {
            owner: validator_2,
            share: Share {
                share_val: evaluate_polynomial(coefficients, index_2, secret),
                index: index_2
            },
            custody: custodied_data
        };

        let index_3: field = 3field;
        let validator_share_3: ValidatorShare = ValidatorShare {
            owner: validator_3,
            share: Share {
                share_val: evaluate_polynomial(coefficients, index_3, secret),
                index: index_3
            },
            custody: custodied_data
        };
        
        let index_4: field = 4field;
        let validator_share_4: ValidatorShare = ValidatorShare {
            owner: validator_4,
            share: Share {
                share_val: evaluate_polynomial(coefficients, index_4, secret),
                index: index_4
            },
            custody: custodied_data
        };

        let index_5: field = 5field;
        let validator_share_5: ValidatorShare = ValidatorShare {
            owner: validator_5,
            share: Share {
                share_val: evaluate_polynomial(coefficients, index_5, secret),
                index: index_5
            },
            custody: custodied_data
        };

        let custody_data_as_program_future: Future = finalize_custody_data_as_program(
            custody_hash
        );

        return (
            validator_share_1,
            validator_share_2,
            validator_share_3,
            validator_share_4,
            validator_share_5,
            custody_data_as_program_future
        );
    }
    async function finalize_custody_data_as_program(
        custody_hash: field
    ){
        assert(data_requested.contains(custody_hash).not());
        data_requested.set(false);
    }


    async transition request_data_as_program(
        private data_address: address,
        private to: address,
    ) -> (
        WithdrawRequest, WithdrawRequest, WithdrawRequest, WithdrawRequest, WithdrawRequest, Future
    ){
        assert_neq(self.caller, self.signer); // caller must be a program
        let custodied_data: Custody = Custody {
            initiator: self.caller,
            data_address: data_address
        };
        let custody_hash: field = hash_custody(custodied_data);

        let withdraw_request_1: WithdrawRequest = WithdrawRequest {
            owner: validator_1,
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_2: WithdrawRequest = WithdrawRequest {
            owner: validator_2,
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_3: WithdrawRequest = WithdrawRequest {
            owner: validator_3,
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_4: WithdrawRequest = WithdrawRequest {
            owner: validator_4,
            custody_hash: custody_hash,
            to: to
        };
        let withdraw_request_5: WithdrawRequest = WithdrawRequest {
            owner: validator_5,
            custody_hash: custody_hash,
            to: to
        };

        let request_data_as_program_future: Future = finalize_request_data_as_program(
            custody_hash,
        );

        return (
            withdraw_request_1,
            withdraw_request_2,
            withdraw_request_3,
            withdraw_request_4,
            withdraw_request_5,
            request_data_as_program_future
        );
    }
    async function finalize_request_data_as_program(
        custody_hash: field,
    ){
        assert(data_requested.get(custody_hash).not());
        data_requested.set(true);
    }


    async transition process_request_as_validator(
        private validator_share: ValidatorShare,
        private withdraw_request: WithdrawRequest,
    ) -> (DestinationShare, Future) {
        let custody_hash: field = hash_custody(validator_share.custody);
        assert_eq(withdraw_request.custody_hash, custody_hash);

        let withdraw_request_data: WithdrawRequestData = WithdrawRequestData{
            validator: withdraw_request.owner,
            custody_hash: withdraw_request.custody_hash,
        };

        let withdraw_request_data_hash: field = hash_withdraw_request_data(
            withdraw_request_data
        );

        let destination_share: DestinationShare = DestinationShare {
            owner: withdraw_request.to,
            share: validator_share.share
        };

        let process_request_as_validator_future: Future = 
            finalize_process_request_as_validator(
                withdraw_request_data_hash
            );
        
        return (
            destination_share,
            process_request_as_validator_future
        );
    }
    async function finalize_process_request_as_validator(
        withdraw_request_data_hash: field
    ) {
        data_submitted.set(withdraw_request_data_hash, true)
    }


    // Assert at least k of n shares processed
    transition assert_request_completed_as_program(
        private data_address: address,
    ) -> (
        Future
    ){
        assert_neq(self.caller, self.signer); // caller must be a program
        let custody: Custody = Custody {
            initiator: self.caller,
            data_address: data_address
        };
        let custody_hash: field = hash_custody(custody);
        let assert_request_completed_as_program_future: Future
            = finalize_assert_request_completed_as_program(
                custody_hash
            );

        return assert_request_completed_as_program_future;
    }
    async function finalize_assert_request_completed_as_program(
        custody_hash: field
    ) {
        let data_submitted_1: u8 = data_submitted.get_or_use(
            hash_withdraw(
                WithdrawRequestData {
                    validator: validator_1,
                    custody_hash: custody_hash,
                }
            ), false
        ) as u8;

        let data_submitted_2: u8 = data_submitted.get_or_use(
            hash_withdraw(
                WithdrawRequestData {
                    validator: validator_2,
                    custody_hash: custody_hash,
                }
            ), false
        ) as u8;
        
        let data_submitted_3: u8 = data_submitted.get_or_use(
            hash_withdraw(
                WithdrawRequestData {
                    validator: validator_3,
                    custody_hash: custody_hash,
                }
            ), false
        ) as u8;
        
        let data_submitted_4: u8 = data_submitted.get_or_use(
            hash_withdraw(
                WithdrawRequestData {
                    validator: validator_4,
                    custody_hash: custody_hash,
                }
            ), false
        ) as u8;
        
        let data_submitted_5: u8 = data_submitted.get_or_use(
            hash_withdraw(
                WithdrawRequestData {
                    validator: validator_5,
                    custody_hash: custody_hash,
                }
            ), false
        ) as u8;

        let total_submitted: u8 = (
            data_submitted_1
            + data_submitted_2
            + data_submitted_3
            + data_submitted_4
            + data_submitted_5
        );
        assert(total_submitted >= validators_threshold);
    }
}
