import credits.aleo;
program dcp_fee_management.aleo;


record Fee:
    owner as address.private;
    microcredits as u64.private;


function mint_fee:
    input r0 as address.public;
    input r1 as u64.private;
    assert.eq self.caller dcp_core_protocol.aleo;
    cast r0 r1 into r2 as Fee.record;
    output r2 as Fee.record;



function burn_fee:
    input r0 as Fee.record;
    call credits.aleo/transfer_public r0.owner r0.microcredits into r1;
    async burn_fee r1 into r2;
    output r2 as dcp_fee_management.aleo/burn_fee.future;

finalize burn_fee:
    input r0 as credits.aleo/transfer_public.future;
    await r0;



function join_fee:
    input r0 as Fee.record;
    input r1 as Fee.record;
    add r0.microcredits r1.microcredits into r2;
    cast r0.owner r2 into r3 as Fee.record;
    output r3 as Fee.record;
