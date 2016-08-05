-- Copyright © 2016 Bart Massey
-- [This program is licensed under the "MIT License"]
-- Please see the file COPYING in the source
-- distribution of this software for license terms.

-- Tabulate votes using Borda Count (or thereabouts).

import Data.Char
import Data.List (sort, sortBy, foldl')
import Data.Ord
import Data.Set (toList, fromList, (\\))
import Text.Printf

-- Strategy: Attach the proper score to each candidate in
-- the incoming line. Sort the line in candidate order.
-- Add the new scores to the incoming totals.
scoreLine :: [Int] -> [Char] -> [Int]
scoreLine totals vote =
    let listed = filter (/= '-') vote in
    let missing = toList (fromList ['a'..'f'] \\ fromList listed) in
    let listedScores = zip listed [6,5..1]
        unlistedScores = zip missing (repeat 0) in
    let scores =  listedScores ++ unlistedScores in
    zipWith (+) totals $ map snd $ sort scores

main :: IO ()
main = do
  voteText <- getContents
  -- Strategy: for each line, produce the
  -- candidate scores in candidate order
  -- and add it to the running total.
  let votes = foldl' scoreLine (replicate 6 0) $ lines voteText
  let results = sortBy (comparing (Down . snd)) $ zip ['a' .. 'f'] votes
  mapM_ showVotes results
  where
    showVotes (candidate, total) =
        printf "%c: %d\n" candidate total
