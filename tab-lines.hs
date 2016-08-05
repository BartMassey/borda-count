-- Copyright © 2013 Bart Massey
-- [This program is licensed under the "MIT License"]
-- Please see the file COPYING in the source
-- distribution of this software for license terms.

-- Tabulate votes using Borda Count (or thereabouts).

import Data.Array.IO
import qualified Data.ByteString.Char8 as B
import Data.List
import Data.Char
import Data.Ord
import System.IO
import Text.Printf

acc :: IOUArray Int Int -> [(Int, Char)] -> IO ()
acc _ [] = return ()
acc a ((_, '-') : vcs) = acc a vcs
acc a ((v, c) : vcs)  = do
  let i = ord c - ord 'a'
  v' <- readArray a i
  writeArray a i $! v + v'
  acc a vcs

countVotes :: IOUArray Int Int -> IO ()
countVotes a = do
  eof <- isEOF
  if eof then return () else do
    voteText <- B.getLine
    acc a $ zip [6,5..1] $ take 6 $ B.unpack voteText
    countVotes a

main :: IO ()
main = do
  -- Strategy: Get a line of votes; label each vote with its count; 
  -- accumulate votes.  Finally, sort the candidates in
  -- descending vote count order and print.
  a <- newListArray (0, 5) (repeat 0)
  countVotes a
  counts <- getElems a
  let votes = sortBy (comparing (Down . snd)) $
              zip ['a' ..] counts
  mapM_ (\(c, v) -> printf "%c: %d\n" c v) votes
