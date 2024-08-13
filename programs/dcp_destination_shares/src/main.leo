program dcp_destination_shares.aleo {
    struct Share {
        share_val: field,
        index: field
    }

    struct Custody {
        origin: address,
        custody_key: field,
        threshold: u8
    }

    record DestinationShare {
        owner: address,
        share: Share,
        custody: Custody,
        custody_trace: field
    }

    transition spend_destination_shares(
        destination_share_0: DestinationShare,
        destination_share_1: DestinationShare,
        destination_share_2: DestinationShare,
        destination_share_3: DestinationShare,
        destination_share_4: DestinationShare,
        destination_share_5: DestinationShare,
        destination_share_6: DestinationShare,
        destination_share_7: DestinationShare,
        destination_share_8: DestinationShare,
        destination_share_9: DestinationShare,
        destination_share_10: DestinationShare,
        destination_share_11: DestinationShare,
        destination_share_12: DestinationShare,
        destination_share_13: DestinationShare,
        destination_share_14: DestinationShare
    ){
        assert_eq(self.caller, dcp_reconstruct_secret.aleo);
    }

    transition mint_null_destination_share(
        custody: Custody,
        custody_trace: field,
    ) -> DestinationShare{
        return DestinationShare{
            owner: self.signer,
            share: Share{
                share_val: 0field,
                index: 0field,
            },
            custody: custody,
            custody_trace: custody_trace
        };
    }

    transition submit_request_shares(
        to: address,
        share: Share,
        custody: Custody,
        custody_trace: field
    ) -> DestinationShare {
        assert_eq(self.caller, dcp_core_protocol.aleo);
        let destination_share: DestinationShare = DestinationShare {
            owner: to,
            share: share,
            custody: custody,
            custody_trace:custody_trace
        };
        return destination_share;
    }


    transition submit_list_request_shares(
        to: [address; 16],
        share: Share,
        custody: Custody,
        custody_trace: field
    ) -> (
        DestinationShare,
        DestinationShare,
        DestinationShare,
        DestinationShare,
        DestinationShare,
        DestinationShare,
        DestinationShare,
        DestinationShare,
        DestinationShare,
        DestinationShare,
        DestinationShare,
        DestinationShare,
        DestinationShare,
        DestinationShare,
        DestinationShare,
        DestinationShare
    ) {
        assert(
            self.caller == dcp_core_protocol.aleo
            || self.caller == dcp_validator_shares.aleo
        );

        let destination_share_0: DestinationShare = DestinationShare {
            owner: to[0u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };
        let destination_share_1: DestinationShare = DestinationShare {
            owner: to[1u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };
        let destination_share_2: DestinationShare = DestinationShare {
            owner: to[2u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };
        let destination_share_3: DestinationShare = DestinationShare {
            owner: to[3u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };
        let destination_share_4: DestinationShare = DestinationShare {
            owner: to[4u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };
        let destination_share_5: DestinationShare = DestinationShare {
            owner: to[5u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };
        let destination_share_6: DestinationShare = DestinationShare {
            owner: to[6u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };
        let destination_share_7: DestinationShare = DestinationShare {
            owner: to[7u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };
        let destination_share_8: DestinationShare = DestinationShare {
            owner: to[8u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };
        let destination_share_9: DestinationShare = DestinationShare {
            owner: to[9u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };
        let destination_share_10: DestinationShare = DestinationShare {
            owner: to[10u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };
        let destination_share_11: DestinationShare = DestinationShare {
            owner: to[11u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };
        let destination_share_12: DestinationShare = DestinationShare {
            owner: to[12u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };
        let destination_share_13: DestinationShare = DestinationShare {
            owner: to[13u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };
        let destination_share_14: DestinationShare = DestinationShare {
            owner: to[14u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };
        let destination_share_15: DestinationShare = DestinationShare {
            owner: to[15u8],
            share: share,
            custody: custody,
            custody_trace: custody_trace
        };

        return (
            destination_share_0,
            destination_share_1,
            destination_share_2,
            destination_share_3,
            destination_share_4,
            destination_share_5,
            destination_share_6,
            destination_share_7,
            destination_share_8,
            destination_share_9,
            destination_share_10,
            destination_share_11,
            destination_share_12,
            destination_share_13,
            destination_share_14,
            destination_share_15
        );
    }
}
