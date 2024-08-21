import data_custody_protocol.aleo;
import dcp_beaver_intermediaries.aleo;

program dcp_beaver_triples.aleo {
    const DCP_THRESHOLD: u8 = 16u8;
    const MAX_VALIDATORS: u8 = 16u8;
    const TWO_ADDRESS: address = aleo1qgqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqanmpl0;

    const MAX_BEAVER_PART: scalar = 2237scalar;
    const MIN_BEAVER_PART: scalar = 2111115437357092606062206234695386632838870926408408195193685246394721350383scalar;// -10_000scalar
    const MAX_RANDOMNESS: scalar = 2111115437357092606062206234695386632838870926408408195193685246394711360383scalar; // -10_000_000scalar
    const MIN_RANDOMNESS: scalar = 10_000_000scalar;

    // MAX_BEAVER_PART**2 + MAX_RANDOMNESS < MAX_REVERSABLE_SCALAR_VIEW_KEY
    // => MAX_REVERSABLE_SCALAR_VIEW_KEY = 10_000_000
    
    const ADDRESS_GEN: group = 
        522678458525321116977504528531602186870683848189190546523208313015552693483group;


    struct Beaver {
        triple_index: field,
        beaver_type: u8,
        validators: [address; 16]
    }

    struct Ciphertext {
        value_: group,
        nonce: group
    }

    record IntermediaryResult{
        owner: address,
        triple_index: field,
        ciphertexts: [Ciphertext; 16],
        step: bool
    }

    inline mul_scalar_ciphertext(
        operand: scalar, ciphertext: Ciphertext
    ) -> Ciphertext {
        return Ciphertext{
            value_: operand * ciphertext.value_,
            nonce: operand * ciphertext.nonce
        };
    }

    inline add_ciphertext(
        left: Ciphertext, right: Ciphertext
    ) -> Ciphertext {
        return Ciphertext{
            value_: left.value_ + right.value_,
            nonce: left.nonce + right.nonce
        };
    }

    inline additive_homomorphic_encrypt(
        public_key: address,
        plaintext: scalar,
        obfuscator: scalar
    ) -> Ciphertext {
        let cipher_nonce: group = obfuscator * ADDRESS_GEN;
        let cipher_view_key: group = obfuscator * (public_key as group);
        return Ciphertext {
            value_: plaintext * group::GEN + cipher_view_key,
            nonce: cipher_nonce
        };
    }

    inline additive_homomorphic_decrypt(
        view_key: scalar,
        ciphertext: Ciphertext,
        plaintext: scalar
    ){
        let cipher_view_key: group = view_key * ciphertext.nonce;
        let view_key_field: field = cipher_view_key as field;
        assert_eq(plaintext * group::GEN, ciphertext.value_ - cipher_view_key);
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

    async transition generate_left_beaver(
        public triple_index: field,
        private left_beaver_randomness: scalar,
        private ahe_obfuscator: scalar,
        public validators: [address; 16],
        public validator_index: u8,
        private dcp_coefficients: [field; 15],
        private dcp_obfuscator: scalar
    ) -> Future {
        assert_eq(
            get_address_in_array(validators, validator_index),
            self.signer
        );
        assert(ahe_obfuscator != 0scalar);
        assert(left_beaver_randomness <= MAX_BEAVER_PART || left_beaver_randomness >= MIN_BEAVER_PART);
        let ciphertext: Ciphertext = additive_homomorphic_encrypt(
            self.signer,
            left_beaver_randomness,
            ahe_obfuscator,
        );

        dcp_beaver_intermediaries.aleo/sumbit_left_ciphers(
            validators,
            triple_index,
            validator_index,
            ciphertext
        );

        let custody_key: field = BHP256::hash_to_field(
            Beaver {
                triple_index: triple_index,
                beaver_type: 0u8,
                validators: validators
            }
        );
        let dcp_future: Future = data_custody_protocol.aleo/add_or_mul_private(
            left_beaver_randomness as field,// private value_: field,
            true,// private is_addition: bool,
            custody_key,// private custody_key: field,
            dcp_coefficients,// private coefficients: [field; 15], // MAX_VALIDATORS_MINUS_1
            validators,// public validators: [address; 16], // MAX_VALIDATORS
            DCP_THRESHOLD,// private threshold: u8,  // <= MAX_VALIDATORS
            dcp_obfuscator// private obfuscator: scalar
        );

        return finalize_generate_left_beaver(dcp_future);
    }
    async function finalize_generate_left_beaver(dcp_future: Future){
        dcp_future.await();
    }
    
    transition reconstruct_inter_ciphers(
        inter_cipher_0: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext,
        inter_cipher_1: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext,
        inter_cipher_2: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext,
        inter_cipher_3: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext,
        inter_cipher_4: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext,
        inter_cipher_5: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext,
        inter_cipher_6: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext,
        inter_cipher_7: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext,
        inter_cipher_8: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext,
        inter_cipher_9: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext,
        inter_cipher_10: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext,
        inter_cipher_11: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext,
        inter_cipher_12: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext,
        inter_cipher_13: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext,
        inter_cipher_14: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext,
        inter_cipher_15: dcp_beaver_intermediaries.aleo/IntermediaryCiphertext
    ) -> IntermediaryResult {
        assert_eq(inter_cipher_0.step, inter_cipher_1.step);
        assert_eq(inter_cipher_0.step, inter_cipher_2.step);
        assert_eq(inter_cipher_0.step, inter_cipher_3.step);
        assert_eq(inter_cipher_0.step, inter_cipher_4.step);
        assert_eq(inter_cipher_0.step, inter_cipher_5.step);
        assert_eq(inter_cipher_0.step, inter_cipher_6.step);
        assert_eq(inter_cipher_0.step, inter_cipher_7.step);
        assert_eq(inter_cipher_0.step, inter_cipher_8.step);
        assert_eq(inter_cipher_0.step, inter_cipher_9.step);
        assert_eq(inter_cipher_0.step, inter_cipher_10.step);
        assert_eq(inter_cipher_0.step, inter_cipher_11.step);
        assert_eq(inter_cipher_0.step, inter_cipher_12.step);
        assert_eq(inter_cipher_0.step, inter_cipher_13.step);
        assert_eq(inter_cipher_0.step, inter_cipher_14.step);
        assert_eq(inter_cipher_0.step, inter_cipher_15.step);

        assert_eq(inter_cipher_0.triple_index, inter_cipher_1.triple_index);
        assert_eq(inter_cipher_0.triple_index, inter_cipher_2.triple_index);
        assert_eq(inter_cipher_0.triple_index, inter_cipher_3.triple_index);
        assert_eq(inter_cipher_0.triple_index, inter_cipher_4.triple_index);
        assert_eq(inter_cipher_0.triple_index, inter_cipher_5.triple_index);
        assert_eq(inter_cipher_0.triple_index, inter_cipher_6.triple_index);
        assert_eq(inter_cipher_0.triple_index, inter_cipher_7.triple_index);
        assert_eq(inter_cipher_0.triple_index, inter_cipher_8.triple_index);
        assert_eq(inter_cipher_0.triple_index, inter_cipher_9.triple_index);
        assert_eq(inter_cipher_0.triple_index, inter_cipher_10.triple_index);
        assert_eq(inter_cipher_0.triple_index, inter_cipher_11.triple_index);
        assert_eq(inter_cipher_0.triple_index, inter_cipher_12.triple_index);
        assert_eq(inter_cipher_0.triple_index, inter_cipher_13.triple_index);
        assert_eq(inter_cipher_0.triple_index, inter_cipher_14.triple_index);
        assert_eq(inter_cipher_0.triple_index, inter_cipher_15.triple_index);

        assert_eq(inter_cipher_0.validator_index, 0u8);
        assert_eq(inter_cipher_1.validator_index, 1u8);
        assert_eq(inter_cipher_2.validator_index, 2u8);
        assert_eq(inter_cipher_3.validator_index, 3u8);
        assert_eq(inter_cipher_4.validator_index, 4u8);
        assert_eq(inter_cipher_5.validator_index, 5u8);
        assert_eq(inter_cipher_6.validator_index, 6u8);
        assert_eq(inter_cipher_7.validator_index, 7u8);
        assert_eq(inter_cipher_8.validator_index, 8u8);
        assert_eq(inter_cipher_9.validator_index, 9u8);
        assert_eq(inter_cipher_10.validator_index, 10u8);
        assert_eq(inter_cipher_11.validator_index, 11u8);
        assert_eq(inter_cipher_12.validator_index, 12u8);
        assert_eq(inter_cipher_13.validator_index, 13u8);
        assert_eq(inter_cipher_14.validator_index, 14u8);
        assert_eq(inter_cipher_15.validator_index, 15u8);

        dcp_beaver_intermediaries.aleo/spend_intermediary_ciphers(
            inter_cipher_0,
            inter_cipher_1,
            inter_cipher_2,
            inter_cipher_3,
            inter_cipher_4,
            inter_cipher_5,
            inter_cipher_6,
            inter_cipher_7,
            inter_cipher_8,
            inter_cipher_9,
            inter_cipher_10,
            inter_cipher_11,
            inter_cipher_12,
            inter_cipher_13,
            inter_cipher_14,
            inter_cipher_15
        );
        return IntermediaryResult {
            owner: self.signer,
            triple_index: inter_cipher_0.triple_index,
            ciphertexts: [
                inter_cipher_0.ciphertext,
                inter_cipher_1.ciphertext,
                inter_cipher_2.ciphertext,
                inter_cipher_3.ciphertext,
                inter_cipher_4.ciphertext,
                inter_cipher_5.ciphertext,
                inter_cipher_6.ciphertext,
                inter_cipher_7.ciphertext,
                inter_cipher_8.ciphertext,
                inter_cipher_9.ciphertext,
                inter_cipher_10.ciphertext,
                inter_cipher_11.ciphertext,
                inter_cipher_12.ciphertext,
                inter_cipher_13.ciphertext,
                inter_cipher_14.ciphertext,
                inter_cipher_15.ciphertext,
            ],
            step: inter_cipher_0.step,
        };
    }
    
    async transition generate_right_beaver(
        private right_beaver_randomness: scalar,
        private randomnesses: [scalar; 16],
        private ahe_obfuscators: [scalar; 16],
        public validators: [address; 16],
        public validator_index: u8,
        private right_dcp_coefficients: [field; 15],
        private right_dcp_obfuscator: scalar,
        private sum_dcp_coefficients: [field; 15],
        private sum_dcp_obfuscator: scalar,
        private inter_result: IntermediaryResult
    ) -> Future {
        assert(!inter_result.step);
        assert_eq(
            get_address_in_array(validators, validator_index),
            self.signer
        );

        for i: u8 in 0u8..MAX_VALIDATORS {
            assert(ahe_obfuscators[i] != 0scalar);
            assert(right_beaver_randomness <= MAX_BEAVER_PART || right_beaver_randomness >= MIN_BEAVER_PART);
            assert(randomnesses[i] <= MAX_RANDOMNESS || randomnesses[i] >= MIN_RANDOMNESS);
        }

        let ciphertexts: [Ciphertext; 16] = [
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[0u16]
                ),
                additive_homomorphic_encrypt(
                    validators[0u16],
                    randomnesses[0u16],
                    ahe_obfuscators[0u16]
                )
            ),
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[1u16]
                ),
                additive_homomorphic_encrypt(
                    validators[1u16],
                    randomnesses[1u16],
                    ahe_obfuscators[1u16]
                )
            ),
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[2u16]
                ),
                additive_homomorphic_encrypt(
                    validators[2u16],
                    randomnesses[2u16],
                    ahe_obfuscators[2u16]
                )
            ),
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[3u16]
                ),
                additive_homomorphic_encrypt(
                    validators[3u16],
                    randomnesses[3u16],
                    ahe_obfuscators[3u16]
                )
            ),
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[4u16]
                ),
                additive_homomorphic_encrypt(
                    validators[4u16],
                    randomnesses[4u16],
                    ahe_obfuscators[4u16]
                )
            ),
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[5u16]
                ),
                additive_homomorphic_encrypt(
                    validators[5u16],
                    randomnesses[5u16],
                    ahe_obfuscators[5u16]
                )
            ),
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[6u16]
                ),
                additive_homomorphic_encrypt(
                    validators[6u16],
                    randomnesses[6u16],
                    ahe_obfuscators[6u16]
                )
            ),
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[7u16]
                ),
                additive_homomorphic_encrypt(
                    validators[7u16],
                    randomnesses[7u16],
                    ahe_obfuscators[7u16]
                )
            ),
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[8u16]
                ),
                additive_homomorphic_encrypt(
                    validators[8u16],
                    randomnesses[8u16],
                    ahe_obfuscators[8u16]
                )
            ),
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[9u16]
                ),
                additive_homomorphic_encrypt(
                    validators[9u16],
                    randomnesses[9u16],
                    ahe_obfuscators[9u16]
                )
            ),
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[10u16]
                ),
                additive_homomorphic_encrypt(
                    validators[10u16],
                    randomnesses[10u16],
                    ahe_obfuscators[10u16]
                )
            ),
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[11u16]
                ),
                additive_homomorphic_encrypt(
                    validators[11u16],
                    randomnesses[11u16],
                    ahe_obfuscators[11u16]
                )
            ),
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[12u16]
                ),
                additive_homomorphic_encrypt(
                    validators[12u16],
                    randomnesses[12u16],
                    ahe_obfuscators[12u16]
                )
            ),
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[13u16]
                ),
                additive_homomorphic_encrypt(
                    validators[13u16],
                    randomnesses[13u16],
                    ahe_obfuscators[13u16]
                )
            ),
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[14u16]
                ),
                additive_homomorphic_encrypt(
                    validators[14u16],
                    randomnesses[14u16],
                    ahe_obfuscators[14u16]
                )
            ),
            add_ciphertext(
                mul_scalar_ciphertext(
                    right_beaver_randomness, inter_result.ciphertexts[15u16]
                ),
                additive_homomorphic_encrypt(
                    validators[15u16],
                    randomnesses[15u16],
                    ahe_obfuscators[15u16]
                )
            )
        ];

        dcp_beaver_intermediaries.aleo/sumbit_right_ciphers(
            validators,
            inter_result.triple_index,
            validator_index,
            ciphertexts
        );

        let right_custody_key: field = BHP256::hash_to_field(
            Beaver {
                triple_index: inter_result.triple_index,
                beaver_type: 1u8,
                validators: validators
            }
        );
        let right_dcp_future: Future = data_custody_protocol.aleo/add_or_mul_private(
            right_beaver_randomness as field,// private value_: field,
            true,// private is_addition: bool,
            right_custody_key,// private custody_key: field,
            right_dcp_coefficients,// private coefficients: [field; 15], // MAX_VALIDATORS_MINUS_1
            validators,// public validators: [address; 16], // MAX_VALIDATORS
            DCP_THRESHOLD,// private threshold: u8,  // <= MAX_VALIDATORS
            right_dcp_obfuscator// private obfuscator: scalar
        );

        let sum_custody_key: field = BHP256::hash_to_field(
            Beaver {
                triple_index: inter_result.triple_index,
                beaver_type: 2u8,
                validators: validators
            }
        );

        let randomnesses_sum: scalar = 0scalar;
        for i: u8 in 0u8..MAX_VALIDATORS{
            randomnesses_sum += randomnesses[i];
        }

        let sum_dcp_future: Future = data_custody_protocol.aleo/add_or_mul_private(
            -(randomnesses_sum as field),// private value_: field,
            true,// private is_addition: bool,
            sum_custody_key,// private custody_key: field,
            sum_dcp_coefficients,// private coefficients: [field; 15], // MAX_VALIDATORS_MINUS_1
            validators,// public validators: [address; 16], // MAX_VALIDATORS
            DCP_THRESHOLD,// private threshold: u8,  // <= MAX_VALIDATORS
            sum_dcp_obfuscator// private obfuscator: scalar
        );
        return finalize_generate_right_beaver(right_dcp_future, sum_dcp_future);
    }
    async function finalize_generate_right_beaver(
        right_dcp_future: Future,
        sum_dcp_future: Future
    ){
        right_dcp_future.await();
        sum_dcp_future.await();
    }

    async transition generate_sum_beaver(
        public validators: [address; 16],
        public validator_index: u8,
        private dcp_coefficients: [field; 15],
        private dcp_obfuscator: scalar,
        private signer_view_key: scalar,
        private inter_result: IntermediaryResult,
        private decrypted_plaintexts: [scalar; 16]
    ) -> Future {
        assert_eq(
            get_address_in_array(validators, validator_index),
            self.signer
        );
        assert_eq(self.signer, (signer_view_key * ADDRESS_GEN) as address);
        assert(inter_result.step);

        let sum_decrypted: scalar = 0scalar;
        for i: u8 in 0u8..MAX_VALIDATORS{
            sum_decrypted += decrypted_plaintexts[i];
            additive_homomorphic_decrypt(
                signer_view_key,
                inter_result.ciphertexts[i],
                decrypted_plaintexts[i]
            );
        }

        let custody_key: field = BHP256::hash_to_field(
            Beaver {
                triple_index: inter_result.triple_index,
                beaver_type: 2u8,
                validators: validators
            }
        );
        let dcp_future: Future = data_custody_protocol.aleo/add_or_mul_private(
            sum_decrypted as field,// private value_: field,
            true,// private is_addition: bool,
            custody_key,// private custody_key: field,
            dcp_coefficients,// private coefficients: [field; 15], // MAX_VALIDATORS_MINUS_1
            validators,// public validators: [address; 16], // MAX_VALIDATORS
            DCP_THRESHOLD,// private threshold: u8,  // <= MAX_VALIDATORS
            dcp_obfuscator// private obfuscator: scalar
        );

        return finalize_generate_sum_beaver(dcp_future);
    }
    async function finalize_generate_sum_beaver(dcp_future: Future){
        dcp_future.await();
    }
}
