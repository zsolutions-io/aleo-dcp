import credits.aleo;
import dcp_validator_shares.aleo;
import dcp_withdraw_requests.aleo;
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
    weight as u64;



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
    data_custody_hash as field;
    nft_data_address as address;


mapping listings:
	key as field.public;
	value as ListingData.public;


mapping listings_buyer:
	key as field.public;
	value as address.public;






function list:
    input r0 as arc721_example.aleo/NFT.record;
    input r1 as u64.public;
    input r2 as scalar.private;
    input r3 as [field; 15u32].private;
    input r4 as [address; 16u32].private;
    call arc721_example.aleo/transfer_private_to_public r0 marketplace_example.aleo into r5 r6;
    cast r2 into r7 as field;
    mul r2 522678458525321116977504528531602186870683848189190546523208313015552693483group into r8;
    cast r8 into r9 as address;
    hash.bhp256 r9 into r10 as field;
    cast r9 r0.data r0.edition into r11 as NFTView.record;
    hash.bhp256 r0.data into r12 as field;
    commit.bhp256 r12 r0.edition into r13 as field;
    cast marketplace_example.aleo r10 8u8 into r14 as Custody;
    hash.bhp256 r14 into r15 as field;
    call data_custody_protocol.aleo/custody_data_as_program r7 r10 r3 r4 8u8 into r16;
    async list r13 r1 self.caller r15 r9 r6 r16 into r17;
    output r11 as NFTView.record;
    output r17 as marketplace_example.aleo/list.future;

finalize list:
    input r0 as field.public;
    input r1 as u64.public;
    input r2 as address.public;
    input r3 as field.public;
    input r4 as address.public;
    input r5 as arc721_example.aleo/transfer_private_to_public.future;
    input r6 as data_custody_protocol.aleo/custody_data_as_program.future;
    await r5;
    await r6;
    cast r1 r2 r3 r4 into r7 as ListingData;
    set r7 into listings[r0];




function accept_listing:
    input r0 as field.public;
    input r1 as field.public;
    input r2 as ListingData.private;
    input r3 as [address; 16u32].public;
    input r4 as u64.public;
    input r5 as credits.aleo/credits.record;
    call credits.aleo/transfer_public_as_signer r2.seller r2.price into r6;
    hash.bhp256 r2.nft_data_address into r7 as field;
    call data_custody_protocol.aleo/request_data_as_program r7 r1 self.signer 8u8 r3 r4 r5 into r8 r9;
    async accept_listing self.caller r0 r2 r6 r9 into r10;
    output r8 as credits.aleo/credits.record;
    output r10 as marketplace_example.aleo/accept_listing.future;

finalize accept_listing:
    input r0 as address.public;
    input r1 as field.public;
    input r2 as ListingData.public;
    input r3 as credits.aleo/transfer_public_as_signer.future;
    input r4 as data_custody_protocol.aleo/request_data_as_program.future;
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
    call arc721_example.aleo/transfer_public_to_private r0 r1 self.caller into r5 r6;
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

