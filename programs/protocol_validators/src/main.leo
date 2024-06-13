
/*
    Validators management program.

    External usage example:
        async function needs_validators() {
            let validators: [address; 15] 
                = protocol_validators.aleo/validator_sets.get(
                    protocol_validators.aleo/validator_sets_length.get(true) - 1u64
                );
            ...
        }

    contact@aleo.store - Pierre-André LONG
*/

program protocol_validators.aleo {
    const default_authority: address = aleo1rupdxnwys2qktts6dqy7l4pjvng0ruapjxsht6ftsjlcmupl6c8sezw5n3; // APrivateKey1zkpGLq4y2tb8f54kkc1hKN3SWtcGDBikqWoHdx5xw2iLoLd

    mapping validator_sets: u64 => [address; 15]; // validator set index => validator addresses
    mapping validator_sets_length: bool => u64; // true => validator_sets length

    mapping vote_approval_threshold: bool => u8; // true => required votes for approval 

    mapping proposals: field => Proposal; // proposal hash => validator addresses
    mapping votes: field => [bool; 15]; // proposal hash => validator addresses


    struct Proposal {
        validators: [address; 15],
        threshold: u8,
        current_validator_set_index: u64
    }


    inline hash_proposal(proposal: Proposal) -> field {
        return BHP256::hash_to_field(proposal);
    }


    inline is_address_in_array(element: address, array: [address; 15]) -> bool{
        return (
            element == array[0u8]
            || element == array[1u8]
            || element == array[2u8]
            || element == array[3u8]
            || element == array[4u8]
            || element == array[5u8]
            || element == array[6u8]
            || element == array[7u8]
            || element == array[8u8]
            || element == array[9u8]
            || element == array[10u8]
            || element == array[11u8]
            || element == array[12u8]
            || element == array[13u8]
            || element == array[14u8]
        );
    }

    inline set_bool_in_array(
        array: [bool; 15], index: u8, value: bool
    ) -> [bool; 15] {
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
            (index == 14u8) ? value : array[14u8]
        ];
    }

    inline get_address_in_array(
        array: [address; 15], index: u8
    ) -> address {
        return (
            (index == 0u8) ? array[0u8]
            : (index == 1u8) ? array[1u8]
            : (index == 2u8) ? array[2u8]
            : (index == 3u8) ? array[3u8]
            : (index == 4u8) ? array[4u8]
            : (index == 5u8) ? array[5u8]
            : (index == 6u8) ? array[6u8]
            : (index == 7u8) ? array[7u8]
            : (index == 8u8) ? array[8u8]
            : (index == 9u8) ? array[9u8]
            : (index == 10u8) ? array[10u8]
            : (index == 11u8) ? array[11u8]
            : (index == 12u8) ? array[12u8]
            : (index == 13u8) ? array[13u8]
            : (index == 14u8) ? array[14u8]
            : (0group as address)
        );
    }

    inline new_bool_array() -> [bool; 15] {
        return [
            false, false, false, false, false,
            false, false, false, false, false,
            false, false, false, false, false
        ];
    }

    inline are_votes_approved(vote_values: [bool; 15], threshold: u8) -> bool {
        let approval_amounts: u8 = (
            (vote_values[0u8] as u8)
            + (vote_values[1u8] as u8)
            + (vote_values[2u8] as u8)
            + (vote_values[3u8] as u8)
            + (vote_values[4u8] as u8)
            + (vote_values[5u8] as u8)
            + (vote_values[6u8] as u8)
            + (vote_values[7u8] as u8)
            + (vote_values[8u8] as u8)
            + (vote_values[9u8] as u8)
            + (vote_values[10u8] as u8)
            + (vote_values[11u8] as u8)
            + (vote_values[12u8] as u8)
            + (vote_values[13u8] as u8)
            + (vote_values[14u8] as u8)
        );
        return (approval_amounts >= threshold);
    }


    async transition initiate_validators(
        public validators: [address; 15],
        public threshold: u8
    ) -> Future {
        assert_eq(self.caller, default_authority);
        return finalize_initiate_validators(
            validators,
            threshold
        );
    }
    async function finalize_initiate_validators(
        validators: [address; 15],
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
        validators: [address; 15],
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
        let current_validators: [address; 15] = validator_sets.get(
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
        validators: [address; 15],
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
        let current_validators: [address; 15] = validator_sets.get(
            proposal.current_validator_set_index
        );
        assert_eq(
            get_address_in_array(current_validators, caller_index),
            caller
        );

        let current_votes: [bool; 15] = votes.get_or_use(
            proposal_hash,
            new_bool_array()
        );
        let new_votes: [bool; 15] = set_bool_in_array(
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
        validators: [address; 15],
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
        let current_validators: [address; 15] = validator_sets.get(
            proposal.current_validator_set_index
        );
        is_address_in_array(caller, current_validators);
        
        let prev_threshold: u8 = vote_approval_threshold.get(true);

        let current_votes: [bool; 15] = votes.get(proposal_hash);
        assert(
            are_votes_approved(current_votes, prev_threshold)
        );

        validator_sets_length.set(true, length + 1u64);
        validator_sets.set(length, proposal.validators);

        vote_approval_threshold.set(true, proposal.threshold);
    }
}
