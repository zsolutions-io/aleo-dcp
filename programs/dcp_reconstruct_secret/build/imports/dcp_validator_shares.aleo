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
    weight as u64;

record ValidatorShare:
    owner as address.private;
    share as Share.private;
    custody as Custody.private;
    weight as u64.private;


function submit_shares_to_validators:
    input r0 as [ValidatorShareData; 16u32].private;
    input r1 as Custody.private;
    assert.eq self.caller data_custody_protocol.aleo;
    cast r0[0u32].validator r0[0u32].share r1 r0[0u32].weight into r2 as ValidatorShare.record;
    cast r0[1u32].validator r0[1u32].share r1 r0[1u32].weight into r3 as ValidatorShare.record;
    cast r0[2u32].validator r0[2u32].share r1 r0[2u32].weight into r4 as ValidatorShare.record;
    cast r0[3u32].validator r0[3u32].share r1 r0[3u32].weight into r5 as ValidatorShare.record;
    cast r0[4u32].validator r0[4u32].share r1 r0[4u32].weight into r6 as ValidatorShare.record;
    cast r0[5u32].validator r0[5u32].share r1 r0[5u32].weight into r7 as ValidatorShare.record;
    cast r0[6u32].validator r0[6u32].share r1 r0[6u32].weight into r8 as ValidatorShare.record;
    cast r0[7u32].validator r0[7u32].share r1 r0[7u32].weight into r9 as ValidatorShare.record;
    cast r0[8u32].validator r0[8u32].share r1 r0[8u32].weight into r10 as ValidatorShare.record;
    cast r0[9u32].validator r0[9u32].share r1 r0[9u32].weight into r11 as ValidatorShare.record;
    cast r0[10u32].validator r0[10u32].share r1 r0[10u32].weight into r12 as ValidatorShare.record;
    cast r0[11u32].validator r0[11u32].share r1 r0[11u32].weight into r13 as ValidatorShare.record;
    cast r0[12u32].validator r0[12u32].share r1 r0[12u32].weight into r14 as ValidatorShare.record;
    cast r0[13u32].validator r0[13u32].share r1 r0[13u32].weight into r15 as ValidatorShare.record;
    cast r0[14u32].validator r0[14u32].share r1 r0[14u32].weight into r16 as ValidatorShare.record;
    cast r0[15u32].validator r0[15u32].share r1 r0[15u32].weight into r17 as ValidatorShare.record;
    output r2 as ValidatorShare.record;
    output r3 as ValidatorShare.record;
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


function join_shares_as_validator:
    input r0 as ValidatorShare.record;
    input r1 as ValidatorShare.record;
    is.eq r0.custody r1.custody into r2;
    assert.eq r2 true;
    is.eq r0.share.index r1.share.index into r3;
    assert.eq r3 true;
    add r0.share.share_val r1.share.share_val into r4;
    cast r4 r0.share.index into r5 as Share;
    add r0.weight r1.weight into r6;
    cast self.signer r5 r0.custody r6 into r7 as ValidatorShare.record;
    output r7 as ValidatorShare.record;
