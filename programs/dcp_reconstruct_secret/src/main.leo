
/*
    Reconstruct a secret from shares on chain for using it.

    contact@aleo.store - Pierre-André LONG
*/

import dcp_core_protocol.aleo;


program dcp_reconstruct_secret.aleo {
    const MAX_ON_CHAIN_RECONSTRUCT_SHARES: u8 = 15u8;


    struct Share {
        share_val: field,
        index: field
    }

    record ReconstructedSecret{
        owner: address,
        secret: field,
        custody_hash: field
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

    function reconstruct_onchain(
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


    transition reconstruct_secret_onchain(
        destination_share_0: dcp_core_protocol.aleo/DestinationShare,
        destination_share_1: dcp_core_protocol.aleo/DestinationShare,
        destination_share_2: dcp_core_protocol.aleo/DestinationShare,
        destination_share_3: dcp_core_protocol.aleo/DestinationShare,
        destination_share_4: dcp_core_protocol.aleo/DestinationShare,
        destination_share_5: dcp_core_protocol.aleo/DestinationShare,
        destination_share_6: dcp_core_protocol.aleo/DestinationShare,
        destination_share_7: dcp_core_protocol.aleo/DestinationShare,
        destination_share_8: dcp_core_protocol.aleo/DestinationShare,
        destination_share_9: dcp_core_protocol.aleo/DestinationShare,
        destination_share_10: dcp_core_protocol.aleo/DestinationShare,
        destination_share_11: dcp_core_protocol.aleo/DestinationShare,
        destination_share_12: dcp_core_protocol.aleo/DestinationShare,
        destination_share_13: dcp_core_protocol.aleo/DestinationShare,
        destination_share_14: dcp_core_protocol.aleo/DestinationShare
    ) -> ReconstructedSecret {
        dcp_core_protocol.aleo/spend_destination_shares(
            destination_share_0,
            destination_share_1,
            destination_share_2,
            destination_share_3,
            destination_share_4,
            destination_share_5,
            destination_share_6,
            destination_share_7,
            destination_share_8,
            destination_share_9,
            destination_share_10,
            destination_share_11,
            destination_share_12,
            destination_share_13,
            destination_share_14
        );
        // TODO DETERMINE IF WE SHOULD: only allow origin custodier program to reconstruct the share
        assert_eq(self.caller, destination_share_0.custody.origin);
        let shares: [Share; 15] = [ // MAX_ON_CHAIN_RECONSTRUCT_SHARES
            destination_share_0.share,
            destination_share_1.share,
            destination_share_2.share,
            destination_share_3.share,
            destination_share_4.share,
            destination_share_5.share,
            destination_share_6.share,
            destination_share_7.share,
            destination_share_8.share,
            destination_share_9.share,
            destination_share_10.share,
            destination_share_11.share,
            destination_share_12.share,
            destination_share_13.share,
            destination_share_14.share
        ];
        let non_zero_shares: u8 = count_relevant_shares(shares);
        assert(non_zero_shares == destination_share_0.custody.threshold);
        let secret: field = reconstruct_onchain(shares);
        let reconstructed_secret: ReconstructedSecret = ReconstructedSecret {
            owner: self.caller,
            secret: secret,
            custody_hash: hash_custody(destination_share_0.custody)
        };
        return reconstructed_secret;
    }
}
