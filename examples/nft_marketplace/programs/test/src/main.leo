// The 'test' program.
import secret_custody_protocol.aleo;

program test.aleo {
    transition main(public a: u32, b: u32) -> u32 {
        let c: u32 = a + b;
        return c;
    }
}
