

program dcp_open_requests.aleo {
    record OpenRequest {
        owner: address,
        custody_hash: field,
        to: address,
        fee_amount: u64,
        custody_trace: field,
        expire: u32
    }

    record OpenListRequest {
        owner: address,
        custody_hash: field,
        to: [address;  16],
        fee_amount: u64,
        custody_trace: field,
        expire: u32
    }

    transition submit_requests_to_validators(
        public validators: [address; 16],
        public custody_hash: field,
        private to: address,
        private validator_fee_amount: u64,
        public custody_trace: field,
        public expire_height: u32
    ) -> (
        OpenRequest,
        OpenRequest,
        OpenRequest,
        OpenRequest,
        OpenRequest,
        OpenRequest,
        OpenRequest,
        OpenRequest,
        OpenRequest,
        OpenRequest,
        OpenRequest,
        OpenRequest,
        OpenRequest,
        OpenRequest,
        OpenRequest,
        OpenRequest
    ){
        assert_eq(self.caller, data_custody_protocol.aleo);

        let open_request_0: OpenRequest = OpenRequest {
            owner: validators[0u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_1: OpenRequest = OpenRequest {
            owner: validators[1u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_2: OpenRequest = OpenRequest {
            owner: validators[2u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_3: OpenRequest = OpenRequest {
            owner: validators[3u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_4: OpenRequest = OpenRequest {
            owner: validators[4u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_5: OpenRequest = OpenRequest {
            owner: validators[5u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_6: OpenRequest = OpenRequest {
            owner: validators[6u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_7: OpenRequest = OpenRequest {
            owner: validators[7u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_8: OpenRequest = OpenRequest {
            owner: validators[8u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_9: OpenRequest = OpenRequest {
            owner: validators[9u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_10: OpenRequest = OpenRequest {
            owner: validators[10u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_11: OpenRequest = OpenRequest {
            owner: validators[11u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_12: OpenRequest = OpenRequest {
            owner: validators[12u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_13: OpenRequest = OpenRequest {
            owner: validators[13u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_14: OpenRequest = OpenRequest {
            owner: validators[14u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_15: OpenRequest = OpenRequest {
            owner: validators[15u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };

        return (
            open_request_0,
            open_request_1,
            open_request_2,
            open_request_3,
            open_request_4,
            open_request_5,
            open_request_6,
            open_request_7,
            open_request_8,
            open_request_9,
            open_request_10,
            open_request_11,
            open_request_12,
            open_request_13,
            open_request_14,
            open_request_15,
        );
    }

    transition submit_l_requests_to_validators(
        public validators: [address; 16],
        public custody_hash: field,
        private to: [address; 16],
        private validator_fee_amount: u64,
        public custody_trace: field,
        public expire_height: u32
    ) -> (
        OpenListRequest,
        OpenListRequest,
        OpenListRequest,
        OpenListRequest,
        OpenListRequest,
        OpenListRequest,
        OpenListRequest,
        OpenListRequest,
        OpenListRequest,
        OpenListRequest,
        OpenListRequest,
        OpenListRequest,
        OpenListRequest,
        OpenListRequest,
        OpenListRequest,
        OpenListRequest
    ){
        assert_eq(self.caller, data_custody_protocol.aleo);

        let open_request_0: OpenListRequest = OpenListRequest {
            owner: validators[0u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_1: OpenListRequest = OpenListRequest {
            owner: validators[1u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_2: OpenListRequest = OpenListRequest {
            owner: validators[2u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_3: OpenListRequest = OpenListRequest {
            owner: validators[3u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_4: OpenListRequest = OpenListRequest {
            owner: validators[4u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_5: OpenListRequest = OpenListRequest {
            owner: validators[5u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_6: OpenListRequest = OpenListRequest {
            owner: validators[6u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_7: OpenListRequest = OpenListRequest {
            owner: validators[7u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_8: OpenListRequest = OpenListRequest {
            owner: validators[8u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_9: OpenListRequest = OpenListRequest {
            owner: validators[9u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_10: OpenListRequest = OpenListRequest {
            owner: validators[10u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_11: OpenListRequest = OpenListRequest {
            owner: validators[11u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_12: OpenListRequest = OpenListRequest {
            owner: validators[12u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_13: OpenListRequest = OpenListRequest {
            owner: validators[13u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_14: OpenListRequest = OpenListRequest {
            owner: validators[14u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };
        let open_request_15: OpenListRequest = OpenListRequest {
            owner: validators[15u8],
            custody_hash: custody_hash,
            to: to,
            fee_amount: validator_fee_amount,
            custody_trace: custody_trace,
            expire: expire_height
        };

        return (
            open_request_0,
            open_request_1,
            open_request_2,
            open_request_3,
            open_request_4,
            open_request_5,
            open_request_6,
            open_request_7,
            open_request_8,
            open_request_9,
            open_request_10,
            open_request_11,
            open_request_12,
            open_request_13,
            open_request_14,
            open_request_15,
        );
    }

    transition spend_open_request(request: OpenRequest){
        assert_eq(self.caller, dcp_core_protocol.aleo);
    }

    transition spend_open_l_request(request: OpenListRequest){
        assert_eq(self.caller, dcp_core_protocol.aleo);
    }
}
