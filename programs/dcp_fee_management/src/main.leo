import credits.aleo;


program dcp_fee_management.aleo {
    record Fee {
        owner: address,
        microcredits: u64
    }
    
    transition mint_fee(
        public receiver: address, amount: u64
    ) -> Fee {
        assert_eq(self.caller, dcp_core_protocol.aleo);
        return Fee{
            owner: receiver,
            microcredits: amount,
        };
    }

    async transition burn_fee(
        private fee: Fee,
    ) -> Future {
        let unlock_fee_future: Future = credits.aleo/transfer_public(
            fee.owner,
            fee.microcredits,
        );
        return finalize_burn_fee(unlock_fee_future);
    }
    async function finalize_burn_fee(unlock_fee_future: Future){
        unlock_fee_future.await();
    }


    transition join_fee(
        private fee_0: Fee,
        private fee_1: Fee,
    ) -> Fee {
        return Fee{
            owner: fee_0.owner,
            microcredits: fee_0.microcredits + fee_1.microcredits,
        };
    }

    /*
    async transition burn_2_fee(
        private fee_0: Fee,
        private fee_1: Fee,
    ) -> Future {
        let amount: u64 = (
            fee_0.microcredits 
            + fee_1.microcredits
        );
        let unlock_fee_future: Future = credits.aleo/transfer_public(
            fee_0.owner,
            amount,
        );
        return finalize_burn_fee(unlock_fee_future);
    }

    async transition burn_3_fee(
        private fee_0: Fee,
        private fee_1: Fee,
        private fee_2: Fee,
    ) -> Future {
        let amount: u64 = (
            fee_0.microcredits 
            + fee_1.microcredits
            + fee_2.microcredits
        );
        let unlock_fee_future: Future = credits.aleo/transfer_public(
            fee_0.owner,
            amount,
        );
        return finalize_burn_fee(unlock_fee_future);
    }


    async transition burn_16_fee(
        private fee_0: Fee,
        private fee_1: Fee,
        private fee_2: Fee,
        private fee_3: Fee,
        private fee_4: Fee,
        private fee_5: Fee,
        private fee_6: Fee,
        private fee_7: Fee,
        private fee_8: Fee,
        private fee_9: Fee,
        private fee_10: Fee,
        private fee_11: Fee,
        private fee_12: Fee,
        private fee_13: Fee,
        private fee_14: Fee,
        private fee_15: Fee,
    ) -> Future {
        let amount: u64 = (
            fee_0.microcredits 
            + fee_1.microcredits
            + fee_2.microcredits
            + fee_3.microcredits
            + fee_4.microcredits
            + fee_5.microcredits
            + fee_6.microcredits
            + fee_7.microcredits
            + fee_8.microcredits
            + fee_9.microcredits
            + fee_10.microcredits
            + fee_11.microcredits
            + fee_12.microcredits
            + fee_13.microcredits
            + fee_14.microcredits
            + fee_15.microcredits
        );
        credits.aleo/transfer_public(
            fee_0.owner,
            amount,
        );
    }
    */
}
