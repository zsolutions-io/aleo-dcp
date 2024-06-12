program protocol_validators.aleo;

struct Proposal:
    validators as [address; 15u32];
    threshold as u8;
    current_validator_set_index as u64;


mapping validator_sets:
	key as u64.public;
	value as [address; 15u32].public;


mapping validator_sets_length:
	key as boolean.public;
	value as u64.public;


mapping vote_approval_threshold:
	key as boolean.public;
	value as u8.public;


mapping proposals:
	key as field.public;
	value as Proposal.public;


mapping votes:
	key as field.public;
	value as [boolean; 15u32].public;


function initiate_validators:
    input r0 as [address; 15u32].public;
    input r1 as u8.public;
    assert.eq self.caller aleo1rupdxnwys2qktts6dqy7l4pjvng0ruapjxsht6ftsjlcmupl6c8sezw5n3;
    async initiate_validators r0 r1 into r2;
    output r2 as protocol_validators.aleo/initiate_validators.future;

finalize initiate_validators:
    input r0 as [address; 15u32].public;
    input r1 as u8.public;
    contains validator_sets_length[true] into r2;
    not r2 into r3;
    assert.eq r3 true;
    set 1u64 into validator_sets_length[true];
    set r0 into validator_sets[0u64];
    set r1 into vote_approval_threshold[true];








function initiate_proposal:
    input r0 as Proposal.public;
    async initiate_proposal self.caller r0.validators r0.threshold r0.current_validator_set_index into r1;
    output r1 as protocol_validators.aleo/initiate_proposal.future;

finalize initiate_proposal:
    input r0 as address.public;
    input r1 as [address; 15u32].public;
    input r2 as u8.public;
    input r3 as u64.public;
    cast r1 r2 r3 into r4 as Proposal;
    hash.bhp256 r4 into r5 as field;
    get validator_sets_length[true] into r6;
    sub r6 1u64 into r7;
    assert.eq r4.current_validator_set_index r7;
    get validator_sets[r4.current_validator_set_index] into r8;
    is.eq r0 r8[0u32] into r9;
    is.eq r0 r8[1u32] into r10;
    or r9 r10 into r11;
    is.eq r0 r8[2u32] into r12;
    or r11 r12 into r13;
    is.eq r0 r8[3u32] into r14;
    or r13 r14 into r15;
    is.eq r0 r8[4u32] into r16;
    or r15 r16 into r17;
    is.eq r0 r8[5u32] into r18;
    or r17 r18 into r19;
    is.eq r0 r8[6u32] into r20;
    or r19 r20 into r21;
    is.eq r0 r8[7u32] into r22;
    or r21 r22 into r23;
    is.eq r0 r8[8u32] into r24;
    or r23 r24 into r25;
    is.eq r0 r8[9u32] into r26;
    or r25 r26 into r27;
    is.eq r0 r8[10u32] into r28;
    or r27 r28 into r29;
    is.eq r0 r8[11u32] into r30;
    or r29 r30 into r31;
    is.eq r0 r8[12u32] into r32;
    or r31 r32 into r33;
    is.eq r0 r8[13u32] into r34;
    or r33 r34 into r35;
    is.eq r0 r8[14u32] into r36;
    or r35 r36 into r37;
    set r4 into proposals[r5];










function vote:
    input r0 as Proposal.public;
    input r1 as u8.public;
    input r2 as boolean.public;
    async vote self.caller r0.validators r0.threshold r0.current_validator_set_index r1 r2 into r3;
    output r3 as protocol_validators.aleo/vote.future;

finalize vote:
    input r0 as address.public;
    input r1 as [address; 15u32].public;
    input r2 as u8.public;
    input r3 as u64.public;
    input r4 as u8.public;
    input r5 as boolean.public;
    cast r1 r2 r3 into r6 as Proposal;
    hash.bhp256 r6 into r7 as field;
    get validator_sets_length[true] into r8;
    sub r8 1u64 into r9;
    assert.eq r6.current_validator_set_index r9;
    get validator_sets[r6.current_validator_set_index] into r10;
    is.eq r4 0u8 into r11;
    is.eq r4 1u8 into r12;
    is.eq r4 2u8 into r13;
    is.eq r4 3u8 into r14;
    is.eq r4 4u8 into r15;
    is.eq r4 5u8 into r16;
    is.eq r4 6u8 into r17;
    is.eq r4 7u8 into r18;
    is.eq r4 8u8 into r19;
    is.eq r4 9u8 into r20;
    is.eq r4 10u8 into r21;
    is.eq r4 11u8 into r22;
    is.eq r4 12u8 into r23;
    is.eq r4 13u8 into r24;
    is.eq r4 14u8 into r25;
    cast 0group into r26 as address;
    ternary r25 r10[14u32] r26 into r27;
    ternary r24 r10[13u32] r27 into r28;
    ternary r23 r10[12u32] r28 into r29;
    ternary r22 r10[11u32] r29 into r30;
    ternary r21 r10[10u32] r30 into r31;
    ternary r20 r10[9u32] r31 into r32;
    ternary r19 r10[8u32] r32 into r33;
    ternary r18 r10[7u32] r33 into r34;
    ternary r17 r10[6u32] r34 into r35;
    ternary r16 r10[5u32] r35 into r36;
    ternary r15 r10[4u32] r36 into r37;
    ternary r14 r10[3u32] r37 into r38;
    ternary r13 r10[2u32] r38 into r39;
    ternary r12 r10[1u32] r39 into r40;
    ternary r11 r10[0u32] r40 into r41;
    assert.eq r41 r0;
    cast  false false false false false false false false false false false false false false false into r42 as [boolean; 15u32];
    get.or_use votes[r7] r42 into r43;
    is.eq r4 0u8 into r44;
    ternary r44 r5 r43[0u32] into r45;
    is.eq r4 1u8 into r46;
    ternary r46 r5 r43[1u32] into r47;
    is.eq r4 2u8 into r48;
    ternary r48 r5 r43[2u32] into r49;
    is.eq r4 3u8 into r50;
    ternary r50 r5 r43[3u32] into r51;
    is.eq r4 4u8 into r52;
    ternary r52 r5 r43[4u32] into r53;
    is.eq r4 5u8 into r54;
    ternary r54 r5 r43[5u32] into r55;
    is.eq r4 6u8 into r56;
    ternary r56 r5 r43[6u32] into r57;
    is.eq r4 7u8 into r58;
    ternary r58 r5 r43[7u32] into r59;
    is.eq r4 8u8 into r60;
    ternary r60 r5 r43[8u32] into r61;
    is.eq r4 9u8 into r62;
    ternary r62 r5 r43[9u32] into r63;
    is.eq r4 10u8 into r64;
    ternary r64 r5 r43[10u32] into r65;
    is.eq r4 11u8 into r66;
    ternary r66 r5 r43[11u32] into r67;
    is.eq r4 12u8 into r68;
    ternary r68 r5 r43[12u32] into r69;
    is.eq r4 13u8 into r70;
    ternary r70 r5 r43[13u32] into r71;
    is.eq r4 14u8 into r72;
    ternary r72 r5 r43[14u32] into r73;
    cast  r45 r47 r49 r51 r53 r55 r57 r59 r61 r63 r65 r67 r69 r71 r73 into r74 as [boolean; 15u32];
    set r74 into votes[r7];






function accept_proposal:
    input r0 as Proposal.public;
    input r1 as boolean.public;
    async accept_proposal self.caller r0.validators r0.threshold r0.current_validator_set_index r1 into r2;
    output r2 as protocol_validators.aleo/accept_proposal.future;

finalize accept_proposal:
    input r0 as address.public;
    input r1 as [address; 15u32].public;
    input r2 as u8.public;
    input r3 as u64.public;
    input r4 as boolean.public;
    cast r1 r2 r3 into r5 as Proposal;
    hash.bhp256 r5 into r6 as field;
    get validator_sets_length[true] into r7;
    sub r7 1u64 into r8;
    assert.eq r5.current_validator_set_index r8;
    get validator_sets[r5.current_validator_set_index] into r9;
    is.eq r0 r9[0u32] into r10;
    is.eq r0 r9[1u32] into r11;
    or r10 r11 into r12;
    is.eq r0 r9[2u32] into r13;
    or r12 r13 into r14;
    is.eq r0 r9[3u32] into r15;
    or r14 r15 into r16;
    is.eq r0 r9[4u32] into r17;
    or r16 r17 into r18;
    is.eq r0 r9[5u32] into r19;
    or r18 r19 into r20;
    is.eq r0 r9[6u32] into r21;
    or r20 r21 into r22;
    is.eq r0 r9[7u32] into r23;
    or r22 r23 into r24;
    is.eq r0 r9[8u32] into r25;
    or r24 r25 into r26;
    is.eq r0 r9[9u32] into r27;
    or r26 r27 into r28;
    is.eq r0 r9[10u32] into r29;
    or r28 r29 into r30;
    is.eq r0 r9[11u32] into r31;
    or r30 r31 into r32;
    is.eq r0 r9[12u32] into r33;
    or r32 r33 into r34;
    is.eq r0 r9[13u32] into r35;
    or r34 r35 into r36;
    is.eq r0 r9[14u32] into r37;
    or r36 r37 into r38;
    get vote_approval_threshold[true] into r39;
    get votes[r6] into r40;
    cast r40[0u32] into r41 as u8;
    cast r40[1u32] into r42 as u8;
    add r41 r42 into r43;
    cast r40[2u32] into r44 as u8;
    add r43 r44 into r45;
    cast r40[3u32] into r46 as u8;
    add r45 r46 into r47;
    cast r40[4u32] into r48 as u8;
    add r47 r48 into r49;
    cast r40[5u32] into r50 as u8;
    add r49 r50 into r51;
    cast r40[6u32] into r52 as u8;
    add r51 r52 into r53;
    cast r40[7u32] into r54 as u8;
    add r53 r54 into r55;
    cast r40[8u32] into r56 as u8;
    add r55 r56 into r57;
    cast r40[9u32] into r58 as u8;
    add r57 r58 into r59;
    cast r40[10u32] into r60 as u8;
    add r59 r60 into r61;
    cast r40[11u32] into r62 as u8;
    add r61 r62 into r63;
    cast r40[12u32] into r64 as u8;
    add r63 r64 into r65;
    cast r40[13u32] into r66 as u8;
    add r65 r66 into r67;
    cast r40[14u32] into r68 as u8;
    add r67 r68 into r69;
    gte r69 r39 into r70;
    assert.eq r70 true;
    add r7 1u64 into r71;
    set r71 into validator_sets_length[true];
    set r5.validators into validator_sets[r7];
    set r5.threshold into vote_approval_threshold[true];

