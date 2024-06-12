program reconstruct_secret.aleo;

struct Share:
    share_val as field;
    index as field;




closure reconstruct3:
    input r0 as [Share; 3u32];
    is.neq 0u8 0u8 into r1;
    sub r0[0u32].index r0[0u32].index into r2;
    is.eq r2 0field into r3;
    ternary r3 1field r2 into r4;
    inv r4 into r5;
    mul r0[0u32].index r5 into r6;
    ternary r1 r6 1field into r7;
    mul 1field r7 into r8;
    is.neq 0u8 1u8 into r9;
    sub r0[1u32].index r0[0u32].index into r10;
    is.eq r10 0field into r11;
    ternary r11 1field r10 into r12;
    inv r12 into r13;
    mul r0[1u32].index r13 into r14;
    ternary r9 r14 1field into r15;
    mul r8 r15 into r16;
    is.neq 0u8 2u8 into r17;
    sub r0[2u32].index r0[0u32].index into r18;
    is.eq r18 0field into r19;
    ternary r19 1field r18 into r20;
    inv r20 into r21;
    mul r0[2u32].index r21 into r22;
    ternary r17 r22 1field into r23;
    mul r16 r23 into r24;
    mul r0[0u32].share_val r24 into r25;
    add 0field r25 into r26;
    is.neq 1u8 0u8 into r27;
    sub r0[0u32].index r0[1u32].index into r28;
    is.eq r28 0field into r29;
    ternary r29 1field r28 into r30;
    inv r30 into r31;
    mul r0[0u32].index r31 into r32;
    ternary r27 r32 1field into r33;
    mul 1field r33 into r34;
    is.neq 1u8 1u8 into r35;
    sub r0[1u32].index r0[1u32].index into r36;
    is.eq r36 0field into r37;
    ternary r37 1field r36 into r38;
    inv r38 into r39;
    mul r0[1u32].index r39 into r40;
    ternary r35 r40 1field into r41;
    mul r34 r41 into r42;
    is.neq 1u8 2u8 into r43;
    sub r0[2u32].index r0[1u32].index into r44;
    is.eq r44 0field into r45;
    ternary r45 1field r44 into r46;
    inv r46 into r47;
    mul r0[2u32].index r47 into r48;
    ternary r43 r48 1field into r49;
    mul r42 r49 into r50;
    mul r0[1u32].share_val r50 into r51;
    add r26 r51 into r52;
    is.neq 2u8 0u8 into r53;
    sub r0[0u32].index r0[2u32].index into r54;
    is.eq r54 0field into r55;
    ternary r55 1field r54 into r56;
    inv r56 into r57;
    mul r0[0u32].index r57 into r58;
    ternary r53 r58 1field into r59;
    mul 1field r59 into r60;
    is.neq 2u8 1u8 into r61;
    sub r0[1u32].index r0[2u32].index into r62;
    is.eq r62 0field into r63;
    ternary r63 1field r62 into r64;
    inv r64 into r65;
    mul r0[1u32].index r65 into r66;
    ternary r61 r66 1field into r67;
    mul r60 r67 into r68;
    is.neq 2u8 2u8 into r69;
    sub r0[2u32].index r0[2u32].index into r70;
    is.eq r70 0field into r71;
    ternary r71 1field r70 into r72;
    inv r72 into r73;
    mul r0[2u32].index r73 into r74;
    ternary r69 r74 1field into r75;
    mul r68 r75 into r76;
    mul r0[2u32].share_val r76 into r77;
    add r52 r77 into r78;
    output r78 as field;


function call_reconstruct3:
    input r0 as [Share; 3u32].private;
    call reconstruct3 r0 into r1;
    output r1 as field.private;


closure evaluate_polynomial3:
    input r0 as [field; 2u32];
    input r1 as field;
    input r2 as field;
    mul 1field r1 into r3;
    mul r0[0u32] r3 into r4;
    add r2 r4 into r5;
    mul r3 r1 into r6;
    mul r0[1u32] r6 into r7;
    add r5 r7 into r8;
    output r8 as field;
