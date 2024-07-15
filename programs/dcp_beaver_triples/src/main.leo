// The 'dcp_beaver_triples' program.
program dcp_beaver_triples.aleo {
    transition main(public a: u32, b: u32) -> u32 {
        let c: u32 = a + b;
        return c;
    }
}
