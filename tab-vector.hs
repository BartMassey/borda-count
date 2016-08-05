-- Copyright © 2013 Bart Massey
-- [This program is licensed under the "MIT License"]
-- Please see the file COPYING in the source
-- distribution of this software for license terms.

-- Tabulate votes using Borda Count (or thereabouts).

import Data.Vector.Unboxed as V (replicate, accum, toList)
import Data.List
import Data.Char
import Data.Ord
import qualified Data.ByteString.Lazy.Char8 as B
import Text.Printf

votify :: (Int, Char) -> [(Int, Int)] -> [(Int, Int)]
votify (_, '-') vs = vs
votify (v, c) vs = (ord c - ord 'a', v) : vs

main :: IO ()
main = do
  voteText <- B.getContents
  -- Strategy: Label each vote with its count; use a fold to
  -- accumulate votes.  Finally, sort the candidates in
  -- descending vote count order and print.
  let a' = foldl' (accum (+)) (V.replicate 6 0) $
           map (foldr votify [] . zip [6,5..1] . B.unpack . B.take 6) $
           B.lines voteText
  let votes = sortBy (comparing (Down . snd)) $
              zip ['a' ..] $ 
              toList a'
  mapM_ (\(c, v) -> printf "%c: %d\n" c v) votes
