-- Copyright © 2013 Bart Massey
-- [This program is licensed under the "MIT License"]
-- Please see the file COPYING in the source
-- distribution of this software for license terms.

-- Tabulate votes using Borda Count (or thereabouts).

import Data.Ord
import Data.List (sortBy)
import Text.Printf
import qualified Data.Map as M

main :: IO ()
main = do
  voteText <- getContents
  -- Strategy: Label each vote with its score; make an
  -- accumulating map to count scores by candidate; turn the
  -- map back into a list.. Finally, sort the candidates in
  -- descending vote count order and print.
  let votes = sortBy (comparing (Down . snd)) $
              filter ((/= '-') . fst) $
              M.toList $ M.fromListWith (+) $
              concatMap (flip zip [6 :: Int, 5 .. 1]) $ 
              lines voteText
  mapM_ (\(c, v) -> printf "%c: %d\n" c v) votes
