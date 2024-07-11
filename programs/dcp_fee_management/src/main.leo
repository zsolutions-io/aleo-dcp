import credits.aleo;


program dcp_fee_management.aleo {
    record Fee {
        owner: address,
        microcredits: u64,
        expire: u32
    }

    inline min_u32(a: u32, b: u32) -> u32{
        return a<b ? a : b;
    }
    
    transition mint_fee(
        public receiver: address, amount: u64, expire_height: u32
    ) -> Fee {
        assert_eq(self.caller, dcp_core_protocol.aleo);
        return Fee{
            owner: receiver,
            microcredits: amount,
            expire: expire_height
        };
    }

    async transition burn_fee(
        private fee: Fee,
    ) -> Future {
        let unlock_fee_future: Future = credits.aleo/transfer_public(
            fee.owner,
            fee.microcredits,
        );
        return finalize_burn_fee(unlock_fee_future, fee.expire);
    }
    async function finalize_burn_fee(
        unlock_fee_future: Future,
        expire_height: u32
    ){
        unlock_fee_future.await();
        assert(expire_height >= block.height);
    }


    transition join_fee(
        private fee_0: Fee,
        private fee_1: Fee,
    ) -> Fee {
        return Fee{
            owner: fee_0.owner,
            microcredits: fee_0.microcredits + fee_1.microcredits,
            expire: min_u32(fee_0.expire, fee_2.expire)
        };
    }
}
