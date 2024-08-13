
/*
    Reconstruct a secret from shares on chain for using it.

    contact@aleo.store - Pierre-André LONG
*/

import dcp_core_protocol.aleo;


program dcp_reconstruct_secret_public.aleo {
    const MAX_ON_CHAIN_RECONSTRUCT_SHARES: u8 = 15u8;

    mapping reconstructed_secrets: field => field;
    // hash(OpenRequestIdentifier) => secret

    struct Share {
        share_val: field,
        index: field
    }

    inline hash_custody(custody: Custody) -> field {
        return BHP256::hash_to_field(custody);
    }

    inline count_relevant_shares(
        shares: [Share; 15] // MAX_ON_CHAIN_RECONSTRUCT_SHARES
    ) -> u8{
        let non_zero_shares: u8 = 0u8;
        for i: u8 in 0u8..MAX_ON_CHAIN_RECONSTRUCT_SHARES{
            non_zero_shares += (shares[i].index != 0field) as u8;
        }
        return non_zero_shares;
    }

    // Inverse field but will invert 0field to 1field to avoid constraint error
    inline safe_inv(f: field) -> field { 
        return ((f == 0field) ? 1field : f).inv();
    }

    inline reconstruct_onchain(
        shares: [Share; 15] // MAX_ON_CHAIN_RECONSTRUCT_SHARES
    ) -> field {
        let secret: field = 0field;
        for i: u8 in 0u8..MAX_ON_CHAIN_RECONSTRUCT_SHARES{
            let lagrange_coeff: field = 1field;
            let x_i: field = shares[i].index;
            for j: u8 in 0u8..MAX_ON_CHAIN_RECONSTRUCT_SHARES {
                let x_j: field = shares[j].index;
                let to_mul: field = 
                    (i != j && x_j != 0field) ? 
                        (x_j * safe_inv(x_j - x_i)) :
                        1field;
                lagrange_coeff *= to_mul;
            }
            secret += (x_i != 0field) ?
                    ((shares[i].share_val) * lagrange_coeff) :
                    0field;
        }
        return secret;
    }

    async transition reconstruct_secret_public(
        private custody: Custody,
        private custody_trace: field,
    ) -> Future{
        let open_identifier: OpenRequestIdentifier = OpenRequestIdentifier {
            custody: custody,
            custody_trace: custody_trace,
        };
        let open_identifier_hash: field = BHP256::hash_to_field(open_identifier);

        return finalize_reconstruct_secret_public(
            open_identifier_hash,
            custody.threshold
        );
    }
    async function finalize_reconstruct_secret_public(
        open_identifier_hash: field,
        threshold: u8
    ){
        let share_val_0: field = dcp_core_protocol.aleo/public_shares.get_or_use(
            BHP256::commit_to_field(
                open_identifier_hash,
                1scalar
            ),
            0field
        );
        let share_0: Share = share_val_0 == 0field ?
            Share{
                share_val: 0field,
                index: 0field
            } : 
            Share{
                share_val: share_val_0,
                index: 1field
            };

        let share_val_1: field = dcp_core_protocol.aleo/public_shares.get_or_use(
            BHP256::commit_to_field(
                open_identifier_hash,
                2scalar
            ),
            0field
        );
        let share_1: Share = share_val_1 == 0field ?
            Share{
                share_val: 0field,
                index: 0field
            } : 
            Share{
                share_val: share_val_1,
                index: 2field
            };

        let share_val_2: field = dcp_core_protocol.aleo/public_shares.get_or_use(
            BHP256::commit_to_field(
                open_identifier_hash,
                2scalar
            ),
            0field
        );
        let share_2: Share = share_val_2 == 0field ?
            Share{
                share_val: 0field,
                index: 0field
            } : 
            Share{
                share_val: share_val_2,
                index: 3field
            };
        
        let share_val_3: field = dcp_core_protocol.aleo/public_shares.get_or_use(
            BHP256::commit_to_field(
                open_identifier_hash,
                4scalar
            ),
            0field
        );
        let share_3: Share = share_val_3 == 0field ?
            Share{
                share_val: 0field,
                index: 0field
            } : 
            Share{
                share_val: share_val_3,
                index: 4field
            };

        let share_val_4: field = dcp_core_protocol.aleo/public_shares.get_or_use(
            BHP256::commit_to_field(
                open_identifier_hash,
                5scalar
            ),
            0field
        );
        let share_4: Share = share_val_4 == 0field ?
            Share{
                share_val: 0field,
                index: 0field
            } : 
            Share{
                share_val: share_val_4,
                index: 5field
            };

        let share_val_5: field = dcp_core_protocol.aleo/public_shares.get_or_use(
            BHP256::commit_to_field(
                open_identifier_hash,
                6scalar
            ),
            0field
        );
        let share_5: Share = share_val_5 == 0field ?
            Share{
                share_val: 0field,
                index: 0field
            } : 
            Share{
                share_val: share_val_5,
                index: 6field
            };

        let share_val_6: field = dcp_core_protocol.aleo/public_shares.get_or_use(
            BHP256::commit_to_field(
                open_identifier_hash,
                7scalar
            ),
            0field
        );
        let share_6: Share = share_val_6 == 0field ?
            Share{
                share_val: 0field,
                index: 0field
            } : 
            Share{
                share_val: share_val_6,
                index: 7field
            };

        let share_val_7: field = dcp_core_protocol.aleo/public_shares.get_or_use(
            BHP256::commit_to_field(
                open_identifier_hash,
                8scalar
            ),
            0field
        );
        let share_7: Share = share_val_7 == 0field ?
            Share{
                share_val: 0field,
                index: 0field
            } : 
            Share{
                share_val: share_val_7,
                index: 8field
            };

        let share_val_8: field = dcp_core_protocol.aleo/public_shares.get_or_use(
            BHP256::commit_to_field(
                open_identifier_hash,
                9scalar
            ),
            0field
        );
        let share_8: Share = share_val_8 == 0field ?
            Share{
                share_val: 0field,
                index: 0field
            } : 
            Share{
                share_val: share_val_8,
                index: 9field
            };

        let share_val_9: field = dcp_core_protocol.aleo/public_shares.get_or_use(
            BHP256::commit_to_field(
                open_identifier_hash,
                10scalar
            ),
            0field
        );
        let share_9: Share = share_val_9 == 0field ?
            Share{
                share_val: 0field,
                index: 0field
            } : 
            Share{
                share_val: share_val_9,
                index: 10field
            };

        let share_val_10: field = dcp_core_protocol.aleo/public_shares.get_or_use(
            BHP256::commit_to_field(
                open_identifier_hash,
                11scalar
            ),
            0field
        );
        let share_10: Share = share_val_10 == 0field ?
            Share{
                share_val: 0field,
                index: 0field
            } : 
            Share{
                share_val: share_val_10,
                index: 11field
            };

        let share_val_11: field = dcp_core_protocol.aleo/public_shares.get_or_use(
            BHP256::commit_to_field(
                open_identifier_hash,
                12scalar
            ),
            0field
        );
        let share_11: Share = share_val_11 == 0field ?
            Share{
                share_val: 0field,
                index: 0field
            } : 
            Share{
                share_val: share_val_11,
                index: 12field
            };

        let share_val_12: field = dcp_core_protocol.aleo/public_shares.get_or_use(
            BHP256::commit_to_field(
                open_identifier_hash,
                13scalar
            ),
            0field
        );
        let share_12: Share = share_val_12 == 0field ?
            Share{
                share_val: 0field,
                index: 0field
            } : 
            Share{
                share_val: share_val_12,
                index: 13field
            };

        let share_val_13: field = dcp_core_protocol.aleo/public_shares.get_or_use(
            BHP256::commit_to_field(
                open_identifier_hash,
                14scalar
            ),
            0field
        );
        let share_13: Share = share_val_13 == 0field ?
            Share{
                share_val: 0field,
                index: 0field
            } : 
            Share{
                share_val: share_val_13,
                index: 14field
            };

        let share_val_14: field = dcp_core_protocol.aleo/public_shares.get_or_use(
            BHP256::commit_to_field(
                open_identifier_hash,
                15scalar
            ),
            0field
        );
        let share_14: Share = share_val_14 == 0field ?
            Share{
                share_val: 0field,
                index: 0field
            } : 
            Share{
                share_val: share_val_14,
                index: 15field
            };

        let shares: [Share; 15] = [ // MAX_ON_CHAIN_RECONSTRUCT_SHARES
            share_0,
            share_1,
            share_2,
            share_3,
            share_4,
            share_5,
            share_6,
            share_7,
            share_8,
            share_9,
            share_10,
            share_11,
            share_12,
            share_13,
            share_14
        ];
        let non_zero_shares: u8 = count_relevant_shares(shares);
        assert(non_zero_shares >= threshold);
        let secret: field = reconstruct_onchain(shares);

        reconstructed_secrets.set(open_identifier_hash, secret);
    }
}
