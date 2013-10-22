-- Copyright © 2013 Bart Massey
-- [This program is licensed under the "MIT License"]
-- Please see the file COPYING in the source
-- distribution of this software for license terms.

-- Tabulate votes using Borda Count (or thereabouts).

import Text.Printf

-- Strategy: Filter out all the votes for the selected
-- candidate; add them up; print the total.
showVotes :: [(Int, Char)] -> Char -> IO ()
showVotes votes selector = do
  let count = sum $! map fst $! filter ((== selector) . snd) votes
  printf "%c: %d\n" selector count

main :: IO ()
main = do
  voteText <- getContents
  -- Strategy: attach the score to each vote; jam all the
  -- votes together; for each candidate, call showVotes to
  -- count and display the votes for that candidate.
  let votes = concatMap (zip [6, 5 .. 1]) $ 
              lines voteText
  mapM_ (showVotes votes) ['a' .. 'f']
