// Tabulate Borda Count votes.

use std::io;
use std::io::prelude::*;
use std::io::ErrorKind;

#[derive(Copy, Clone)]
struct Vote {
    candidate: char,
    tally: usize
}

fn main() {
    let mut votes = [Vote{candidate: '?', tally: 0}; 6];
    for i in 0..6 {
        votes[i].candidate = (i as u8 + b'a') as char
    };
    let stdin = io::stdin();
    let mut stdin = stdin.lock();
    let mut line = [0u8; 7];
    loop {
        match stdin.read_exact(&mut line) {
            Ok(()) => assert!(line[6] == b'\n'),
            Err(e) => match e.kind() {
                ErrorKind::UnexpectedEof => break,
                _ => panic!("read error")
            }
        };
        for (i, c) in line.iter().enumerate() {
            if *c == b'\n' || *c == b'-' {
                continue
            };
            assert!(*c >= b'a' && *c <= b'f', "bad vote char");
            votes[*c as usize - b'a' as usize].tally += 6 - i
        }
    };
    votes.sort_unstable_by_key(|v| v.tally);
    for i in (0..6).rev() {
        println!("{}: {}", votes[i].candidate, votes[i].tally)
    }
}
