import credits.aleo;

program dcp_validator_fee.aleo {
    const MAX_U32: u32 = 4294967295u32;

    record Fee {
        owner: address,
        microcredits: u64,
        expire: u32
    }
    
    transition update_fee(
        private previous_fee: Fee,
        private receiver: address,
        private amount: u64,
        private expire_height: u32
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

    async transition save_fee(
        private fee: Fee,
    ) -> (Fee, Future) {
        let non_expireable_fee: Fee = Fee {
            owner: fee.owner,
            microcredits: fee.microcredits,
            expire: MAX_U32
        };
        let save_fee_future: Future = finalize_save_fee(fee.expire);
        return (non_expireable_fee, save_fee_future);
    }
    async function finalize_save_fee(
        expire_height: u32
    ){
        assert(expire_height >= block.height);
    }

    transition mint_null_fee() -> Fee {
        return Fee{
            owner: self.signer,
            microcredits: 0u64,
            expire: MAX_U32
        };
    }
}
