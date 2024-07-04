
use snarkvm_console_account::ViewKey;
use snarkvm_console_network::{Testnet3};
// use snarkvm_console_network::{TestnetV0, GENERATOR_G, MainnetV0, Network};
use snarkvm_console_types_scalar::*;


fn main() {
    let cmd_line = std::env::args();
    let mut input_str = String::from(""); 
    for arg in cmd_line {
        input_str = arg;
    }
    let input_scalar: Result<Scalar<Testnet3>> = Scalar::from_str(&input_str);
    let view_key: ViewKey::<Testnet3> = ViewKey::<Testnet3>::from_scalar(
        input_scalar.expect("Error parsing scalar.")
    );
    println!("{}", view_key);

    // TO DETERMINE ADDRESS GENERATOR ELEMENT:
    // let t: Scalar<MainnetV0> = Scalar::from_str("1scalar").expect("Error parsing scalar.");
    // println!("{:?}", Network::g_scalar_multiply(&t));
    //  => IN LEO:
    // const address_gen: group = 522678458525321116977504528531602186870683848189190546523208313015552693483group;
    // inline viewkey_to_address(view_key: scalar) -> address {
    //     return (view_key * address_gen) as address;
    // }
}
