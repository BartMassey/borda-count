-- Copyright © 2013 Bart Massey
-- [This program is licensed under the "MIT License"]
-- Please see the file COPYING in the source
-- distribution of this software for license terms.

-- Tabulate votes using Borda Count (or thereabouts).

import qualified Data.ByteString.Lazy.Char8 as B
import Data.List
import Data.Char
import Data.Ord
import Data.Vector.Unboxed (freeze, toList)
import Data.Vector.Unboxed.Mutable as V (IOVector, read, write, replicate)
import Text.Printf

acc :: IOVector Int -> [(Int, Char)] -> IO ()
acc _ [] = return ()
acc a ((_, '-') : vcs) = acc a vcs
acc a ((v, c) : vcs)  = do
  let i = ord c - ord 'a'
  v' <- V.read a i
  write a i $! v + v'
  acc a vcs

main :: IO ()
main = do
  voteText <- B.getContents
  -- Strategy: Label each vote with its count; use a fold to
  -- accumulate votes.  Finally, sort the candidates in
  -- descending vote count order and print.
  a <- V.replicate 6 0
  mapM_ (acc a) $
    map (zip [6,5..1] . B.unpack . B.take 6) $ B.lines voteText
  a' <- freeze a
  let votes = sortBy (comparing (Down . snd)) $
              zip ['a' ..] $ toList a'
  mapM_ (\(c, v) -> printf "%c: %d\n" c v) votes
