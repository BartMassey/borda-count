-- Copyright © 2013 Bart Massey
-- [This program is licensed under the "MIT License"]
-- Please see the file COPYING in the source
-- distribution of this software for license terms.

-- Tabulate votes using Borda Count (or thereabouts).

import Control.Monad
import Data.Array.IO
import Data.Ord
import Data.List
import Data.Char
import Text.Printf

-- Strategy: Split the accumulator
-- at the index position; add the vote;
-- glue the accumulator back together.
acc :: IOUArray Int Int -> (Char, Int) -> IO (IOUArray Int Int)
acc a ('-', _) = return a
acc a (c, v) = do
  let i = ord c - ord 'a'
  v' <- readArray a i
  writeArray a i $! v + v'
  return a

main :: IO ()
main = do
  voteText <- getContents
  -- Strategy: Label each vote with 
  -- its count; jam them together,
  -- use a foldl' to accumulate votes.
  -- Finally, sort the candidates in descending vote
  -- count order and print.
  a <- newListArray (0, 5) (repeat 0)
  a' <- foldM acc a $
        concatMap (flip zip [6,5..1]) $
        lines voteText
  counts <- getElems a'
  let votes = sortBy (comparing (Down . snd)) $
              zip ['a' ..] counts
  mapM_ (\(c, v) -> printf "%c: %d\n" c v) votes
