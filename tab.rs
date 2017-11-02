// Tabulate Borda Count votes.

use std::io::prelude::*;
use std::io;

#[derive(Copy, Clone)]
struct Vote {
    candidate: char,
    tally: usize
}

fn main() {
    let mut votes = [Vote{candidate: '?', tally: 0}; 6];
    for i in 0..6 {
        votes[i].candidate = (i + ('a' as usize)) as u8 as char
    };
    let stdin = io::stdin();
    for maybe_line in stdin.lock().lines() {
        let line = maybe_line.expect("failed to read input line");
        assert!(line.len() == 6, "wrong input line size");
        let carray: Vec<char> = line.chars().collect();
        for i in 0..6 {
            let c = carray[i];
            if c == '-' {
                continue
            };
            assert!(c >= 'a' && c <= 'f', "bad vote char");
            votes[(c as usize - 'a' as usize)].tally += 6 - i
        }
    };
    votes.sort_unstable_by_key(|v| v.tally);
    for i in (0..6).rev() {
        println!("{}: {}", votes[i].candidate, votes[i].tally)
    }
}
