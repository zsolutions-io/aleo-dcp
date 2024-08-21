use snarkvm_console_network::{Testnet3};
use snarkvm_console_types_scalar::*;
use snarkvm_console_types_group::*;

fn main() {
    let mut args = std::env::args();
    
    // Expect exactly 4 command line arguments: search_min, search_max, num_threads, and the group to search for
    args.next().expect("Must provide arguments");
    let group_str = args.next().expect("Expected a value for group to decode");

    // Parse the first argument into integers with default values
    let min_arg: Option<String> = args.next();
    let max_arg: Option<String> = args.next();
    let threads_arg: Option<String> = args.next();

    let group_gen: Group<Testnet3> = Group::from_str("1540945439182663264862696551825005342995406165131907382295858612069623286213group").expect("Error parsing group.");

    let search_min: i128 = match min_arg {
        Some(min_str) => min_str.parse::<i128>().expect("Failed to parse search minimum as an integer"),
        None => -10_000_000,
    };
    let search_max: i128 = match max_arg {
        Some(max_str) => max_str.parse::<i128>().expect("Failed to parse search maximum as an integer"),
        None => 10_000_000,
    };
    let num_threads_usize: usize = match threads_arg {
        Some(threads_str) => threads_str.parse().expect("Failed to parse threads amount as an integer"),
        None => std::thread::available_parallelism().unwrap().into(),
    };
    let num_threads: i128 = num_threads_usize.try_into().unwrap();
    
    let input_group: Group<Testnet3> = Group::from_str(&group_str).expect("Error parsing input group.");

    let chunk_size = (search_max - search_min + 1) / num_threads;
    let mut handles: Vec<std::thread::JoinHandle<_>> = vec![];

    for i in 0..num_threads {
        let start_idx = search_min + i * chunk_size;
        let end_idx = std::cmp::min(search_max, start_idx + chunk_size - 1);

        let handle = std::thread::spawn(move || {
            let mut min_str = String::new();
            min_str.push_str(&start_idx.to_string());
            min_str.push_str("scalar");
            let min_scalar: Scalar<Testnet3> = Scalar::from_str(&min_str).expect("Error parsing scalar.");

            let mut cur: Group<Testnet3> = min_scalar * group_gen;

            for j in start_idx..=end_idx {
                if input_group == cur {
                    let mut found_str = String::new();
                    found_str.push_str(&j.to_string());
                    found_str.push_str("scalar");
                    let found_scalar: Scalar<Testnet3> = Scalar::from_str(&found_str).expect("Error parsing scalar.");
                    println!("{:?}", found_scalar);
                    return;
                }
                cur += group_gen;
            }
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }
}
