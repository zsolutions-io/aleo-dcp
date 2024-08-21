program dcp_beaver_intermediaries.aleo;

struct Ciphertext:
    value_ as group;
    nonce as group;

record IntermediaryCiphertext:
    owner as address.private;
    triple_index as field.private;
    validator_index as u8.private;
    ciphertext as Ciphertext.private;
    step as boolean.private;


function sumbit_left_ciphers:
    input r0 as [address; 16u32].private;
    input r1 as field.private;
    input r2 as u8.private;
    input r3 as Ciphertext.private;
    assert.eq self.caller dcp_beaver_triples.aleo;
    cast r0[0u32] r1 r2 r3 false into r4 as IntermediaryCiphertext.record;
    cast r0[1u32] r1 r2 r3 false into r5 as IntermediaryCiphertext.record;
    cast r0[2u32] r1 r2 r3 false into r6 as IntermediaryCiphertext.record;
    cast r0[3u32] r1 r2 r3 false into r7 as IntermediaryCiphertext.record;
    cast r0[4u32] r1 r2 r3 false into r8 as IntermediaryCiphertext.record;
    cast r0[5u32] r1 r2 r3 false into r9 as IntermediaryCiphertext.record;
    cast r0[6u32] r1 r2 r3 false into r10 as IntermediaryCiphertext.record;
    cast r0[7u32] r1 r2 r3 false into r11 as IntermediaryCiphertext.record;
    cast r0[8u32] r1 r2 r3 false into r12 as IntermediaryCiphertext.record;
    cast r0[9u32] r1 r2 r3 false into r13 as IntermediaryCiphertext.record;
    cast r0[10u32] r1 r2 r3 false into r14 as IntermediaryCiphertext.record;
    cast r0[11u32] r1 r2 r3 false into r15 as IntermediaryCiphertext.record;
    cast r0[12u32] r1 r2 r3 false into r16 as IntermediaryCiphertext.record;
    cast r0[13u32] r1 r2 r3 false into r17 as IntermediaryCiphertext.record;
    cast r0[14u32] r1 r2 r3 false into r18 as IntermediaryCiphertext.record;
    cast r0[15u32] r1 r2 r3 false into r19 as IntermediaryCiphertext.record;
    output r4 as IntermediaryCiphertext.record;
    output r5 as IntermediaryCiphertext.record;
    output r6 as IntermediaryCiphertext.record;
    output r7 as IntermediaryCiphertext.record;
    output r8 as IntermediaryCiphertext.record;
    output r9 as IntermediaryCiphertext.record;
    output r10 as IntermediaryCiphertext.record;
    output r11 as IntermediaryCiphertext.record;
    output r12 as IntermediaryCiphertext.record;
    output r13 as IntermediaryCiphertext.record;
    output r14 as IntermediaryCiphertext.record;
    output r15 as IntermediaryCiphertext.record;
    output r16 as IntermediaryCiphertext.record;
    output r17 as IntermediaryCiphertext.record;
    output r18 as IntermediaryCiphertext.record;
    output r19 as IntermediaryCiphertext.record;


function sumbit_right_ciphers:
    input r0 as [address; 16u32].private;
    input r1 as field.private;
    input r2 as u8.private;
    input r3 as [Ciphertext; 16u32].private;
    assert.eq self.caller dcp_beaver_triples.aleo;
    cast r0[0u32] r1 r2 r3[0u32] true into r4 as IntermediaryCiphertext.record;
    cast r0[1u32] r1 r2 r3[1u32] true into r5 as IntermediaryCiphertext.record;
    cast r0[2u32] r1 r2 r3[2u32] true into r6 as IntermediaryCiphertext.record;
    cast r0[3u32] r1 r2 r3[3u32] true into r7 as IntermediaryCiphertext.record;
    cast r0[4u32] r1 r2 r3[4u32] true into r8 as IntermediaryCiphertext.record;
    cast r0[5u32] r1 r2 r3[5u32] true into r9 as IntermediaryCiphertext.record;
    cast r0[6u32] r1 r2 r3[6u32] true into r10 as IntermediaryCiphertext.record;
    cast r0[7u32] r1 r2 r3[7u32] true into r11 as IntermediaryCiphertext.record;
    cast r0[8u32] r1 r2 r3[8u32] true into r12 as IntermediaryCiphertext.record;
    cast r0[9u32] r1 r2 r3[9u32] true into r13 as IntermediaryCiphertext.record;
    cast r0[10u32] r1 r2 r3[10u32] true into r14 as IntermediaryCiphertext.record;
    cast r0[11u32] r1 r2 r3[11u32] true into r15 as IntermediaryCiphertext.record;
    cast r0[12u32] r1 r2 r3[12u32] true into r16 as IntermediaryCiphertext.record;
    cast r0[13u32] r1 r2 r3[13u32] true into r17 as IntermediaryCiphertext.record;
    cast r0[14u32] r1 r2 r3[14u32] true into r18 as IntermediaryCiphertext.record;
    cast r0[15u32] r1 r2 r3[15u32] true into r19 as IntermediaryCiphertext.record;
    output r4 as IntermediaryCiphertext.record;
    output r5 as IntermediaryCiphertext.record;
    output r6 as IntermediaryCiphertext.record;
    output r7 as IntermediaryCiphertext.record;
    output r8 as IntermediaryCiphertext.record;
    output r9 as IntermediaryCiphertext.record;
    output r10 as IntermediaryCiphertext.record;
    output r11 as IntermediaryCiphertext.record;
    output r12 as IntermediaryCiphertext.record;
    output r13 as IntermediaryCiphertext.record;
    output r14 as IntermediaryCiphertext.record;
    output r15 as IntermediaryCiphertext.record;
    output r16 as IntermediaryCiphertext.record;
    output r17 as IntermediaryCiphertext.record;
    output r18 as IntermediaryCiphertext.record;
    output r19 as IntermediaryCiphertext.record;


function spend_intermediary_ciphers:
    input r0 as IntermediaryCiphertext.record;
    input r1 as IntermediaryCiphertext.record;
    input r2 as IntermediaryCiphertext.record;
    input r3 as IntermediaryCiphertext.record;
    input r4 as IntermediaryCiphertext.record;
    input r5 as IntermediaryCiphertext.record;
    input r6 as IntermediaryCiphertext.record;
    input r7 as IntermediaryCiphertext.record;
    input r8 as IntermediaryCiphertext.record;
    input r9 as IntermediaryCiphertext.record;
    input r10 as IntermediaryCiphertext.record;
    input r11 as IntermediaryCiphertext.record;
    input r12 as IntermediaryCiphertext.record;
    input r13 as IntermediaryCiphertext.record;
    input r14 as IntermediaryCiphertext.record;
    input r15 as IntermediaryCiphertext.record;
    assert.eq self.caller dcp_beaver_triples.aleo;
