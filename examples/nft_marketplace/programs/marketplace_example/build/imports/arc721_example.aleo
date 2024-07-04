program arc721_example.aleo;

struct approval:
    approver as address;
    spender as address;

struct data:
    metadata as [field; 4u32];

record NFT:
    owner as address.private;
    data as data.private;
    edition as scalar.private;

record NFTView:
    owner as address.private;
    data as data.private;
    edition as scalar.private;


mapping nft_owners:
	key as field.public;
	value as address.public;


mapping for_all_approvals:
	key as field.public;
	value as boolean.public;


mapping nft_approvals:
	key as field.public;
	value as field.public;


mapping nft_commits:
	key as field.public;
	value as boolean.public;

function transfer_private:
    input r0 as NFT.record;
    input r1 as address.private;
    cast r1 r0.data r0.edition into r2 as NFT.record;
    output r2 as NFT.record;





function transfer_private_to_public:
    input r0 as NFT.record;
    input r1 as address.public;
    hash.bhp256 r0.data into r2 as field;
    commit.bhp256 r2 r0.edition into r3 as field;
    cast r1 r0.data r0.edition into r4 as NFTView.record;
    async transfer_private_to_public r1 r3 into r5;
    output r4 as NFTView.record;
    output r5 as arc721_example.aleo/transfer_private_to_public.future;

finalize transfer_private_to_public:
    input r0 as address.public;
    input r1 as field.public;
    set r0 into nft_owners[r1];




function transfer_public:
    input r0 as data.private;
    input r1 as scalar.private;
    input r2 as address.public;
    hash.bhp256 r0 into r3 as field;
    commit.bhp256 r3 r1 into r4 as field;
    cast r2 r0 r1 into r5 as NFTView.record;
    async transfer_public r2 r4 self.caller into r6;
    output r5 as NFTView.record;
    output r6 as arc721_example.aleo/transfer_public.future;

finalize transfer_public:
    input r0 as address.public;
    input r1 as field.public;
    input r2 as address.public;
    get nft_owners[r1] into r3;
    assert.eq r2 r3;
    remove nft_approvals[r1];
    set r0 into nft_owners[r1];




function transfer_public_as_signer:
    input r0 as data.private;
    input r1 as scalar.private;
    input r2 as address.public;
    hash.bhp256 r0 into r3 as field;
    commit.bhp256 r3 r1 into r4 as field;
    cast r2 r0 r1 into r5 as NFTView.record;
    async transfer_public_as_signer r2 r4 self.signer into r6;
    output r5 as NFTView.record;
    output r6 as arc721_example.aleo/transfer_public_as_signer.future;

finalize transfer_public_as_signer:
    input r0 as address.public;
    input r1 as field.public;
    input r2 as address.public;
    get nft_owners[r1] into r3;
    assert.eq r2 r3;
    remove nft_approvals[r1];
    set r0 into nft_owners[r1];




function transfer_public_to_private:
    input r0 as data.private;
    input r1 as scalar.private;
    input r2 as address.private;
    hash.bhp256 r0 into r3 as field;
    commit.bhp256 r3 r1 into r4 as field;
    async transfer_public_to_private self.caller r4 into r5;
    cast r2 r0 r1 into r6 as NFT.record;
    output r6 as NFT.record;
    output r5 as arc721_example.aleo/transfer_public_to_private.future;

finalize transfer_public_to_private:
    input r0 as address.public;
    input r1 as field.public;
    get nft_owners[r1] into r2;
    assert.eq r0 r2;
    remove nft_approvals[r1];
    remove nft_owners[r1];




function set_for_all_approval:
    input r0 as address.private;
    input r1 as boolean.public;
    cast self.caller r0 into r2 as approval;
    hash.bhp256 r2 into r3 as field;
    async set_for_all_approval r3 r1 into r4;
    output r4 as arc721_example.aleo/set_for_all_approval.future;

finalize set_for_all_approval:
    input r0 as field.public;
    input r1 as boolean.public;
    set r1 into for_all_approvals[r0];




function approve_public:
    input r0 as address.private;
    input r1 as data.private;
    input r2 as scalar.private;
    hash.bhp256 r1 into r3 as field;
    commit.bhp256 r3 r2 into r4 as field;
    cast self.caller r0 into r5 as approval;
    hash.bhp256 r5 into r6 as field;
    async approve_public self.caller r6 r4 into r7;
    output r7 as arc721_example.aleo/approve_public.future;

finalize approve_public:
    input r0 as address.public;
    input r1 as field.public;
    input r2 as field.public;
    get nft_owners[r2] into r3;
    assert.eq r3 r0;
    set r1 into nft_approvals[r2];




function transfer_from_public:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as data.private;
    input r3 as scalar.private;
    hash.bhp256 r2 into r4 as field;
    commit.bhp256 r4 r3 into r5 as field;
    cast r1 r2 r3 into r6 as NFTView.record;
    cast r0 self.caller into r7 as approval;
    hash.bhp256 r7 into r8 as field;
    async transfer_from_public r8 r0 r1 r5 into r9;
    output r6 as NFTView.record;
    output r9 as arc721_example.aleo/transfer_from_public.future;

finalize transfer_from_public:
    input r0 as field.public;
    input r1 as address.public;
    input r2 as address.public;
    input r3 as field.public;
    contains nft_approvals[r3] into r4;
    get.or_use for_all_approvals[r0] false into r5;
    or r4 r5 into r6;
    assert.eq r6 true;
    get nft_owners[r3] into r7;
    assert.eq r1 r7;
    remove nft_approvals[r3];
    set r2 into nft_owners[r3];




function update_edition_private:
    input r0 as NFT.record;
    input r1 as scalar.private;
    cast r0.owner r0.data r1 into r2 as NFT.record;
    hash.bhp256 r0.data into r3 as field;
    commit.bhp256 r3 r1 into r4 as field;
    async update_edition_private r4 into r5;
    output r2 as NFT.record;
    output r5 as arc721_example.aleo/update_edition_private.future;

finalize update_edition_private:
    input r0 as field.public;
    contains nft_commits[r0] into r1;
    not r1 into r2;
    assert.eq r2 true;
    set true into nft_commits[r0];




function mint:
    input r0 as data.private;
    input r1 as scalar.private;
    hash.bhp256 r0 into r2 as field;
    commit.bhp256 r2 r1 into r3 as field;
    cast self.caller r0 r1 into r4 as NFT.record;
    async mint r3 into r5;
    output r4 as NFT.record;
    output r5 as arc721_example.aleo/mint.future;

finalize mint:
    input r0 as field.public;
    contains nft_commits[r0] into r1;
    not r1 into r2;
    assert.eq r2 true;
    set true into nft_commits[r0];

