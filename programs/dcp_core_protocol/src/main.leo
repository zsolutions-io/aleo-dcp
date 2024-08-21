
/*
    Public state program:
    Mappings: custodies, requests, governance...

    External usage example:
        async function needs_validators() {
            let validators: [address; 16] 
                = dcp_core_protocol.aleo/validator_sets.get(
                    dcp_core_protocol.aleo/validator_sets_length.get(true) - 1u64
                );
            ...
        }

    contact@aleo.store - Pierre-André LONG
*/

import dcp_destination_shares.aleo;
import dcp_validator_shares.aleo;
import dcp_open_requests.aleo;
import dcp_validator_fee.aleo;

program dcp_core_protocol.aleo {
    const DEFAULT_AUTHORITY: address = aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t;
    const TWO_ADDRESS: address = aleo1qgqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqanmpl0;
    const MAX_VALIDATORS: u8 = 16u8;

    struct Proposal {
        validators: [address; 16], // MAX_VALIDATORS
        threshold: u8,
        current_validator_set_index: u64
    }

    struct CustodyState {
        validator_set_index: u64,
        custody_trace: field
    }

    struct Custody {
        origin: address,
        custody_key: field,
        threshold: u8
    }

    struct Share {
        share_val: field,
        index: field
    }

    struct ValidatorShareData {
        validator: address,
        share: Share
    }

    struct OpenRequestIdentifier {
        custody: Custody,
        custody_trace: field,
    }

    mapping validator_sets: u64 => [address; 16]; // MAX_VALIDATORS
    // validator set index => validator addresses

    mapping validator_sets_length: bool => u64;
    // true => validator_sets length

    mapping vote_approval_threshold: bool => u8;
    // true => required votes for approval 

    mapping proposals: field => Proposal;
    // proposal hash => validator addresses

    mapping votes: field => [bool; 16]; // MAX_VALIDATORS
    // proposal hash => validator addresses

    mapping custodies: field => CustodyState;
    // hash(Custody) => CustodyState

    mapping public_shares: field => field;
    // commit(hash(OpenRequestIdentifier), index) => share_val

    inline hash_proposal(proposal: Proposal) -> field {
        return BHP256::hash_to_field(proposal);
    }
    
    inline hash_tuple(traces: [field; 2]) -> field{
        return BHP256::hash_to_field(traces);
    }


    inline is_address_in_array(
        element: address, array: [address; 16] // MAX_VALIDATORS
    ) -> bool{
        let is_in_array: bool = false;
        for i: u8 in 0u8..MAX_VALIDATORS {
            is_in_array ||= (element == array[i]);
        }
        return is_in_array;
    }

    inline set_bool_in_array(
        array: [bool; 16], index: u8, share_val: bool // MAX_VALIDATORS
    ) -> [bool; 16] { // MAX_VALIDATORS
        return [
            (index == 0u8) ? share_val : array[0u8],
            (index == 1u8) ? share_val : array[1u8],
            (index == 2u8) ? share_val : array[2u8],
            (index == 3u8) ? share_val : array[3u8],
            (index == 4u8) ? share_val : array[4u8],
            (index == 5u8) ? share_val : array[5u8],
            (index == 6u8) ? share_val : array[6u8],
            (index == 7u8) ? share_val : array[7u8],
            (index == 8u8) ? share_val : array[8u8],
            (index == 9u8) ? share_val : array[9u8],
            (index == 10u8) ? share_val : array[10u8],
            (index == 11u8) ? share_val : array[11u8],
            (index == 12u8) ? share_val : array[12u8],
            (index == 13u8) ? share_val : array[13u8],
            (index == 14u8) ? share_val : array[14u8],
            (index == 15u8) ? share_val : array[15u8]
        ];
    }

    inline get_address_in_array(
        array: [address; 16], index: u8 // MAX_VALIDATORS
    ) -> address {
        let ret: address = TWO_ADDRESS;
        for i: u8 in 0u8..MAX_VALIDATORS {
            ret = (i == index) ? array[i] : ret;
        }
        return ret;
    }

    inline new_bool_array() -> [bool; 16] { // MAX_VALIDATORS
        return [
            false, false, false, false,
            false, false, false, false,
            false, false, false, false,
            false, false, false, false
        ];
    }

    inline are_votes_approved(
        vote_values: [bool; 16], threshold: u8 // MAX_VALIDATORS
    ) -> bool {
        let approval_amounts: u8 = 0u8;
        for i: u8 in 0u8..MAX_VALIDATORS {
            approval_amounts += (vote_values[i] as u8);
        }
        return (approval_amounts >= threshold);
    }


    inline hash_custody(custody: Custody) -> field {
        return BHP256::hash_to_field(custody);
    }

    inline min_u32(a: u32, b: u32) -> u32{
        return a<b ? a : b;
    }


    async transition initiate_validators(
        public validators: [address; 16], // MAX_VALIDATORS
        public threshold: u8
    ) -> Future {
        assert_eq(self.caller, DEFAULT_AUTHORITY);
        return finalize_initiate_validators(
            validators,
            threshold
        );
    }
    async function finalize_initiate_validators(
        validators: [address; 16], // MAX_VALIDATORS
        threshold: u8
    ) {
        assert(validator_sets_length.contains(true).not());
        validator_sets_length.set(true, 1u64);
        validator_sets.set(0u64, validators);
        vote_approval_threshold.set(true, threshold);
    }


    async transition initiate_proposal(
        public proposal: Proposal
    ) -> Future {
        return finalize_initiate_proposal(
            self.caller,
            proposal.validators,
            proposal.threshold,
            proposal.current_validator_set_index
        );
    }
    async function finalize_initiate_proposal(
        caller: address,
        validators: [address; 16], // MAX_VALIDATORS
        threshold: u8,
        current_validator_set_index: u64
    ) {
        let proposal: Proposal = Proposal {
            validators: validators,
            threshold: threshold,
            current_validator_set_index: current_validator_set_index
        };
        let proposal_hash: field = hash_proposal(proposal);
        let length: u64 = validator_sets_length.get(true);
        assert_eq(
            proposal.current_validator_set_index, length - 1u64
        );
        let current_validators: [address; 16] = validator_sets.get( // MAX_VALIDATORS
            proposal.current_validator_set_index
        );

        is_address_in_array(caller, current_validators);
        proposals.set(proposal_hash, proposal);
    }


    async transition vote(
        public proposal: Proposal,
        public caller_index: u8,
        public vote_value: bool
    ) -> Future {
        return finalize_vote(
            self.caller,
            proposal.validators,
            proposal.threshold,
            proposal.current_validator_set_index,
            caller_index,
            vote_value,
        );
    }
    async function finalize_vote(
        caller: address,
        validators: [address; 16], // MAX_VALIDATORS
        threshold: u8,
        current_validator_set_index: u64,
        caller_index: u8,
        vote_value: bool
    ) {
        let proposal: Proposal = Proposal {
            validators: validators,
            threshold: threshold,
            current_validator_set_index: current_validator_set_index
        };
        let proposal_hash: field = hash_proposal(proposal);
        let length: u64 = validator_sets_length.get(true);
        assert_eq(
            proposal.current_validator_set_index, length - 1u64
        );
        let current_validators: [address; 16] = validator_sets.get( // MAX_VALIDATORS
            proposal.current_validator_set_index
        );
        assert_eq(
            get_address_in_array(current_validators, caller_index),
            caller
        );

        let current_votes: [bool; 16] = votes.get_or_use( // MAX_VALIDATORS
            proposal_hash,
            new_bool_array()
        );
        let new_votes: [bool; 16] = set_bool_in_array( // MAX_VALIDATORS
            current_votes,
            caller_index,
            vote_value
        );
        votes.set(proposal_hash, new_votes);
    }


    async transition accept_proposal(
        public proposal: Proposal,
        public vote_value: bool,
    ) -> Future {
        return finalize_accept_proposal(
            self.caller,
            proposal.validators,
            proposal.threshold,
            proposal.current_validator_set_index,
            vote_value
        );
    }
    async function finalize_accept_proposal(
        caller: address,
        validators: [address; 16], // MAX_VALIDATORS
        threshold: u8,
        current_validator_set_index: u64,
        vote_value: bool
    ) {
        let proposal: Proposal = Proposal {
            validators: validators,
            threshold: threshold,
            current_validator_set_index: current_validator_set_index
        };
        let proposal_hash: field = hash_proposal(proposal);
        let length: u64 = validator_sets_length.get(true);
        assert_eq(
            proposal.current_validator_set_index, length - 1u64
        );
        let current_validators: [address; 16] = validator_sets.get( // MAX_VALIDATORS
            proposal.current_validator_set_index
        );
        is_address_in_array(caller, current_validators);
        
        let prev_threshold: u8 = vote_approval_threshold.get(true);

        let current_votes: [bool; 16] = votes.get(proposal_hash); // MAX_VALIDATORS
        assert(
            are_votes_approved(current_votes, prev_threshold)
        );

        validator_sets_length.set(true, length + 1u64);
        validator_sets.set(length, proposal.validators);

        vote_approval_threshold.set(true, proposal.threshold);
    }


    async transition custody_data_as_program(
        public custody_hash: field,
        public validators: [address; 16], // MAX_VALIDATORS
        public operation_trace: field
    ) -> Future {
        assert_eq(self.caller, data_custody_protocol.aleo);
        return finalize_custody_data_as_program(
            custody_hash,
            validators,
            operation_trace
        );
    }
    async function finalize_custody_data_as_program(
        custody_hash: field,
        validators: [address; 16], // MAX_VALIDATORS
        operation_trace: field
    ){
        let default_custody_state: CustodyState = CustodyState {
            validator_set_index: 0u64,
            custody_trace: operation_trace
        };
        let custody_state: CustodyState = custodies.get_or_use(
            custody_hash, default_custody_state
        );

        let validator_sets_len: u64 = validator_sets_length.get(true);
        let first_custody: bool = (
            custody_state.custody_trace == operation_trace
        );
        let validator_set_index: u64 = first_custody ?
            (validator_sets_len - 1u64) :
            custody_state.validator_set_index;
        let validator_set: [address; 16] = validator_sets.get(
            validator_set_index
        ); // MAX_VALIDATORS
        assert_eq(validators, validator_set);

        let new_custody_trace: field = first_custody ?
            operation_trace :
            hash_tuple([
                custody_state.custody_trace,
                operation_trace
            ]);

        let new_custody_state: CustodyState = CustodyState {
            validator_set_index: validator_set_index,
            custody_trace: new_custody_trace
        };
        custodies.set(custody_hash, new_custody_state);
    }


    async transition request_open(
        public custody_hash: field,
        public validators: [address; 16], // MAX_VALIDATORS
        public custody_trace: field
    ) -> Future {
        assert_eq(self.caller, data_custody_protocol.aleo);
        return finalize_request_open(
            custody_hash,
            validators,
            custody_trace
        );
    }
    async function finalize_request_open(
        custody_hash: field,
        validators: [address; 16], // MAX_VALIDATORS
        custody_trace: field
    ){
        let custody_state: CustodyState = custodies.get(custody_hash);
        assert_eq(custody_trace, custody_state.custody_trace);

        let validator_set: [address; 16] = validator_sets.get(
            custody_state.validator_set_index
        ); // MAX_VALIDATORS
        assert_eq(validators, validator_set);
    }


    transition process_private_request(
        validator_share: dcp_validator_shares.aleo/ValidatorShare,
        open_request: dcp_open_requests.aleo/OpenRequest,
        previous_fee: dcp_validator_fee.aleo/Fee,
    ) -> dcp_validator_fee.aleo/Fee {
        let custody_hash: field = hash_custody(validator_share.custody);
        assert_eq(open_request.custody_hash, custody_hash);
        assert_neq(open_request.to, TWO_ADDRESS);

        assert(
            validator_share.share_type == 0u8
            || validator_share.share_type == 1u8
            || validator_share.share_type == 3u8
        );

        dcp_destination_shares.aleo/submit_request_shares(
            open_request.to,
            validator_share.share,
            validator_share.custody,
            open_request.custody_trace
        );
        dcp_open_requests.aleo/spend_open_request(open_request);
        
        let next_fee: dcp_validator_fee.aleo/Fee
            = dcp_validator_fee.aleo/update_fee(
                previous_fee,
                self.signer,
                open_request.fee_amount + previous_fee.microcredits,
                min_u32(open_request.expire, previous_fee.expire)
            );
        assert_eq(open_request.custody_trace, validator_share.custody_trace);

        return next_fee;
    }

    async transition process_public_request(
        validator_share: dcp_validator_shares.aleo/ValidatorShare,
        open_request: dcp_open_requests.aleo/OpenRequest,
        previous_fee: dcp_validator_fee.aleo/Fee,
    ) -> (dcp_validator_fee.aleo/Fee, Future) {
        let custody_hash: field = hash_custody(validator_share.custody);

        assert_eq(open_request.custody_hash, custody_hash);
        assert_eq(open_request.to, TWO_ADDRESS);
        assert_eq(open_request.custody_trace, validator_share.custody_trace);

        assert(
            validator_share.share_type == 0u8
            || validator_share.share_type == 1u8
            || validator_share.share_type == 3u8
        );

        dcp_open_requests.aleo/spend_open_request(open_request);
        
        let next_fee: dcp_validator_fee.aleo/Fee
            = dcp_validator_fee.aleo/update_fee(
                previous_fee,
                self.signer,
                open_request.fee_amount + previous_fee.microcredits,
                min_u32(open_request.expire, previous_fee.expire)
            );

        let open_identifier: OpenRequestIdentifier = OpenRequestIdentifier {
            custody: validator_share.custody,
            custody_trace: open_request.custody_trace,
        };
        let open_identifier_hash: field = BHP256::hash_to_field(open_identifier);
        let share_identifier_commit: field = BHP256::commit_to_field(
            open_identifier_hash,
            validator_share.share.index as scalar
        );

        let process_public_request_future: Future =
            finalize_process_public_request(
                share_identifier_commit,
                validator_share.share.share_val
            );

        return (next_fee, process_public_request_future);
    }
    async function finalize_process_public_request(
        share_identifier_commit: field,
        share_value: field
    ) {
        public_shares.set(share_identifier_commit, share_value);
    }


    transition process_list_request(
        validator_share: dcp_validator_shares.aleo/ValidatorShare,
        open_request: dcp_open_requests.aleo/OpenListRequest,
        previous_fee: dcp_validator_fee.aleo/Fee,
    ) -> dcp_validator_fee.aleo/Fee {
        let custody_hash: field = hash_custody(validator_share.custody);
        assert_eq(open_request.custody_hash, custody_hash);
        assert_eq(open_request.custody_trace, validator_share.custody_trace);

        assert(
            validator_share.share_type == 0u8
            || validator_share.share_type == 1u8
            || validator_share.share_type == 3u8
        );

        dcp_destination_shares.aleo/submit_list_request_shares(
            open_request.to,
            validator_share.share,
            validator_share.custody,
            open_request.custody_trace
        ); // Submit first batch
        dcp_open_requests.aleo/spend_open_l_request(open_request);
        
        let next_fee: dcp_validator_fee.aleo/Fee
            = dcp_validator_fee.aleo/update_fee(
                previous_fee,
                self.signer,
                open_request.fee_amount + previous_fee.microcredits,
                min_u32(open_request.expire, previous_fee.expire)
            );

        return next_fee;
    }
}
