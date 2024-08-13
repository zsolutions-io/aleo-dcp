import credits.aleo;
import dcp_validator_fee.aleo;
import dcp_validator_shares.aleo;
import dcp_open_requests.aleo;
program dcp_core_protocol.aleo;



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



struct Proposal:
    validators as [address; 16u32];
    threshold as u8;
    current_validator_set_index as u64;

struct CustodyState:
    validator_set_index as u64;
    custody_trace as field;

struct ShareIdentifier:
    custody as Custody;
    custody_trace as field;
    index as field;

record DestinationShare:
    owner as address.private;
    share as Share.private;
    custody as Custody.private;
    custody_trace as field.private;


mapping validator_sets:
	key as u64.public;
	value as [address; 16u32].public;


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
	value as [boolean; 16u32].public;


mapping custodies:
	key as field.public;
	value as CustodyState.public;


mapping publicShares:
	key as field.public;
	value as field.public;


function initiate_validators:
    input r0 as [address; 16u32].public;
    input r1 as u8.public;
    assert.eq self.caller aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t;
    async initiate_validators r0 r1 into r2;
    output r2 as dcp_core_protocol.aleo/initiate_validators.future;

finalize initiate_validators:
    input r0 as [address; 16u32].public;
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
    output r1 as dcp_core_protocol.aleo/initiate_proposal.future;

finalize initiate_proposal:
    input r0 as address.public;
    input r1 as [address; 16u32].public;
    input r2 as u8.public;
    input r3 as u64.public;
    cast r1 r2 r3 into r4 as Proposal;
    hash.bhp256 r4 into r5 as field;
    get validator_sets_length[true] into r6;
    sub r6 1u64 into r7;
    assert.eq r4.current_validator_set_index r7;
    get validator_sets[r4.current_validator_set_index] into r8;
    is.eq r0 r8[0u32] into r9;
    or false r9 into r10;
    is.eq r0 r8[1u32] into r11;
    or r10 r11 into r12;
    is.eq r0 r8[2u32] into r13;
    or r12 r13 into r14;
    is.eq r0 r8[3u32] into r15;
    or r14 r15 into r16;
    is.eq r0 r8[4u32] into r17;
    or r16 r17 into r18;
    is.eq r0 r8[5u32] into r19;
    or r18 r19 into r20;
    is.eq r0 r8[6u32] into r21;
    or r20 r21 into r22;
    is.eq r0 r8[7u32] into r23;
    or r22 r23 into r24;
    is.eq r0 r8[8u32] into r25;
    or r24 r25 into r26;
    is.eq r0 r8[9u32] into r27;
    or r26 r27 into r28;
    is.eq r0 r8[10u32] into r29;
    or r28 r29 into r30;
    is.eq r0 r8[11u32] into r31;
    or r30 r31 into r32;
    is.eq r0 r8[12u32] into r33;
    or r32 r33 into r34;
    is.eq r0 r8[13u32] into r35;
    or r34 r35 into r36;
    is.eq r0 r8[14u32] into r37;
    or r36 r37 into r38;
    is.eq r0 r8[15u32] into r39;
    or r38 r39 into r40;
    set r4 into proposals[r5];










function vote:
    input r0 as Proposal.public;
    input r1 as u8.public;
    input r2 as boolean.public;
    async vote self.caller r0.validators r0.threshold r0.current_validator_set_index r1 r2 into r3;
    output r3 as dcp_core_protocol.aleo/vote.future;

finalize vote:
    input r0 as address.public;
    input r1 as [address; 16u32].public;
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
    is.eq 0u8 r4 into r11;
    ternary r11 r10[0u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r12;
    is.eq 1u8 r4 into r13;
    ternary r13 r10[1u32] r12 into r14;
    is.eq 2u8 r4 into r15;
    ternary r15 r10[2u32] r14 into r16;
    is.eq 3u8 r4 into r17;
    ternary r17 r10[3u32] r16 into r18;
    is.eq 4u8 r4 into r19;
    ternary r19 r10[4u32] r18 into r20;
    is.eq 5u8 r4 into r21;
    ternary r21 r10[5u32] r20 into r22;
    is.eq 6u8 r4 into r23;
    ternary r23 r10[6u32] r22 into r24;
    is.eq 7u8 r4 into r25;
    ternary r25 r10[7u32] r24 into r26;
    is.eq 8u8 r4 into r27;
    ternary r27 r10[8u32] r26 into r28;
    is.eq 9u8 r4 into r29;
    ternary r29 r10[9u32] r28 into r30;
    is.eq 10u8 r4 into r31;
    ternary r31 r10[10u32] r30 into r32;
    is.eq 11u8 r4 into r33;
    ternary r33 r10[11u32] r32 into r34;
    is.eq 12u8 r4 into r35;
    ternary r35 r10[12u32] r34 into r36;
    is.eq 13u8 r4 into r37;
    ternary r37 r10[13u32] r36 into r38;
    is.eq 14u8 r4 into r39;
    ternary r39 r10[14u32] r38 into r40;
    is.eq 15u8 r4 into r41;
    ternary r41 r10[15u32] r40 into r42;
    assert.eq r42 r0;
    cast  false false false false false false false false false false false false false false false false into r43 as [boolean; 16u32];
    get.or_use votes[r7] r43 into r44;
    is.eq r4 0u8 into r45;
    ternary r45 r5 r44[0u32] into r46;
    is.eq r4 1u8 into r47;
    ternary r47 r5 r44[1u32] into r48;
    is.eq r4 2u8 into r49;
    ternary r49 r5 r44[2u32] into r50;
    is.eq r4 3u8 into r51;
    ternary r51 r5 r44[3u32] into r52;
    is.eq r4 4u8 into r53;
    ternary r53 r5 r44[4u32] into r54;
    is.eq r4 5u8 into r55;
    ternary r55 r5 r44[5u32] into r56;
    is.eq r4 6u8 into r57;
    ternary r57 r5 r44[6u32] into r58;
    is.eq r4 7u8 into r59;
    ternary r59 r5 r44[7u32] into r60;
    is.eq r4 8u8 into r61;
    ternary r61 r5 r44[8u32] into r62;
    is.eq r4 9u8 into r63;
    ternary r63 r5 r44[9u32] into r64;
    is.eq r4 10u8 into r65;
    ternary r65 r5 r44[10u32] into r66;
    is.eq r4 11u8 into r67;
    ternary r67 r5 r44[11u32] into r68;
    is.eq r4 12u8 into r69;
    ternary r69 r5 r44[12u32] into r70;
    is.eq r4 13u8 into r71;
    ternary r71 r5 r44[13u32] into r72;
    is.eq r4 14u8 into r73;
    ternary r73 r5 r44[14u32] into r74;
    is.eq r4 15u8 into r75;
    ternary r75 r5 r44[15u32] into r76;
    cast  r46 r48 r50 r52 r54 r56 r58 r60 r62 r64 r66 r68 r70 r72 r74 r76 into r77 as [boolean; 16u32];
    set r77 into votes[r7];






function accept_proposal:
    input r0 as Proposal.public;
    input r1 as boolean.public;
    async accept_proposal self.caller r0.validators r0.threshold r0.current_validator_set_index r1 into r2;
    output r2 as dcp_core_protocol.aleo/accept_proposal.future;

finalize accept_proposal:
    input r0 as address.public;
    input r1 as [address; 16u32].public;
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
    or false r10 into r11;
    is.eq r0 r9[1u32] into r12;
    or r11 r12 into r13;
    is.eq r0 r9[2u32] into r14;
    or r13 r14 into r15;
    is.eq r0 r9[3u32] into r16;
    or r15 r16 into r17;
    is.eq r0 r9[4u32] into r18;
    or r17 r18 into r19;
    is.eq r0 r9[5u32] into r20;
    or r19 r20 into r21;
    is.eq r0 r9[6u32] into r22;
    or r21 r22 into r23;
    is.eq r0 r9[7u32] into r24;
    or r23 r24 into r25;
    is.eq r0 r9[8u32] into r26;
    or r25 r26 into r27;
    is.eq r0 r9[9u32] into r28;
    or r27 r28 into r29;
    is.eq r0 r9[10u32] into r30;
    or r29 r30 into r31;
    is.eq r0 r9[11u32] into r32;
    or r31 r32 into r33;
    is.eq r0 r9[12u32] into r34;
    or r33 r34 into r35;
    is.eq r0 r9[13u32] into r36;
    or r35 r36 into r37;
    is.eq r0 r9[14u32] into r38;
    or r37 r38 into r39;
    is.eq r0 r9[15u32] into r40;
    or r39 r40 into r41;
    get vote_approval_threshold[true] into r42;
    get votes[r6] into r43;
    cast r43[0u32] into r44 as u8;
    add 0u8 r44 into r45;
    cast r43[1u32] into r46 as u8;
    add r45 r46 into r47;
    cast r43[2u32] into r48 as u8;
    add r47 r48 into r49;
    cast r43[3u32] into r50 as u8;
    add r49 r50 into r51;
    cast r43[4u32] into r52 as u8;
    add r51 r52 into r53;
    cast r43[5u32] into r54 as u8;
    add r53 r54 into r55;
    cast r43[6u32] into r56 as u8;
    add r55 r56 into r57;
    cast r43[7u32] into r58 as u8;
    add r57 r58 into r59;
    cast r43[8u32] into r60 as u8;
    add r59 r60 into r61;
    cast r43[9u32] into r62 as u8;
    add r61 r62 into r63;
    cast r43[10u32] into r64 as u8;
    add r63 r64 into r65;
    cast r43[11u32] into r66 as u8;
    add r65 r66 into r67;
    cast r43[12u32] into r68 as u8;
    add r67 r68 into r69;
    cast r43[13u32] into r70 as u8;
    add r69 r70 into r71;
    cast r43[14u32] into r72 as u8;
    add r71 r72 into r73;
    cast r43[15u32] into r74 as u8;
    add r73 r74 into r75;
    gte r75 r42 into r76;
    assert.eq r76 true;
    add r7 1u64 into r77;
    set r77 into validator_sets_length[true];
    set r5.validators into validator_sets[r7];
    set r5.threshold into vote_approval_threshold[true];






function custody_data_as_program:
    input r0 as field.public;
    input r1 as [address; 16u32].public;
    input r2 as field.public;
    assert.eq self.caller data_custody_protocol.aleo;
    async custody_data_as_program r0 r1 r2 into r3;
    output r3 as dcp_core_protocol.aleo/custody_data_as_program.future;

finalize custody_data_as_program:
    input r0 as field.public;
    input r1 as [address; 16u32].public;
    input r2 as field.public;
    cast 0u64 r2 into r3 as CustodyState;
    get.or_use custodies[r0] r3 into r4;
    get validator_sets_length[true] into r5;
    is.eq r4.custody_trace r2 into r6;
    sub r5 1u64 into r7;
    ternary r6 r7 r4.validator_set_index into r8;
    get validator_sets[r8] into r9;
    assert.eq r1 r9;
    cast  r4.custody_trace r2 into r10 as [field; 2u32];
    hash.bhp256 r10 into r11 as field;
    ternary r6 r2 r11 into r12;
    cast r8 r12 into r13 as CustodyState;
    set r13 into custodies[r0];




function request_open:
    input r0 as field.public;
    input r1 as [address; 16u32].public;
    input r2 as field.public;
    assert.eq self.caller data_custody_protocol.aleo;
    async request_open r0 r1 r2 into r3;
    output r3 as dcp_core_protocol.aleo/request_open.future;

finalize request_open:
    input r0 as field.public;
    input r1 as [address; 16u32].public;
    input r2 as field.public;
    get custodies[r0] into r3;
    assert.eq r2 r3.custody_trace;
    get validator_sets[r3.validator_set_index] into r4;
    assert.eq r1 r4;







function process_private_request:
    input r0 as dcp_validator_shares.aleo/ValidatorShare.record;
    input r1 as dcp_open_requests.aleo/OpenRequest.record;
    input r2 as dcp_validator_fee.aleo/Fee.record;
    hash.bhp256 r0.custody into r3 as field;
    assert.eq r1.custody_hash r3;
    assert.neq r1.to aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc;
    cast r1.to r0.share r0.custody r1.custody_trace into r4 as DestinationShare.record;
    call dcp_open_requests.aleo/spend_open_request r1;
    add r1.fee_amount r2.microcredits into r5;
    lt r1.expire r2.expire into r6;
    ternary r6 r1.expire r2.expire into r7;
    call dcp_validator_fee.aleo/update_fee r2 self.signer r5 r7 into r8;
    assert.eq r1.custody_trace r0.custody_trace;
    output r4 as DestinationShare.record;
    output r8 as dcp_validator_fee.aleo/Fee.record;



function process_public_request:
    input r0 as dcp_validator_shares.aleo/ValidatorShare.record;
    input r1 as dcp_open_requests.aleo/OpenRequest.record;
    input r2 as dcp_validator_fee.aleo/Fee.record;
    hash.bhp256 r0.custody into r3 as field;
    assert.eq r1.custody_hash r3;
    assert.eq r1.to aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc;
    call dcp_open_requests.aleo/spend_open_request r1;
    add r1.fee_amount r2.microcredits into r4;
    lt r1.expire r2.expire into r5;
    ternary r5 r1.expire r2.expire into r6;
    call dcp_validator_fee.aleo/update_fee r2 self.signer r4 r6 into r7;
    assert.eq r1.custody_trace r0.custody_trace;
    cast r0.custody r1.custody_trace r0.share.index into r8 as ShareIdentifier;
    hash.bhp256 r8 into r9 as field;
    async process_public_request r9 r0.share.share_val into r10;
    output r7 as dcp_validator_fee.aleo/Fee.record;
    output r10 as dcp_core_protocol.aleo/process_public_request.future;

finalize process_public_request:
    input r0 as field.public;
    input r1 as field.public;
    set r1 into publicShares[r0];
    assert.eq true true;



function spend_destination_shares:
    input r0 as DestinationShare.record;
    input r1 as DestinationShare.record;
    input r2 as DestinationShare.record;
    input r3 as DestinationShare.record;
    input r4 as DestinationShare.record;
    input r5 as DestinationShare.record;
    input r6 as DestinationShare.record;
    input r7 as DestinationShare.record;
    input r8 as DestinationShare.record;
    input r9 as DestinationShare.record;
    input r10 as DestinationShare.record;
    input r11 as DestinationShare.record;
    input r12 as DestinationShare.record;
    input r13 as DestinationShare.record;
    input r14 as DestinationShare.record;
    assert.eq self.caller dcp_reconstruct_secret.aleo;


function mint_null_destination_share:
    input r0 as Custody.private;
    input r1 as field.private;
    cast 0field 0field into r2 as Share;
    cast self.signer r2 r0 r1 into r3 as DestinationShare.record;
    output r3 as DestinationShare.record;
