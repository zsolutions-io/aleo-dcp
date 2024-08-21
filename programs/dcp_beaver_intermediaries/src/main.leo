program dcp_beaver_intermediaries.aleo {
    struct Ciphertext {
        value_: group,
        nonce: group
    }

    record IntermediaryCiphertext {
        owner: address,
        triple_index: field,
        validator_index: u8,
        ciphertext: Ciphertext,
        step: bool
    }

    transition sumbit_left_ciphers(
        validators: [address; 16],
        triple_index: field,
        validator_index: u8,
        ciphertext: Ciphertext
    ) -> (
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext
    ) {
        assert_eq(self.caller, dcp_beaver_triples.aleo);
        let inter_cipher_0: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[0u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };
        let inter_cipher_1: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[1u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };
        let inter_cipher_2: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[2u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };
        let inter_cipher_3: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[3u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };
        let inter_cipher_4: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[4u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };
        let inter_cipher_5: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[5u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };
        let inter_cipher_6: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[6u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };
        let inter_cipher_7: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[7u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };
        let inter_cipher_8: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[8u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };
        let inter_cipher_9: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[9u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };
        let inter_cipher_10: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[10u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };
        let inter_cipher_11: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[11u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };
        let inter_cipher_12: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[12u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };
        let inter_cipher_13: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[13u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };
        let inter_cipher_14: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[14u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };
        let inter_cipher_15: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[15u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertext,
            step: false
        };

        return (
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
    }


    transition sumbit_right_ciphers(
        validators: [address; 16],
        triple_index: field,
        validator_index: u8,
        ciphertexts: [Ciphertext; 16]
    ) -> (
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext,
        IntermediaryCiphertext
    ) {
        assert_eq(self.caller, dcp_beaver_triples.aleo);
        let inter_cipher_0: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[0u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[0u8],
            step: true
        };
        let inter_cipher_1: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[1u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[1u8],
            step: true
        };
        let inter_cipher_2: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[2u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[2u8],
            step: true
        };
        let inter_cipher_3: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[3u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[3u8],
            step: true
        };
        let inter_cipher_4: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[4u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[4u8],
            step: true
        };
        let inter_cipher_5: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[5u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[5u8],
            step: true
        };
        let inter_cipher_6: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[6u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[6u8],
            step: true
        };
        let inter_cipher_7: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[7u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[7u8],
            step: true
        };
        let inter_cipher_8: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[8u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[8u8],
            step: true
        };
        let inter_cipher_9: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[9u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[9u8],
            step: true
        };
        let inter_cipher_10: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[10u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[10u8],
            step: true
        };
        let inter_cipher_11: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[11u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[11u8],
            step: true
        };
        let inter_cipher_12: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[12u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[12u8],
            step: true
        };
        let inter_cipher_13: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[13u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[13u8],
            step: true
        };
        let inter_cipher_14: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[14u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[14u8],
            step: true
        };
        let inter_cipher_15: IntermediaryCiphertext = IntermediaryCiphertext {
            owner: validators[15u8],
            triple_index: triple_index,
            validator_index: validator_index,
            ciphertext: ciphertexts[15u8],
            step: true
        };

        return (
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
    }


    transition spend_intermediary_ciphers(
        inter_cipher_0: IntermediaryCiphertext,
        inter_cipher_1: IntermediaryCiphertext,
        inter_cipher_2: IntermediaryCiphertext,
        inter_cipher_3: IntermediaryCiphertext,
        inter_cipher_4: IntermediaryCiphertext,
        inter_cipher_5: IntermediaryCiphertext,
        inter_cipher_6: IntermediaryCiphertext,
        inter_cipher_7: IntermediaryCiphertext,
        inter_cipher_8: IntermediaryCiphertext,
        inter_cipher_9: IntermediaryCiphertext,
        inter_cipher_10: IntermediaryCiphertext,
        inter_cipher_11: IntermediaryCiphertext,
        inter_cipher_12: IntermediaryCiphertext,
        inter_cipher_13: IntermediaryCiphertext,
        inter_cipher_14: IntermediaryCiphertext,
        inter_cipher_15: IntermediaryCiphertext
    ) {
        assert_eq(self.caller, dcp_beaver_triples.aleo);
    }
}
