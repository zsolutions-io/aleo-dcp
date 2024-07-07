program dcp_hash_custody_offchain.aleo;

struct Custody:
    origin as address;
    custody_key as field;
    threshold as u8;


function hash_custody:
    input r0 as Custody.private;
    hash.bhp256 r0 into r1 as field;
    output r1 as field.private;
