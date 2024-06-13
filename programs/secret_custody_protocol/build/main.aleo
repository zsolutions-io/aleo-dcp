import protocol_validators.aleo;
program secret_custody_protocol.aleo;

struct Proposal:
    validators as [address; 15u32];
    threshold as u8;
    current_validator_set_index as u64;

struct CustodyState:
    validator_set_index as u64;
    requested as boolean;

struct Custody:
    initiator as address;
    data_address as address;
    threshold as u8;

struct Share:
    share_val as field;
    index as field;

record ValidatorShare:
    owner as address.private;
    share as Share.private;
    custody as Custody.private;

record WithdrawRequest:
    owner as address.private;
    custody_hash as field.private;
    to as address.private;

record DestinationShare:
    owner as address.private;
    share as Share.private;


mapping custodies:
	key as field.public;
	value as CustodyState.public;


mapping submitted_shares:
	key as field.public;
	value as u8.public;



closure evaluate_polynomial:
    input r0 as [field; 14u32];
    input r1 as u8;
    input r2 as field;
    input r3 as field;
    mul 1field r2 into r4;
    sub r1 1u8 into r5;
    lt 0u8 r5 into r6;
    mul r0[0u32] r4 into r7;
    ternary r6 r7 0field into r8;
    add r3 r8 into r9;
    mul r4 r2 into r10;
    sub r1 1u8 into r11;
    lt 1u8 r11 into r12;
    mul r0[1u32] r10 into r13;
    ternary r12 r13 0field into r14;
    add r9 r14 into r15;
    mul r10 r2 into r16;
    sub r1 1u8 into r17;
    lt 2u8 r17 into r18;
    mul r0[2u32] r16 into r19;
    ternary r18 r19 0field into r20;
    add r15 r20 into r21;
    mul r16 r2 into r22;
    sub r1 1u8 into r23;
    lt 3u8 r23 into r24;
    mul r0[3u32] r22 into r25;
    ternary r24 r25 0field into r26;
    add r21 r26 into r27;
    mul r22 r2 into r28;
    sub r1 1u8 into r29;
    lt 4u8 r29 into r30;
    mul r0[4u32] r28 into r31;
    ternary r30 r31 0field into r32;
    add r27 r32 into r33;
    mul r28 r2 into r34;
    sub r1 1u8 into r35;
    lt 5u8 r35 into r36;
    mul r0[5u32] r34 into r37;
    ternary r36 r37 0field into r38;
    add r33 r38 into r39;
    mul r34 r2 into r40;
    sub r1 1u8 into r41;
    lt 6u8 r41 into r42;
    mul r0[6u32] r40 into r43;
    ternary r42 r43 0field into r44;
    add r39 r44 into r45;
    mul r40 r2 into r46;
    sub r1 1u8 into r47;
    lt 7u8 r47 into r48;
    mul r0[7u32] r46 into r49;
    ternary r48 r49 0field into r50;
    add r45 r50 into r51;
    mul r46 r2 into r52;
    sub r1 1u8 into r53;
    lt 8u8 r53 into r54;
    mul r0[8u32] r52 into r55;
    ternary r54 r55 0field into r56;
    add r51 r56 into r57;
    mul r52 r2 into r58;
    sub r1 1u8 into r59;
    lt 9u8 r59 into r60;
    mul r0[9u32] r58 into r61;
    ternary r60 r61 0field into r62;
    add r57 r62 into r63;
    mul r58 r2 into r64;
    sub r1 1u8 into r65;
    lt 10u8 r65 into r66;
    mul r0[10u32] r64 into r67;
    ternary r66 r67 0field into r68;
    add r63 r68 into r69;
    mul r64 r2 into r70;
    sub r1 1u8 into r71;
    lt 11u8 r71 into r72;
    mul r0[11u32] r70 into r73;
    ternary r72 r73 0field into r74;
    add r69 r74 into r75;
    mul r70 r2 into r76;
    sub r1 1u8 into r77;
    lt 12u8 r77 into r78;
    mul r0[12u32] r76 into r79;
    ternary r78 r79 0field into r80;
    add r75 r80 into r81;
    mul r76 r2 into r82;
    sub r1 1u8 into r83;
    lt 13u8 r83 into r84;
    mul r0[13u32] r82 into r85;
    ternary r84 r85 0field into r86;
    add r81 r86 into r87;
    output r87 as field;



function custody_data_as_program:
    input r0 as scalar.private;
    input r1 as [field; 14u32].private;
    input r2 as [address; 15u32].private;
    input r3 as u8.private;
    assert.neq self.caller self.signer;
    cast r0 into r4 as field;
    mul r0 group::GEN into r5;
    cast r5 into r6 as address;
    cast self.caller r6 r3 into r7 as Custody;
    hash.bhp256 r7 into r8 as field;
    call evaluate_polynomial r1 r3 1field r4 into r9;
    cast r9 1field into r10 as Share;
    cast r2[0u32] r10 r7 into r11 as ValidatorShare.record;
    call evaluate_polynomial r1 r3 2field r4 into r12;
    cast r12 2field into r13 as Share;
    cast r2[1u32] r13 r7 into r14 as ValidatorShare.record;
    call evaluate_polynomial r1 r3 3field r4 into r15;
    cast r15 3field into r16 as Share;
    cast r2[2u32] r16 r7 into r17 as ValidatorShare.record;
    call evaluate_polynomial r1 r3 4field r4 into r18;
    cast r18 4field into r19 as Share;
    cast r2[3u32] r19 r7 into r20 as ValidatorShare.record;
    call evaluate_polynomial r1 r3 5field r4 into r21;
    cast r21 5field into r22 as Share;
    cast r2[4u32] r22 r7 into r23 as ValidatorShare.record;
    call evaluate_polynomial r1 r3 6field r4 into r24;
    cast r24 6field into r25 as Share;
    cast r2[5u32] r25 r7 into r26 as ValidatorShare.record;
    call evaluate_polynomial r1 r3 7field r4 into r27;
    cast r27 7field into r28 as Share;
    cast r2[6u32] r28 r7 into r29 as ValidatorShare.record;
    call evaluate_polynomial r1 r3 8field r4 into r30;
    cast r30 8field into r31 as Share;
    cast r2[7u32] r31 r7 into r32 as ValidatorShare.record;
    call evaluate_polynomial r1 r3 9field r4 into r33;
    cast r33 9field into r34 as Share;
    cast r2[8u32] r34 r7 into r35 as ValidatorShare.record;
    call evaluate_polynomial r1 r3 10field r4 into r36;
    cast r36 10field into r37 as Share;
    cast r2[9u32] r37 r7 into r38 as ValidatorShare.record;
    call evaluate_polynomial r1 r3 11field r4 into r39;
    cast r39 11field into r40 as Share;
    cast r2[10u32] r40 r7 into r41 as ValidatorShare.record;
    call evaluate_polynomial r1 r3 12field r4 into r42;
    cast r42 12field into r43 as Share;
    cast r2[11u32] r43 r7 into r44 as ValidatorShare.record;
    call evaluate_polynomial r1 r3 13field r4 into r45;
    cast r45 13field into r46 as Share;
    cast r2[12u32] r46 r7 into r47 as ValidatorShare.record;
    call evaluate_polynomial r1 r3 14field r4 into r48;
    cast r48 14field into r49 as Share;
    cast r2[13u32] r49 r7 into r50 as ValidatorShare.record;
    call evaluate_polynomial r1 r3 15field r4 into r51;
    cast r51 15field into r52 as Share;
    cast r2[14u32] r52 r7 into r53 as ValidatorShare.record;
    async custody_data_as_program r8 r2 into r54;
    output r11 as ValidatorShare.record;
    output r14 as ValidatorShare.record;
    output r17 as ValidatorShare.record;
    output r20 as ValidatorShare.record;
    output r23 as ValidatorShare.record;
    output r26 as ValidatorShare.record;
    output r29 as ValidatorShare.record;
    output r32 as ValidatorShare.record;
    output r35 as ValidatorShare.record;
    output r38 as ValidatorShare.record;
    output r41 as ValidatorShare.record;
    output r44 as ValidatorShare.record;
    output r47 as ValidatorShare.record;
    output r50 as ValidatorShare.record;
    output r53 as ValidatorShare.record;
    output r54 as secret_custody_protocol.aleo/custody_data_as_program.future;

finalize custody_data_as_program:
    input r0 as field.public;
    input r1 as [address; 15u32].public;
    contains custodies[r0] into r2;
    not r2 into r3;
    assert.eq r3 true;
    get protocol_validators.aleo/validator_sets_length[true] into r4;
    sub r4 1u64 into r5;
    get protocol_validators.aleo/validator_sets[r5] into r6;
    assert.eq r1 r6;
    cast r5 false into r7 as CustodyState;
    set r7 into custodies[r0];




function request_data_as_program:
    input r0 as address.private;
    input r1 as address.private;
    input r2 as u8.private;
    input r3 as [address; 15u32].public;
    assert.neq self.caller self.signer;
    cast self.caller r0 r2 into r4 as Custody;
    hash.bhp256 r4 into r5 as field;
    cast r3[0u32] r5 r1 into r6 as WithdrawRequest.record;
    cast r3[1u32] r5 r1 into r7 as WithdrawRequest.record;
    cast r3[2u32] r5 r1 into r8 as WithdrawRequest.record;
    cast r3[3u32] r5 r1 into r9 as WithdrawRequest.record;
    cast r3[4u32] r5 r1 into r10 as WithdrawRequest.record;
    cast r3[5u32] r5 r1 into r11 as WithdrawRequest.record;
    cast r3[6u32] r5 r1 into r12 as WithdrawRequest.record;
    cast r3[7u32] r5 r1 into r13 as WithdrawRequest.record;
    cast r3[8u32] r5 r1 into r14 as WithdrawRequest.record;
    cast r3[9u32] r5 r1 into r15 as WithdrawRequest.record;
    cast r3[10u32] r5 r1 into r16 as WithdrawRequest.record;
    cast r3[11u32] r5 r1 into r17 as WithdrawRequest.record;
    cast r3[12u32] r5 r1 into r18 as WithdrawRequest.record;
    cast r3[13u32] r5 r1 into r19 as WithdrawRequest.record;
    cast r3[14u32] r5 r1 into r20 as WithdrawRequest.record;
    async request_data_as_program r5 r3 into r21;
    output r6 as WithdrawRequest.record;
    output r7 as WithdrawRequest.record;
    output r8 as WithdrawRequest.record;
    output r9 as WithdrawRequest.record;
    output r10 as WithdrawRequest.record;
    output r11 as WithdrawRequest.record;
    output r12 as WithdrawRequest.record;
    output r13 as WithdrawRequest.record;
    output r14 as WithdrawRequest.record;
    output r15 as WithdrawRequest.record;
    output r16 as WithdrawRequest.record;
    output r17 as WithdrawRequest.record;
    output r18 as WithdrawRequest.record;
    output r19 as WithdrawRequest.record;
    output r20 as WithdrawRequest.record;
    output r21 as secret_custody_protocol.aleo/request_data_as_program.future;

finalize request_data_as_program:
    input r0 as field.public;
    input r1 as [address; 15u32].public;
    get custodies[r0] into r2;
    not r2.requested into r3;
    assert.eq r3 true;
    get protocol_validators.aleo/validator_sets[r2.validator_set_index] into r4;
    assert.eq r1 r4;
    cast r2.validator_set_index true into r5 as CustodyState;
    set r5 into custodies[r0];




function process_request_as_validator:
    input r0 as ValidatorShare.record;
    input r1 as WithdrawRequest.record;
    hash.bhp256 r0.custody into r2 as field;
    assert.eq r1.custody_hash r2;
    cast r1.to r0.share into r3 as DestinationShare.record;
    async process_request_as_validator r2 into r4;
    output r3 as DestinationShare.record;
    output r4 as secret_custody_protocol.aleo/process_request_as_validator.future;

finalize process_request_as_validator:
    input r0 as field.public;
    get.or_use submitted_shares[r0] 0u8 into r1;
    add r1 1u8 into r2;
    set r2 into submitted_shares[r0];




function assert_completed_as_program:
    input r0 as address.private;
    input r1 as u8.public;
    assert.neq self.caller self.signer;
    cast self.caller r0 r1 into r2 as Custody;
    hash.bhp256 r2 into r3 as field;
    async assert_completed_as_program r3 r1 into r4;
    output r4 as secret_custody_protocol.aleo/assert_completed_as_program.future;

finalize assert_completed_as_program:
    input r0 as field.public;
    input r1 as u8.public;
    get.or_use submitted_shares[r0] 0u8 into r2;
    gte r2 r1 into r3;
    assert.eq r3 true;

