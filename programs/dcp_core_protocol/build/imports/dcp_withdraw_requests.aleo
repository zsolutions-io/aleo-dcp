program dcp_withdraw_requests.aleo;

record WithdrawRequest:
    owner as address.private;
    custody_hash as field.private;
    to as address.private;
    fee_amount as u64.private;
    request_id as field.private;


function submit_requests_to_validators:
    input r0 as [address; 16u32].private;
    input r1 as field.private;
    input r2 as field.private;
    input r3 as address.private;
    input r4 as u64.private;
    assert.eq self.caller data_custody_protocol.aleo;
    cast r0[0u32] r1 r3 r4 r2 into r5 as WithdrawRequest.record;
    cast r0[1u32] r1 r3 r4 r2 into r6 as WithdrawRequest.record;
    cast r0[2u32] r1 r3 r4 r2 into r7 as WithdrawRequest.record;
    cast r0[3u32] r1 r3 r4 r2 into r8 as WithdrawRequest.record;
    cast r0[4u32] r1 r3 r4 r2 into r9 as WithdrawRequest.record;
    cast r0[5u32] r1 r3 r4 r2 into r10 as WithdrawRequest.record;
    cast r0[6u32] r1 r3 r4 r2 into r11 as WithdrawRequest.record;
    cast r0[7u32] r1 r3 r4 r2 into r12 as WithdrawRequest.record;
    cast r0[8u32] r1 r3 r4 r2 into r13 as WithdrawRequest.record;
    cast r0[9u32] r1 r3 r4 r2 into r14 as WithdrawRequest.record;
    cast r0[10u32] r1 r3 r4 r2 into r15 as WithdrawRequest.record;
    cast r0[11u32] r1 r3 r4 r2 into r16 as WithdrawRequest.record;
    cast r0[12u32] r1 r3 r4 r2 into r17 as WithdrawRequest.record;
    cast r0[13u32] r1 r3 r4 r2 into r18 as WithdrawRequest.record;
    cast r0[14u32] r1 r3 r4 r2 into r19 as WithdrawRequest.record;
    cast r0[15u32] r1 r3 r4 r2 into r20 as WithdrawRequest.record;
    output r5 as WithdrawRequest.record;
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


function spend_withdraw_request:
    input r0 as WithdrawRequest.record;
    assert.eq self.caller dcp_core_protocol.aleo;
