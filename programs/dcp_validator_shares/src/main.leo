
program dcp_validator_shares.aleo {
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
        share: Share
    }

    record ValidatorShare {
        owner: address,
        share: Share,
        custody: Custody,
        custody_trace: field,
        is_addition: bool
    }

    inline hash_tuple(traces: [field; 2]) -> field{
        return BHP256::hash_to_field(traces);
    }

    transition submit_shares_to_validators(
        private validator_shares: [ValidatorShareData; 16],
        private custody: Custody,
        private custody_trace: field,
        private is_addition: bool,
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
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
        };
        let validator_share_1: ValidatorShare = ValidatorShare {
            owner: validator_shares[1u8].validator,
            share: validator_shares[1u8].share,
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
        };
        let validator_share_2: ValidatorShare = ValidatorShare {
            owner: validator_shares[2u8].validator,
            share: validator_shares[2u8].share,
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
        };
        let validator_share_3: ValidatorShare = ValidatorShare {
            owner: validator_shares[3u8].validator,
            share: validator_shares[3u8].share,
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
        };
        let validator_share_4: ValidatorShare = ValidatorShare {
            owner: validator_shares[4u8].validator,
            share: validator_shares[4u8].share,
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
        };
        let validator_share_5: ValidatorShare = ValidatorShare {
            owner: validator_shares[5u8].validator,
            share: validator_shares[5u8].share,
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
        };
        let validator_share_6: ValidatorShare = ValidatorShare {
            owner: validator_shares[6u8].validator,
            share: validator_shares[6u8].share,
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
        };
        let validator_share_7: ValidatorShare = ValidatorShare {
            owner: validator_shares[7u8].validator,
            share: validator_shares[7u8].share,
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
        };
        let validator_share_8: ValidatorShare = ValidatorShare {
            owner: validator_shares[8u8].validator,
            share: validator_shares[8u8].share,
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
        };
        let validator_share_9: ValidatorShare = ValidatorShare {
            owner: validator_shares[9u8].validator,
            share: validator_shares[9u8].share,
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
        };
        let validator_share_10: ValidatorShare = ValidatorShare {
            owner: validator_shares[10u8].validator,
            share: validator_shares[10u8].share,
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
        };
        let validator_share_11: ValidatorShare = ValidatorShare {
            owner: validator_shares[11u8].validator,
            share: validator_shares[11u8].share,
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
        };
        let validator_share_12: ValidatorShare = ValidatorShare {
            owner: validator_shares[12u8].validator,
            share: validator_shares[12u8].share,
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
        };
        let validator_share_13: ValidatorShare = ValidatorShare {
            owner: validator_shares[13u8].validator,
            share: validator_shares[13u8].share,
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
        };
        let validator_share_14: ValidatorShare = ValidatorShare {
            owner: validator_shares[14u8].validator,
            share: validator_shares[14u8].share,
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
        };
        let validator_share_15: ValidatorShare = ValidatorShare {
            owner: validator_shares[15u8].validator,
            share: validator_shares[15u8].share,
            custody: custody,
            custody_trace: custody_trace,
            is_addition: is_addition
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


    transition join_shares_as_validator(
        private validator_share_0: ValidatorShare,
        private validator_share_1: ValidatorShare,
    ) -> ValidatorShare {
        assert(validator_share_0.custody == validator_share_1.custody);
        assert(validator_share_0.share.index == validator_share_1.share.index);

        let new_share_val: field = (
            validator_share_1.is_addition ?
            (
                validator_share_0.share.share_val 
                + validator_share_1.share.share_val
            ) :
            (
                validator_share_0.share.share_val 
                * validator_share_1.share.share_val
            )
        );
        let out_share: Share = Share {
            share_val: new_share_val,
            index: validator_share_0.share.index,
        };

        let custody_trace: field = hash_tuple([
            validator_share_0.custody_trace,
            validator_share_1.custody_trace
        ]);

        return ValidatorShare {
            owner: self.signer,
            share: out_share,
            custody: validator_share_0.custody,
            custody_trace: custody_trace,
            is_addition: validator_share_1.is_addition
        };
    }
}
