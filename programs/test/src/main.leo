// The 'test' program.
program test.aleo {
    const ADDRESS_GEN: group = 
        522678458525321116977504528531602186870683848189190546523208313015552693483group;

    struct Ciphertext {
        value_: group,
        nonce: group
    }

    /*
    inline mul_field_ciphertext(
        operand: field, ciphertext: Ciphertext
    ) -> Ciphertext {
        return Ciphertext{
            value_: operand * ciphertext.value_,
            nonce: operand * ciphertext.nonce
        };
    }
    */

    inline view_key_to_address(v: scalar) -> address{
        return (v * ADDRESS_GEN) as address;
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
        let cipher_nonce: group = view_key_to_address(obfuscator) as group;
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

    transition gen_address(v: scalar) -> address {
        return view_key_to_address(v) as address;
    }

    transition sum(c1: Ciphertext, c2: Ciphertext) -> Ciphertext {
        return add_ciphertext(c1, c2);
    }

    transition test(
        v: scalar,
        p1: scalar, o1: scalar,
        p2: scalar, o2: scalar,
    ){
        let a: address = view_key_to_address(v) as address;
        let s: Ciphertext = add_ciphertext(
            additive_homomorphic_encrypt(a, p1, o1),
            additive_homomorphic_encrypt(a, p2, o2)
        );
        additive_homomorphic_decrypt(v, s, p1 + p2);
        // additive_homomorphic_decrypt(v, s, p1 + p2 + 1scalar);
    }

    transition test2()->scalar{
        return -10_000scalar;
    }
}
