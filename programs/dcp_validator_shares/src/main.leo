import dcp_destination_shares.aleo;
import dcp_reconstruct_secret.aleo;


program dcp_validator_shares.aleo {
    struct Beaver {
        triple_index: field,
        beaver_type: u8,
        validators: [address; 16]
    }

    struct Custody {
        origin: address,
        custody_key: field,
        threshold: u8,
    }

    struct CustodyWithTrace {
        custody: Custody,
        trace: field
    }

    struct Share {
        share_val: field,
        index: field
    }

    struct ValidatorShareData {
        validator: address,
        share: Share
    }

    struct MulParamsData {
        index: field,
        right_operand_share_val: field,
        left_beaver_share_val: field,
        sum_beaver_share_val: field,
        custody: Custody,
        custody_trace: field,
        left: bool
    }

    record ValidatorShare {
        owner: address,
        share: Share,
        custody: Custody,
        custody_trace: field,
        share_type: u8
    }

    record MulParams {
        owner: address,
        index: field,
        right_operand_share_val: field,
        left_beaver_share_val: field,
        sum_beaver_share_val: field,
        custody: Custody,
        custody_trace: field
    }
    /*
    Types:
        0u8: addition public/private right operand
        1u8: multiplication public right operand
        2u8: multiplication private right operand
        3u8: operation result
        4u8: left beaver triple
        5u8: right beaver triple
    */

    inline hash_tuple(traces: [field; 2]) -> field{
        return BHP256::hash_to_field(traces);
    }

    transition submit_shares_to_validators(
        private validator_shares: [ValidatorShareData; 16],
        private custody: Custody,
        private custody_trace: field,
        private share_type: u8,
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
            share_type: share_type
        };
        let validator_share_1: ValidatorShare = ValidatorShare {
            owner: validator_shares[1u8].validator,
            share: validator_shares[1u8].share,
            custody: custody,
            custody_trace: custody_trace,
            share_type: share_type
        };
        let validator_share_2: ValidatorShare = ValidatorShare {
            owner: validator_shares[2u8].validator,
            share: validator_shares[2u8].share,
            custody: custody,
            custody_trace: custody_trace,
            share_type: share_type
        };
        let validator_share_3: ValidatorShare = ValidatorShare {
            owner: validator_shares[3u8].validator,
            share: validator_shares[3u8].share,
            custody: custody,
            custody_trace: custody_trace,
            share_type: share_type
        };
        let validator_share_4: ValidatorShare = ValidatorShare {
            owner: validator_shares[4u8].validator,
            share: validator_shares[4u8].share,
            custody: custody,
            custody_trace: custody_trace,
            share_type: share_type
        };
        let validator_share_5: ValidatorShare = ValidatorShare {
            owner: validator_shares[5u8].validator,
            share: validator_shares[5u8].share,
            custody: custody,
            custody_trace: custody_trace,
            share_type: share_type
        };
        let validator_share_6: ValidatorShare = ValidatorShare {
            owner: validator_shares[6u8].validator,
            share: validator_shares[6u8].share,
            custody: custody,
            custody_trace: custody_trace,
            share_type: share_type
        };
        let validator_share_7: ValidatorShare = ValidatorShare {
            owner: validator_shares[7u8].validator,
            share: validator_shares[7u8].share,
            custody: custody,
            custody_trace: custody_trace,
            share_type: share_type
        };
        let validator_share_8: ValidatorShare = ValidatorShare {
            owner: validator_shares[8u8].validator,
            share: validator_shares[8u8].share,
            custody: custody,
            custody_trace: custody_trace,
            share_type: share_type
        };
        let validator_share_9: ValidatorShare = ValidatorShare {
            owner: validator_shares[9u8].validator,
            share: validator_shares[9u8].share,
            custody: custody,
            custody_trace: custody_trace,
            share_type: share_type
        };
        let validator_share_10: ValidatorShare = ValidatorShare {
            owner: validator_shares[10u8].validator,
            share: validator_shares[10u8].share,
            custody: custody,
            custody_trace: custody_trace,
            share_type: share_type
        };
        let validator_share_11: ValidatorShare = ValidatorShare {
            owner: validator_shares[11u8].validator,
            share: validator_shares[11u8].share,
            custody: custody,
            custody_trace: custody_trace,
            share_type: share_type
        };
        let validator_share_12: ValidatorShare = ValidatorShare {
            owner: validator_shares[12u8].validator,
            share: validator_shares[12u8].share,
            custody: custody,
            custody_trace: custody_trace,
            share_type: share_type
        };
        let validator_share_13: ValidatorShare = ValidatorShare {
            owner: validator_shares[13u8].validator,
            share: validator_shares[13u8].share,
            custody: custody,
            custody_trace: custody_trace,
            share_type: share_type
        };
        let validator_share_14: ValidatorShare = ValidatorShare {
            owner: validator_shares[14u8].validator,
            share: validator_shares[14u8].share,
            custody: custody,
            custody_trace: custody_trace,
            share_type: share_type
        };
        let validator_share_15: ValidatorShare = ValidatorShare {
            owner: validator_shares[15u8].validator,
            share: validator_shares[15u8].share,
            custody: custody,
            custody_trace: custody_trace,
            share_type: share_type
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


    transition process_trivial_operation(
        private validator_share_0: ValidatorShare,
        private validator_share_1: ValidatorShare,
    ) -> ValidatorShare {
        assert(validator_share_0.custody == validator_share_1.custody);
        assert(validator_share_0.share.index == validator_share_1.share.index);

        assert(
            validator_share_0.share_type == 0u8
            || validator_share_0.share_type == 1u8
            || validator_share_0.share_type == 3u8
        );
        assert(
            validator_share_1.share_type == 0u8
            || validator_share_1.share_type == 1u8
        );
        let is_addition: bool = validator_share_1.share_type == 0u8;

        let new_value: field = (
            is_addition ?
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
            share_val: new_value,
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
            share_type: 3u8
        };
    }

    transition preprocess_private_mul(
        private left_operand: ValidatorShare,
        private right_operand: ValidatorShare,
        private left_beaver: ValidatorShare,
        private right_beaver: ValidatorShare,
        private sum_beaver: ValidatorShare,
        public validators: [address; 16],
        public beaver_triple_index: field
    ) -> MulParams {
        assert_eq(left_operand.custody, right_operand.custody);

        assert_eq(left_beaver.custody.origin, dcp_beaver_triples.aleo);
        assert_eq(right_beaver.custody.origin, dcp_beaver_triples.aleo);
        assert_eq(sum_beaver.custody.origin, dcp_beaver_triples.aleo);

        assert_eq(left_operand.share.index, left_beaver.share.index);
        assert_eq(left_beaver.share.index, right_operand.share.index);
        assert_eq(right_operand.share.index, right_beaver.share.index);

        assert(
            left_operand.share_type == 0u8
            || left_operand.share_type == 1u8
            || left_operand.share_type == 3u8
        );
        assert(right_operand.share_type == 2u8);

        let left_beaver_custody_key: field = BHP256::hash_to_field(
            Beaver {
                triple_index: beaver_triple_index,
                beaver_type: 0u8,
                validators: validators
            }
        );
        let right_beaver_custody_key: field = BHP256::hash_to_field(
            Beaver {
                triple_index: beaver_triple_index,
                beaver_type: 1u8,
                validators: validators
            }
        );
        let sum_beaver_custody_key: field = BHP256::hash_to_field(
            Beaver {
                triple_index: beaver_triple_index,
                beaver_type: 2u8,
                validators: validators
            }
        );

        assert_eq(
            left_beaver.custody.custody_key,
            left_beaver_custody_key
        );
        assert_eq(
            right_beaver.custody.custody_key,
            right_beaver_custody_key
        );
        assert_eq(
            sum_beaver.custody.custody_key,
            sum_beaver_custody_key
        );

        let beaver_summed_with_left_new_value: field = (
            left_operand.share.share_val 
            + left_beaver.share.share_val
        );
        let beaver_summed_with_left_share: Share = Share {
            share_val: beaver_summed_with_left_new_value,
            index: left_operand.share.index,
        };

        let beaver_summed_with_right_new_value: field = (
            right_operand.share.share_val
            + right_beaver.share.share_val
        );
        let beaver_summed_with_right_share: Share = Share {
            share_val: beaver_summed_with_right_new_value,
            index: right_operand.share.index,
        };

        let custody_trace: field = hash_tuple([
            left_operand.custody_trace,
            right_operand.custody_trace
        ]);

        let mul_params: MulParams = MulParams {
            owner: self.signer,
            index: right_operand.share.index,
            right_operand_share_val: right_operand.share.share_val,
            left_beaver_share_val: left_beaver.share.share_val,
            sum_beaver_share_val: sum_beaver.share.share_val,
            custody: left_operand.custody,
            custody_trace: custody_trace
        };
        let mul_params_data_left: MulParamsData = MulParamsData{
            index: right_operand.share.index,
            right_operand_share_val: right_operand.share.share_val,
            left_beaver_share_val: left_beaver.share.share_val,
            sum_beaver_share_val: sum_beaver.share.share_val,
            custody: left_operand.custody,
            custody_trace: custody_trace,
            left: true
        };
        let mul_params_hash_left: field = BHP256::hash_to_field(mul_params_data_left);

        let mul_params_data_right: MulParamsData = MulParamsData{
            index: right_operand.share.index,
            right_operand_share_val: right_operand.share.share_val,
            left_beaver_share_val: left_beaver.share.share_val,
            sum_beaver_share_val: sum_beaver.share.share_val,
            custody: left_operand.custody,
            custody_trace: custody_trace,
            left: false
        };
        let mul_params_hash_right: field = BHP256::hash_to_field(mul_params_data_right);

        dcp_destination_shares.aleo/submit_list_request_shares(
            validators,
            beaver_summed_with_left_share,
            left_operand.custody,
            mul_params_hash_left
        );
        dcp_destination_shares.aleo/submit_list_request_shares(
            validators,
            beaver_summed_with_right_share,
            left_operand.custody,
            mul_params_hash_right
        );
        return mul_params;
    }

    transition process_private_mul(
        mul_params: MulParams,
        left_inter_sum: dcp_reconstruct_secret.aleo/ReconstructedSecret,
        right_inter_sum: dcp_reconstruct_secret.aleo/ReconstructedSecret
    ) -> ValidatorShare {

        let mul_params_data_left: MulParamsData = MulParamsData{
            index: mul_params.index,
            right_operand_share_val: mul_params.right_operand_share_val,
            left_beaver_share_val: mul_params.left_beaver_share_val,
            sum_beaver_share_val: mul_params.sum_beaver_share_val,
            custody: mul_params.custody,
            custody_trace: mul_params.custody_trace,
            left: true
        };
        let mul_params_hash_left: field = BHP256::hash_to_field(mul_params_data_left);

        let mul_params_data_right: MulParamsData = MulParamsData{
            index: mul_params.index,
            right_operand_share_val: mul_params.right_operand_share_val,
            left_beaver_share_val: mul_params.left_beaver_share_val,
            sum_beaver_share_val: mul_params.sum_beaver_share_val,
            custody: mul_params.custody,
            custody_trace: mul_params.custody_trace,
            left: false
        };
        let mul_params_hash_right: field = BHP256::hash_to_field(mul_params_data_right);

        assert_eq(mul_params_hash_left, left_inter_sum.custody_trace);
        assert_eq(mul_params_hash_right, right_inter_sum.custody_trace);
        assert_eq(mul_params.custody, left_inter_sum.custody);
        assert_eq(mul_params.custody, right_inter_sum.custody);

        dcp_reconstruct_secret.aleo/spend_reconstructed_secret(left_inter_sum);
        dcp_reconstruct_secret.aleo/spend_reconstructed_secret(right_inter_sum);
        
        // The beaver trick happens here 🦫
        let new_val: field = (
            left_inter_sum.secret * mul_params.right_operand_share_val
            - right_inter_sum.secret * mul_params.left_beaver_share_val
            + mul_params.sum_beaver_share_val
        ); // [z] = (x+a)[y] — (y+b)[a] + [c] = [x*y]

        let share: Share = Share {
            share_val: new_val,
            index: mul_params.index
        };
        return ValidatorShare {
            owner: self.signer,
            share: share,
            custody: mul_params.custody,
            custody_trace: mul_params.custody_trace,
            share_type: 3u8
        };
    }
}
