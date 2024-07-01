
/*
    Public state program:
    Mappings: custodies, requests, governance...

    External usage example:
        async function needs_validators() {
            let validators: [address; 16] 
                = dcp_public_states.aleo/validator_sets.get(
                    dcp_public_states.aleo/validator_sets_length.get(true) - 1u64
                );
            ...
        }

    contact@aleo.store - Pierre-André LONG
*/

program dcp_public_states.aleo {
    const DEFAULT_AUTHORITY: address = aleo1wamjqlka7d0gazlxdys6n8e8zeee3ymedwvw8elvh7529kwd45rq0plgax;
    const ZERO_ADDRESS: address = aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc;
    const MAX_VALIDATORS: u8 = 16u8;

    struct Proposal {
        validators: [address; 16], // MAX_VALIDATORS
        threshold: u8,
        current_validator_set_index: u64
    }

    struct CustodyState {
        validator_set_index: u64,
        expected_weight: u64,
        requested: bool,
    }

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
        share: Share,
        weight: u64
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

    mapping requests: field => u8;
    // request_id => submitted_shares


    inline hash_proposal(proposal: Proposal) -> field {
        return BHP256::hash_to_field(proposal);
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
        array: [bool; 16], index: u8, value: bool // MAX_VALIDATORS
    ) -> [bool; 16] { // MAX_VALIDATORS
        return [
            (index == 0u8) ? value : array[0u8],
            (index == 1u8) ? value : array[1u8],
            (index == 2u8) ? value : array[2u8],
            (index == 3u8) ? value : array[3u8],
            (index == 4u8) ? value : array[4u8],
            (index == 5u8) ? value : array[5u8],
            (index == 6u8) ? value : array[6u8],
            (index == 7u8) ? value : array[7u8],
            (index == 8u8) ? value : array[8u8],
            (index == 9u8) ? value : array[9u8],
            (index == 10u8) ? value : array[10u8],
            (index == 11u8) ? value : array[11u8],
            (index == 12u8) ? value : array[12u8],
            (index == 13u8) ? value : array[13u8],
            (index == 14u8) ? value : array[14u8],
            (index == 15u8) ? value : array[15u8]
        ];
    }

    inline get_address_in_array(
        array: [address; 16], index: u8 // MAX_VALIDATORS
    ) -> address {
        let ret: address = ZERO_ADDRESS;
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
        public value: bool
    ) -> Future {
        return finalize_vote(
            self.caller,
            proposal.validators,
            proposal.threshold,
            proposal.current_validator_set_index,
            caller_index,
            value,
        );
    }
    async function finalize_vote(
        caller: address,
        validators: [address; 16], // MAX_VALIDATORS
        threshold: u8,
        current_validator_set_index: u64,
        caller_index: u8,
        value: bool
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
            value
        );
        votes.set(proposal_hash, new_votes);
    }


    async transition accept_proposal(
        public proposal: Proposal,
        public value: bool,
    ) -> Future {
        return finalize_accept_proposal(
            self.caller,
            proposal.validators,
            proposal.threshold,
            proposal.current_validator_set_index,
            value
        );
    }
    async function finalize_accept_proposal(
        caller: address,
        validators: [address; 16], // MAX_VALIDATORS
        threshold: u8,
        current_validator_set_index: u64,
        value: bool
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
    ) -> Future {
        assert_eq(self.caller, data_custody_protocol.aleo);
        return finalize_custody_data_as_program(
            custody_hash,
            validators,
        );
    }
    async function finalize_custody_data_as_program(
        custody_hash: field,
        validators: [address; 16], // MAX_VALIDATORS
    ){
        let default_custody_state: CustodyState = CustodyState {
            validator_set_index: 0u64,
            expected_weight: 0u64,
            requested: false
        };
        let custody_state: CustodyState = custodies.get_or_use(
            custody_hash, default_custody_state
        );

        let validator_sets_len: u64 = validator_sets_length.get(true);
        let validator_set_index: u64 = (custody_state.expected_weight == 0u64) ?
            (validator_sets_len - 1u64) :
            custody_state.validator_set_index;
        let validator_set: [address; 16] = validator_sets.get(validator_set_index); // MAX_VALIDATORS
        assert_eq(validators, validator_set);

        assert(custody_state.requested.not());

        let new_custody_state: CustodyState = CustodyState {
            validator_set_index: validator_set_index,
            expected_weight: custody_state.expected_weight + 1u64,
            requested: false
        };
        custodies.set(custody_hash, new_custody_state);
    }


    async transition request_data_as_program(
        public custody_hash: field,
        public request_id: field,
        public validators: [address; 16] // MAX_VALIDATORS
    ) -> Future {
        assert_eq(self.caller, data_custody_protocol.aleo);
        return finalize_request_data_as_program(
            custody_hash,
            request_id,
            validators
        );
    }
    async function finalize_request_data_as_program(
        custody_hash: field,
        request_id: field,
        validators: [address; 16] // MAX_VALIDATORS
    ){
        let custody_state: CustodyState = custodies.get(custody_hash);
        let new_custody_state: CustodyState = CustodyState {
            validator_set_index: custody_state.validator_set_index,
            expected_weight: custody_state.expected_weight,
            requested: true,
        };
        custodies.set(custody_hash, new_custody_state);

        let validator_set: [address; 16] = validator_sets.get(custody_state.validator_set_index); // MAX_VALIDATORS

        assert_eq(validators, validator_set);

        assert(requests.contains(request_id).not());
        requests.set(request_id, 0u8);
    }


    async transition process_request_as_validator(
        public custody_hash: field,
        public request_id: field,
        public threshold: u8,
        public weight: u64
    ) -> Future {
        assert_eq(self.caller, dcp_private_states.aleo);
        return finalize_process_request_as_validator(
            custody_hash,
            request_id,
            threshold,
            weight
        );
    }
    async function finalize_process_request_as_validator(
        custody_hash: field,
        request_id: field,
        threshold: u8,
        weight: u64
    ) {
        let custody_state: CustodyState = custodies.get(custody_hash);
        assert_eq(weight, custody_state.expected_weight);

        let submitted_shares: u8 = requests.get(request_id);
        assert(submitted_shares < threshold);
        requests.set(request_id, submitted_shares + 1u8);
    }
}
