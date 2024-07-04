

program dcp_withdraw_requests.aleo {
    record WithdrawRequest {
        owner: address,
        custody_hash: field,
        to: address,
        fee_amount: u64,
        request_id: field
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

    transition spend_withdraw_request(request: WithdrawRequest){
        assert_eq(self.caller, dcp_core_protocol.aleo);
    }
}
