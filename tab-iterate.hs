-- Copyright © 2013 Bart Massey
-- [This program is licensed under the "MIT License"]
-- Please see the file COPYING in the source
-- distribution of this software for license terms.

-- Tabulate votes using Borda Count (or thereabouts).

import Data.Ord
import Data.List
import Text.Printf

-- Strategy: Filter out all the votes for the selected
countVotes :: [(Int, Char)] -> Char -> (Char, Int)
countVotes votes selector =
    let count = sum $ map fst $ filter ((== selector) . snd) votes in
    (selector, count)

main :: IO ()
main = do
  voteText <- getContents
  -- Strategy: attach the score to each vote; jam all the
  -- votes together; for each candidate, call countVotes to
  -- count the votes for that candidate, display in
  -- descending order.
  let votes = concatMap (zip [6, 5 .. 1]) $ 
              lines voteText
  let totals = map (countVotes votes) ['a' .. 'f']
  let results = sortBy (comparing (Down . snd)) totals
  mapM_ (\(c, v) -> printf "%c: %d\n" c v) results

