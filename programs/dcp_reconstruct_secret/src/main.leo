
/*
    Reconstruct a secret from shares on chain for using it.

    contact@aleo.store - Pierre-André LONG
*/

import dcp_destination_shares.aleo;


program dcp_reconstruct_secret.aleo {
    const MAX_ON_CHAIN_RECONSTRUCT_SHARES: u8 = 15u8;

    struct Share {
        share_val: field,
        index: field
    }

    record ReconstructedSecret{
        owner: address,
        secret: field,
        custody: Custody,
        custody_trace: field
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


    transition reconstruct_secret_private(
        destination_share_0: dcp_destination_shares.aleo/DestinationShare,
        destination_share_1: dcp_destination_shares.aleo/DestinationShare,
        destination_share_2: dcp_destination_shares.aleo/DestinationShare,
        destination_share_3: dcp_destination_shares.aleo/DestinationShare,
        destination_share_4: dcp_destination_shares.aleo/DestinationShare,
        destination_share_5: dcp_destination_shares.aleo/DestinationShare,
        destination_share_6: dcp_destination_shares.aleo/DestinationShare,
        destination_share_7: dcp_destination_shares.aleo/DestinationShare,
        destination_share_8: dcp_destination_shares.aleo/DestinationShare,
        destination_share_9: dcp_destination_shares.aleo/DestinationShare,
        destination_share_10: dcp_destination_shares.aleo/DestinationShare,
        destination_share_11: dcp_destination_shares.aleo/DestinationShare,
        destination_share_12: dcp_destination_shares.aleo/DestinationShare,
        destination_share_13: dcp_destination_shares.aleo/DestinationShare,
        destination_share_14: dcp_destination_shares.aleo/DestinationShare
    ) -> ReconstructedSecret {
        dcp_destination_shares.aleo/spend_destination_shares(
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
        assert_eq(destination_share_1.custody, destination_share_0.custody);
        assert_eq(destination_share_2.custody, destination_share_0.custody);
        assert_eq(destination_share_3.custody, destination_share_0.custody);
        assert_eq(destination_share_4.custody, destination_share_0.custody);
        assert_eq(destination_share_5.custody, destination_share_0.custody);
        assert_eq(destination_share_6.custody, destination_share_0.custody);
        assert_eq(destination_share_7.custody, destination_share_0.custody);
        assert_eq(destination_share_8.custody, destination_share_0.custody);
        assert_eq(destination_share_9.custody, destination_share_0.custody);
        assert_eq(destination_share_10.custody, destination_share_0.custody);
        assert_eq(destination_share_11.custody, destination_share_0.custody);
        assert_eq(destination_share_12.custody, destination_share_0.custody);
        assert_eq(destination_share_13.custody, destination_share_0.custody);
        assert_eq(destination_share_14.custody, destination_share_0.custody);

        assert_eq(destination_share_1.custody_trace, destination_share_0.custody_trace);
        assert_eq(destination_share_2.custody_trace, destination_share_0.custody_trace);
        assert_eq(destination_share_3.custody_trace, destination_share_0.custody_trace);
        assert_eq(destination_share_4.custody_trace, destination_share_0.custody_trace);
        assert_eq(destination_share_5.custody_trace, destination_share_0.custody_trace);
        assert_eq(destination_share_6.custody_trace, destination_share_0.custody_trace);
        assert_eq(destination_share_7.custody_trace, destination_share_0.custody_trace);
        assert_eq(destination_share_8.custody_trace, destination_share_0.custody_trace);
        assert_eq(destination_share_9.custody_trace, destination_share_0.custody_trace);
        assert_eq(destination_share_10.custody_trace, destination_share_0.custody_trace);
        assert_eq(destination_share_11.custody_trace, destination_share_0.custody_trace);
        assert_eq(destination_share_12.custody_trace, destination_share_0.custody_trace);
        assert_eq(destination_share_13.custody_trace, destination_share_0.custody_trace);
        assert_eq(destination_share_14.custody_trace, destination_share_0.custody_trace);

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
        assert(non_zero_shares >= destination_share_0.custody.threshold);
        let secret: field = reconstruct_onchain(shares);
        let reconstructed_secret: ReconstructedSecret = ReconstructedSecret {
            owner: self.caller,
            secret: secret,
            custody: destination_share_0.custody,
            custody_trace: destination_share_0.custody_trace
        };
        return reconstructed_secret;
    }

    transition spend_reconstructed_secret(
        reconstructed_secret: ReconstructedSecret
    ){}
}
