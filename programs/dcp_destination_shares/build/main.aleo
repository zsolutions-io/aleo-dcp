program dcp_destination_shares.aleo;

struct Share:
    share_val as field;
    index as field;

struct Custody:
    origin as address;
    custody_key as field;
    threshold as u8;

record DestinationShare:
    owner as address.private;
    share as Share.private;
    custody as Custody.private;
    custody_trace as field.private;


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


function submit_request_shares:
    input r0 as address.private;
    input r1 as Share.private;
    input r2 as Custody.private;
    input r3 as field.private;
    assert.eq self.caller dcp_core_protocol.aleo;
    cast r0 r1 r2 r3 into r4 as DestinationShare.record;
    output r4 as DestinationShare.record;


function submit_list_request_shares:
    input r0 as [address; 16u32].private;
    input r1 as Share.private;
    input r2 as Custody.private;
    input r3 as field.private;
    assert.eq self.caller dcp_core_protocol.aleo;
    cast r0[0u32] r1 r2 r3 into r4 as DestinationShare.record;
    cast r0[1u32] r1 r2 r3 into r5 as DestinationShare.record;
    cast r0[2u32] r1 r2 r3 into r6 as DestinationShare.record;
    cast r0[3u32] r1 r2 r3 into r7 as DestinationShare.record;
    cast r0[4u32] r1 r2 r3 into r8 as DestinationShare.record;
    cast r0[5u32] r1 r2 r3 into r9 as DestinationShare.record;
    cast r0[6u32] r1 r2 r3 into r10 as DestinationShare.record;
    cast r0[7u32] r1 r2 r3 into r11 as DestinationShare.record;
    cast r0[8u32] r1 r2 r3 into r12 as DestinationShare.record;
    cast r0[9u32] r1 r2 r3 into r13 as DestinationShare.record;
    cast r0[10u32] r1 r2 r3 into r14 as DestinationShare.record;
    cast r0[11u32] r1 r2 r3 into r15 as DestinationShare.record;
    cast r0[12u32] r1 r2 r3 into r16 as DestinationShare.record;
    cast r0[13u32] r1 r2 r3 into r17 as DestinationShare.record;
    cast r0[14u32] r1 r2 r3 into r18 as DestinationShare.record;
    cast r0[15u32] r1 r2 r3 into r19 as DestinationShare.record;
    output r4 as DestinationShare.record;
    output r5 as DestinationShare.record;
    output r6 as DestinationShare.record;
    output r7 as DestinationShare.record;
    output r8 as DestinationShare.record;
    output r9 as DestinationShare.record;
    output r10 as DestinationShare.record;
    output r11 as DestinationShare.record;
    output r12 as DestinationShare.record;
    output r13 as DestinationShare.record;
    output r14 as DestinationShare.record;
    output r15 as DestinationShare.record;
    output r16 as DestinationShare.record;
    output r17 as DestinationShare.record;
    output r18 as DestinationShare.record;
    output r19 as DestinationShare.record;
