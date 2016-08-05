-- Copyright © 2013 Bart Massey
-- [This program is licensed under the "MIT License"]
-- Please see the file COPYING in the source
-- distribution of this software for license terms.

-- Tabulate votes using Borda Count (or thereabouts).

import Data.Ord
import Data.List
import Text.Printf

main :: IO ()
main = do
  voteText <- getContents
  -- Strategy: transpose to get all the first-place votes,
  -- second-place votes, etc.; replicate each place the
  -- appropriate number of times; jam all the vote letters
  -- together; count the number of occurrences of
  -- each. Finally, sort the candidates in descending vote
  -- count order and print.
  let votes = sortBy (comparing (Down . snd)) $
              filter ((/= '-') . fst) $
              map (\l -> (head l, length l)) $ group $ sort $
              concat $ concat $ zipWith replicate [6,5..1] $
              transpose $ lines voteText
  mapM_ (\(c, v) -> printf "%c: %d\n" c v) votes
