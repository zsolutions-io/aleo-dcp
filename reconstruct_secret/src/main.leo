
/*
    Reconstruct a secret from shares.
*/

program reconstruct_secret.aleo {
    struct Share {
        share_val: field,
        index: field,
    }

    // Inverse field but will invert 0field to 1field to avoid constraint error when building
    inline safe_inv(f: field) -> field { 
        return ((f == 0field) ? 1field : f).inv();
    }

    function reconstruct3(shares: [Share; 3]) -> field {
        let secret: field = 0field;
        for i: u8 in 0u8..3u8{
            let lagrange_coeff: field = 1field;
            let x_i: field = shares[i].index;
            for j: u8 in 0u8..3u8 {
                let x_j: field = shares[j].index;
                let to_mul: field = 
                    (i != j) ? 
                        (x_j * safe_inv(x_j - x_i)) :
                        1field;
                lagrange_coeff *= to_mul;
            }
            secret += ((shares[i].share_val) * lagrange_coeff);
        }
        return secret;
    }

    transition call_reconstruct3(shares: [Share; 3]) -> field {
        let reconstructed_secret: field = reconstruct3(shares);
        return reconstructed_secret;
    }
}
