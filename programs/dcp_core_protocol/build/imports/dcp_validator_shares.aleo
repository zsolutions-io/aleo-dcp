import dcp_destination_shares.aleo;
import dcp_reconstruct_secret.aleo;
program dcp_validator_shares.aleo;

struct Share:
    share_val as field;
    index as field;

struct Custody:
    origin as address;
    custody_key as field;
    threshold as u8;



struct Beaver:
    triple_index as field;
    beaver_type as u8;
    validators as [address; 16u32];

struct ValidatorShareData:
    validator as address;
    share as Share;

struct MulParamsData:
    index as field;
    right_operand_share_val as field;
    left_beaver_share_val as field;
    sum_beaver_share_val as field;
    custody as Custody;
    custody_trace as field;
    left as boolean;

record ValidatorShare:
    owner as address.private;
    share as Share.private;
    custody as Custody.private;
    custody_trace as field.private;
    share_type as u8.private;

record MulParams:
    owner as address.private;
    index as field.private;
    right_operand_share_val as field.private;
    left_beaver_share_val as field.private;
    sum_beaver_share_val as field.private;
    custody as Custody.private;
    custody_trace as field.private;


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
    input r4 as ValidatorShare.record;
    input r5 as [address; 16u32].public;
    input r6 as field.public;
    assert.eq r0.custody r1.custody;
    assert.eq r2.custody.origin dcp_beaver_triples.aleo;
    assert.eq r3.custody.origin dcp_beaver_triples.aleo;
    assert.eq r4.custody.origin dcp_beaver_triples.aleo;
    assert.eq r0.share.index r2.share.index;
    assert.eq r2.share.index r1.share.index;
    assert.eq r1.share.index r3.share.index;
    is.eq r0.share_type 0u8 into r7;
    is.eq r0.share_type 1u8 into r8;
    or r7 r8 into r9;
    is.eq r0.share_type 3u8 into r10;
    or r9 r10 into r11;
    assert.eq r11 true;
    is.eq r1.share_type 2u8 into r12;
    assert.eq r12 true;
    cast r6 0u8 r5 into r13 as Beaver;
    hash.bhp256 r13 into r14 as field;
    cast r6 1u8 r5 into r15 as Beaver;
    hash.bhp256 r15 into r16 as field;
    cast r6 2u8 r5 into r17 as Beaver;
    hash.bhp256 r17 into r18 as field;
    assert.eq r2.custody.custody_key r14;
    assert.eq r3.custody.custody_key r16;
    assert.eq r4.custody.custody_key r18;
    add r0.share.share_val r2.share.share_val into r19;
    cast r19 r0.share.index into r20 as Share;
    add r1.share.share_val r3.share.share_val into r21;
    cast r21 r1.share.index into r22 as Share;
    cast  r0.custody_trace r1.custody_trace into r23 as [field; 2u32];
    hash.bhp256 r23 into r24 as field;
    cast self.signer r1.share.index r1.share.share_val r2.share.share_val r4.share.share_val r0.custody r24 into r25 as MulParams.record;
    cast r1.share.index r1.share.share_val r2.share.share_val r4.share.share_val r0.custody r24 true into r26 as MulParamsData;
    hash.bhp256 r26 into r27 as field;
    cast r1.share.index r1.share.share_val r2.share.share_val r4.share.share_val r0.custody r24 false into r28 as MulParamsData;
    hash.bhp256 r28 into r29 as field;
    call dcp_destination_shares.aleo/submit_list_request_shares r5 r20 r0.custody r27 into r30 r31 r32 r33 r34 r35 r36 r37 r38 r39 r40 r41 r42 r43 r44 r45;
    call dcp_destination_shares.aleo/submit_list_request_shares r5 r22 r0.custody r29 into r46 r47 r48 r49 r50 r51 r52 r53 r54 r55 r56 r57 r58 r59 r60 r61;
    output r25 as MulParams.record;


function process_private_mul:
    input r0 as MulParams.record;
    input r1 as dcp_reconstruct_secret.aleo/ReconstructedSecret.record;
    input r2 as dcp_reconstruct_secret.aleo/ReconstructedSecret.record;
    cast r0.index r0.right_operand_share_val r0.left_beaver_share_val r0.sum_beaver_share_val r0.custody r0.custody_trace true into r3 as MulParamsData;
    hash.bhp256 r3 into r4 as field;
    cast r0.index r0.right_operand_share_val r0.left_beaver_share_val r0.sum_beaver_share_val r0.custody r0.custody_trace false into r5 as MulParamsData;
    hash.bhp256 r5 into r6 as field;
    assert.eq r4 r1.custody_trace;
    assert.eq r6 r2.custody_trace;
    assert.eq r0.custody r1.custody;
    assert.eq r0.custody r2.custody;
    call dcp_reconstruct_secret.aleo/spend_reconstructed_secret r1;
    call dcp_reconstruct_secret.aleo/spend_reconstructed_secret r2;
    mul r1.secret r0.right_operand_share_val into r7;
    mul r2.secret r0.left_beaver_share_val into r8;
    sub r7 r8 into r9;
    add r9 r0.sum_beaver_share_val into r10;
    cast r10 r0.index into r11 as Share;
    cast self.signer r11 r0.custody r0.custody_trace 3u8 into r12 as ValidatorShare.record;
    output r12 as ValidatorShare.record;
