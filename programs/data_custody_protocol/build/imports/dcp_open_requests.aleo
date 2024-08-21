program dcp_open_requests.aleo;

record OpenRequest:
    owner as address.private;
    custody_hash as field.private;
    to as address.private;
    fee_amount as u64.private;
    custody_trace as field.private;
    expire as u32.private;

record OpenListRequest:
    owner as address.private;
    custody_hash as field.private;
    to as [address; 16u32].private;
    fee_amount as u64.private;
    custody_trace as field.private;
    expire as u32.private;


function submit_requests_to_validators:
    input r0 as [address; 16u32].public;
    input r1 as field.public;
    input r2 as address.private;
    input r3 as u64.private;
    input r4 as field.public;
    input r5 as u32.public;
    assert.eq self.caller data_custody_protocol.aleo;
    cast r0[0u32] r1 r2 r3 r4 r5 into r6 as OpenRequest.record;
    cast r0[1u32] r1 r2 r3 r4 r5 into r7 as OpenRequest.record;
    cast r0[2u32] r1 r2 r3 r4 r5 into r8 as OpenRequest.record;
    cast r0[3u32] r1 r2 r3 r4 r5 into r9 as OpenRequest.record;
    cast r0[4u32] r1 r2 r3 r4 r5 into r10 as OpenRequest.record;
    cast r0[5u32] r1 r2 r3 r4 r5 into r11 as OpenRequest.record;
    cast r0[6u32] r1 r2 r3 r4 r5 into r12 as OpenRequest.record;
    cast r0[7u32] r1 r2 r3 r4 r5 into r13 as OpenRequest.record;
    cast r0[8u32] r1 r2 r3 r4 r5 into r14 as OpenRequest.record;
    cast r0[9u32] r1 r2 r3 r4 r5 into r15 as OpenRequest.record;
    cast r0[10u32] r1 r2 r3 r4 r5 into r16 as OpenRequest.record;
    cast r0[11u32] r1 r2 r3 r4 r5 into r17 as OpenRequest.record;
    cast r0[12u32] r1 r2 r3 r4 r5 into r18 as OpenRequest.record;
    cast r0[13u32] r1 r2 r3 r4 r5 into r19 as OpenRequest.record;
    cast r0[14u32] r1 r2 r3 r4 r5 into r20 as OpenRequest.record;
    cast r0[15u32] r1 r2 r3 r4 r5 into r21 as OpenRequest.record;
    output r6 as OpenRequest.record;
    output r7 as OpenRequest.record;
    output r8 as OpenRequest.record;
    output r9 as OpenRequest.record;
    output r10 as OpenRequest.record;
    output r11 as OpenRequest.record;
    output r12 as OpenRequest.record;
    output r13 as OpenRequest.record;
    output r14 as OpenRequest.record;
    output r15 as OpenRequest.record;
    output r16 as OpenRequest.record;
    output r17 as OpenRequest.record;
    output r18 as OpenRequest.record;
    output r19 as OpenRequest.record;
    output r20 as OpenRequest.record;
    output r21 as OpenRequest.record;


function submit_l_requests_to_validators:
    input r0 as [address; 16u32].public;
    input r1 as field.public;
    input r2 as [address; 16u32].private;
    input r3 as u64.private;
    input r4 as field.public;
    input r5 as u32.public;
    assert.eq self.caller data_custody_protocol.aleo;
    cast r0[0u32] r1 r2 r3 r4 r5 into r6 as OpenListRequest.record;
    cast r0[1u32] r1 r2 r3 r4 r5 into r7 as OpenListRequest.record;
    cast r0[2u32] r1 r2 r3 r4 r5 into r8 as OpenListRequest.record;
    cast r0[3u32] r1 r2 r3 r4 r5 into r9 as OpenListRequest.record;
    cast r0[4u32] r1 r2 r3 r4 r5 into r10 as OpenListRequest.record;
    cast r0[5u32] r1 r2 r3 r4 r5 into r11 as OpenListRequest.record;
    cast r0[6u32] r1 r2 r3 r4 r5 into r12 as OpenListRequest.record;
    cast r0[7u32] r1 r2 r3 r4 r5 into r13 as OpenListRequest.record;
    cast r0[8u32] r1 r2 r3 r4 r5 into r14 as OpenListRequest.record;
    cast r0[9u32] r1 r2 r3 r4 r5 into r15 as OpenListRequest.record;
    cast r0[10u32] r1 r2 r3 r4 r5 into r16 as OpenListRequest.record;
    cast r0[11u32] r1 r2 r3 r4 r5 into r17 as OpenListRequest.record;
    cast r0[12u32] r1 r2 r3 r4 r5 into r18 as OpenListRequest.record;
    cast r0[13u32] r1 r2 r3 r4 r5 into r19 as OpenListRequest.record;
    cast r0[14u32] r1 r2 r3 r4 r5 into r20 as OpenListRequest.record;
    cast r0[15u32] r1 r2 r3 r4 r5 into r21 as OpenListRequest.record;
    output r6 as OpenListRequest.record;
    output r7 as OpenListRequest.record;
    output r8 as OpenListRequest.record;
    output r9 as OpenListRequest.record;
    output r10 as OpenListRequest.record;
    output r11 as OpenListRequest.record;
    output r12 as OpenListRequest.record;
    output r13 as OpenListRequest.record;
    output r14 as OpenListRequest.record;
    output r15 as OpenListRequest.record;
    output r16 as OpenListRequest.record;
    output r17 as OpenListRequest.record;
    output r18 as OpenListRequest.record;
    output r19 as OpenListRequest.record;
    output r20 as OpenListRequest.record;
    output r21 as OpenListRequest.record;


function spend_open_request:
    input r0 as OpenRequest.record;
    assert.eq self.caller dcp_core_protocol.aleo;


function spend_open_l_request:
    input r0 as OpenListRequest.record;
    assert.eq self.caller dcp_core_protocol.aleo;
