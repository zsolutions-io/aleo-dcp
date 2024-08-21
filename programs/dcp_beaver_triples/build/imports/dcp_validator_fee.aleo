import credits.aleo;
program dcp_validator_fee.aleo;


record Fee:
    owner as address.private;
    microcredits as u64.private;
    expire as u32.private;


function update_fee:
    input r0 as Fee.record;
    input r1 as address.private;
    input r2 as u64.private;
    input r3 as u32.private;
    assert.eq self.caller dcp_core_protocol.aleo;
    cast r1 r2 r3 into r4 as Fee.record;
    output r4 as Fee.record;



function burn_fee:
    input r0 as Fee.record;
    call credits.aleo/transfer_public r0.owner r0.microcredits into r1;
    async burn_fee r1 r0.expire into r2;
    output r2 as dcp_validator_fee.aleo/burn_fee.future;

finalize burn_fee:
    input r0 as credits.aleo/transfer_public.future;
    input r1 as u32.public;
    await r0;
    gte r1 block.height into r2;
    assert.eq r2 true;




function save_fee:
    input r0 as Fee.record;
    cast r0.owner r0.microcredits 4294967295u32 into r1 as Fee.record;
    async save_fee r0.expire into r2;
    output r1 as Fee.record;
    output r2 as dcp_validator_fee.aleo/save_fee.future;

finalize save_fee:
    input r0 as u32.public;
    gte r0 block.height into r1;
    assert.eq r1 true;



function mint_null_fee:
    cast self.signer 0u64 4294967295u32 into r0 as Fee.record;
    output r0 as Fee.record;
