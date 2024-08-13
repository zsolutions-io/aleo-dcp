program dcp_validator_shares.aleo;

struct Custody:
    origin as address;
    custody_key as field;
    threshold as u8;

struct Share:
    share_val as field;
    index as field;

struct ValidatorShareData:
    validator as address;
    share as Share;

record ValidatorShare:
    owner as address.private;
    share as Share.private;
    custody as Custody.private;
    custody_trace as field.private;
    share_type as u8.private;


function submit_shares_to_validators:
    input r0 as [ValidatorShareData; 16u32].private;
    input r1 as Custody.private;
    input r2 as field.private;
    input r3 as u8.private;
    assert.eq self.caller data_custody_protocol.aleo;
    cast r0[0u32].validator r0[0u32].share r1 r2 r3 into r4 as ValidatorShare.record;
    cast r0[1u32].validator r0[1u32].share r1 r2 r3 into r5 as ValidatorShare.record;
    cast r0[2u32].validator r0[2u32].share r1 r2 r3 into r6 as ValidatorShare.record;
    cast r0[3u32].validator r0[3u32].share r1 r2 r3 into r7 as ValidatorShare.record;
    cast r0[4u32].validator r0[4u32].share r1 r2 r3 into r8 as ValidatorShare.record;
    cast r0[5u32].validator r0[5u32].share r1 r2 r3 into r9 as ValidatorShare.record;
    cast r0[6u32].validator r0[6u32].share r1 r2 r3 into r10 as ValidatorShare.record;
    cast r0[7u32].validator r0[7u32].share r1 r2 r3 into r11 as ValidatorShare.record;
    cast r0[8u32].validator r0[8u32].share r1 r2 r3 into r12 as ValidatorShare.record;
    cast r0[9u32].validator r0[9u32].share r1 r2 r3 into r13 as ValidatorShare.record;
    cast r0[10u32].validator r0[10u32].share r1 r2 r3 into r14 as ValidatorShare.record;
    cast r0[11u32].validator r0[11u32].share r1 r2 r3 into r15 as ValidatorShare.record;
    cast r0[12u32].validator r0[12u32].share r1 r2 r3 into r16 as ValidatorShare.record;
    cast r0[13u32].validator r0[13u32].share r1 r2 r3 into r17 as ValidatorShare.record;
    cast r0[14u32].validator r0[14u32].share r1 r2 r3 into r18 as ValidatorShare.record;
    cast r0[15u32].validator r0[15u32].share r1 r2 r3 into r19 as ValidatorShare.record;
    output r4 as ValidatorShare.record;
    output r5 as ValidatorShare.record;
    output r6 as ValidatorShare.record;
    output r7 as ValidatorShare.record;
    output r8 as ValidatorShare.record;
    output r9 as ValidatorShare.record;
    output r10 as ValidatorShare.record;
    output r11 as ValidatorShare.record;
    output r12 as ValidatorShare.record;
    output r13 as ValidatorShare.record;
    output r14 as ValidatorShare.record;
    output r15 as ValidatorShare.record;
    output r16 as ValidatorShare.record;
    output r17 as ValidatorShare.record;
    output r18 as ValidatorShare.record;
    output r19 as ValidatorShare.record;




function process_trivial_operation:
    input r0 as ValidatorShare.record;
    input r1 as ValidatorShare.record;
    is.eq r0.custody r1.custody into r2;
    assert.eq r2 true;
    is.eq r0.share.index r1.share.index into r3;
    assert.eq r3 true;
    is.eq r0.share_type 0u8 into r4;
    is.eq r0.share_type 1u8 into r5;
    or r4 r5 into r6;
    is.eq r0.share_type 3u8 into r7;
    or r6 r7 into r8;
    assert.eq r8 true;
    is.eq r1.share_type 0u8 into r9;
    is.eq r1.share_type 1u8 into r10;
    or r9 r10 into r11;
    assert.eq r11 true;
    is.eq r1.share_type 0u8 into r12;
    add r0.share.share_val r1.share.share_val into r13;
    mul r0.share.share_val r1.share.share_val into r14;
    ternary r12 r13 r14 into r15;
    cast r15 r0.share.index into r16 as Share;
    cast  r0.custody_trace r1.custody_trace into r17 as [field; 2u32];
    hash.bhp256 r17 into r18 as field;
    cast self.signer r16 r0.custody r18 3u8 into r19 as ValidatorShare.record;
    output r19 as ValidatorShare.record;


function preprocess_private_mul:
    input r0 as ValidatorShare.record;
    input r1 as ValidatorShare.record;
    input r2 as ValidatorShare.record;
    input r3 as ValidatorShare.record;
    is.eq r0.share.index r2.share.index into r4;
    assert.eq r4 true;
    is.eq r2.share.index r1.share.index into r5;
    assert.eq r5 true;
    is.eq r1.share.index r3.share.index into r6;
    assert.eq r6 true;
    is.eq r0.share_type 0u8 into r7;
    is.eq r0.share_type 1u8 into r8;
    or r7 r8 into r9;
    is.eq r0.share_type 3u8 into r10;
    or r9 r10 into r11;
    assert.eq r11 true;
    assert.eq r2.share_type 4u8;
    is.eq r1.share_type 2u8 into r12;
    assert.eq r12 true;
    assert.eq r3.share_type 5u8;
    add r0.share.share_val r2.share.share_val into r13;
    cast r13 r0.share.index into r14 as Share;
    add r1.share.share_val r3.share.share_val into r15;
    cast r15 r1.share.index into r16 as Share;
    cast self.signer r14 r0.custody r0.custody_trace 6u8 into r17 as ValidatorShare.record;
    cast self.signer r16 r1.custody r1.custody_trace 7u8 into r18 as ValidatorShare.record;
    cast r1.owner r1.share r1.custody r1.custody_trace 8u8 into r19 as ValidatorShare.record;
    output r17 as ValidatorShare.record;
    output r18 as ValidatorShare.record;
    output r19 as ValidatorShare.record;
