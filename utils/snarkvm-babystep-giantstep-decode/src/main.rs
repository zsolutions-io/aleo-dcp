// one per thread
use snarkvm_console_network::Testnet3;
use snarkvm_console_types_scalar::*;
use snarkvm_console_types_group::*;
use hashbrown::HashMap;
use std::thread;

fn main() {
    let mut args = std::env::args();
    
    // Expect exactly 4 command line arguments: search_min, search_max, num_threads, and the group to search for
    args.next().expect("Must provide arguments");
    let group_str = args.next().expect("Expected a value for group to decode");

    // Parse the first argument into integers with default values
    let m_arg: Option<String> = args.next();
    let threads_arg: Option<String> = args.next();

    let group_gen: Group<Testnet3> = Group::generator();
    let m: u128 = match m_arg {
        Some(m_arg) => m_arg.parse::<u128>().expect("Failed to parse m as an integer"),
        None => 10_000_000,
    };
    let mut minus_m_str = String::new();
    minus_m_str.push_str("-");
    minus_m_str.push_str(&m.to_string());
    minus_m_str.push_str("scalar");
    let minus_m_scalar: Scalar<Testnet3> = Scalar::from_str(&minus_m_str).expect("Error parsing scalar.");

    let num_threads_usize: usize = match threads_arg {
        Some(threads_str) => threads_str.parse().expect("Failed to parse threads amount as an integer"),
        None => std::thread::available_parallelism().unwrap().into(),
    };
    let num_threads: u128 = num_threads_usize.try_into().unwrap();
    
    let input_group: Group<Testnet3> = Group::from_str(&group_str).expect("Error parsing input group.");

    let chunk_size = (m + 1) / num_threads;

    let mut handles: Vec<std::thread::JoinHandle<_>> = vec![];

    for i in 0..num_threads {
        let start_idx = i * chunk_size;
        let end_idx = if i == num_threads - 1 { m } else { start_idx + chunk_size };

        let group_gen = group_gen.clone();

        let handle = thread::spawn(move || {
            let mut precomp = HashMap::new();

            let mut min_str = String::new();
            min_str.push_str(&start_idx.to_string());
            min_str.push_str("scalar");
            let min_scalar: Scalar<Testnet3> = Scalar::from_str(&min_str).expect("Error parsing scalar.");

            let mut cur: Group<Testnet3> = min_scalar * group_gen;
            
            for j in start_idx..=end_idx {
                precomp.insert(cur, j);  // Insert into the local HashMap
                cur += group_gen;
            }

            let mut gamma = input_group.clone();
            let invgenerator = minus_m_scalar * group_gen;
            for i in 0..m { // giant_steps
                if let Some(j) = precomp.get(&gamma) {
                    let res = i * m + j;
                    println!("{}scalar", res);
                }
                gamma = gamma + invgenerator;
            }
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }
}
