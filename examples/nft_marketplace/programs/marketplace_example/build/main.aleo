import credits.aleo;
import dcp_validator_shares.aleo;
import dcp_open_requests.aleo;
import dcp_fee_management.aleo;
import dcp_core_protocol.aleo;
import data_custody_protocol.aleo;
import arc721_example.aleo;
program marketplace_example.aleo;


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


struct data:
    metadata as [field; 4u32];


record NFTView:
    owner as address.private;
    data as data.private;
    edition as scalar.private;

struct ListingData:
    price as u64;
    seller as address;
    dcp_key as field;


mapping listings:
	key as field.public;
	value as ListingData.public;


mapping listings_buyer:
	key as field.public;
	value as address.public;


mapping dcp_keys:
	key as field.public;
	value as boolean.public;






function list:
    input r0 as arc721_example.aleo/NFT.record;
    input r1 as u64.public;
    input r2 as field.public;
    input r3 as scalar.private;
    input r4 as [field; 15u32].private;
    input r5 as [address; 16u32].public;
    input r6 as scalar.public;
    call arc721_example.aleo/transfer_private_to_public r0 marketplace_example.aleo into r7 r8;
    cast r3 into r9 as field;
    mul r3 522678458525321116977504528531602186870683848189190546523208313015552693483group into r10;
    cast r10 into r11 as address;
    cast r11 r0.data r0.edition into r12 as NFTView.record;
    hash.bhp256 r0.data into r13 as field;
    commit.bhp256 r13 r0.edition into r14 as field;
    call data_custody_protocol.aleo/add_private r9 r2 r4 r5 8u8 r6 into r15;
    async list r14 r1 self.caller r2 r8 r15 into r16;
    output r12 as NFTView.record;
    output r16 as marketplace_example.aleo/list.future;

finalize list:
    input r0 as field.public;
    input r1 as u64.public;
    input r2 as address.public;
    input r3 as field.public;
    input r4 as arc721_example.aleo/transfer_private_to_public.future;
    input r5 as data_custody_protocol.aleo/add_private.future;
    await r4;
    await r5;
    cast r1 r2 r3 into r6 as ListingData;
    set r6 into listings[r0];
    contains dcp_keys[r3] into r7;
    not r7 into r8;
    assert.eq r8 true;
    set true into dcp_keys[r3];




function accept_listing:
    input r0 as field.public;
    input r1 as ListingData.private;
    input r2 as [address; 16u32].public;
    input r3 as u64.public;
    input r4 as credits.aleo/credits.record;
    input r5 as u32.public;
    input r6 as field.public;
    call credits.aleo/transfer_public_as_signer r1.seller r1.price into r7;
    call data_custody_protocol.aleo/request_open r1.dcp_key self.signer 8u8 r6 r2 r3 r4 r5 into r8 r9;
    async accept_listing self.caller r0 r1 r7 r9 into r10;
    output r8 as credits.aleo/credits.record;
    output r10 as marketplace_example.aleo/accept_listing.future;

finalize accept_listing:
    input r0 as address.public;
    input r1 as field.public;
    input r2 as ListingData.public;
    input r3 as credits.aleo/transfer_public_as_signer.future;
    input r4 as data_custody_protocol.aleo/request_open.future;
    get listings[r1] into r5;
    assert.eq r5 r2;
    contains listings_buyer[r1] into r6;
    not r6 into r7;
    assert.eq r7 true;
    set r0 into listings_buyer[r1];
    await r3;
    await r4;




function withdraw_nft:
    input r0 as data.private;
    input r1 as scalar.private;
    input r2 as ListingData.private;
    hash.bhp256 r0 into r3 as field;
    commit.bhp256 r3 r1 into r4 as field;
    call arc721_example.aleo/transfer_public_to_private r0 r1 self.signer into r5 r6;
    async withdraw_nft self.caller r4 r2 r6 into r7;
    output r5 as arc721_example.aleo/NFT.record;
    output r7 as marketplace_example.aleo/withdraw_nft.future;

finalize withdraw_nft:
    input r0 as address.public;
    input r1 as field.public;
    input r2 as ListingData.public;
    input r3 as arc721_example.aleo/transfer_public_to_private.future;
    get listings[r1] into r4;
    assert.eq r4 r2;
    get listings_buyer[r1] into r5;
    assert.eq r5 r0;
    remove listings_buyer[r1];
    remove listings[r1];
    await r3;

