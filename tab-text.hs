-- Copyright © 2013 Bart Massey
-- [This program is licensed under the "MIT License"]
-- Please see the file COPYING in the source
-- distribution of this software for license terms.

-- Tabulate votes using Borda Count (or thereabouts).

import Data.Array.IO
import Data.List
import Data.Char
import Data.Ord
import Data.Text.Lazy.IO as TIO
import qualified Data.Text.Lazy as T
import Text.Printf

acc :: IOUArray Int Int -> [(Int, Char)] -> IO ()
acc _ [] = return ()
acc a ((_, '-') : vcs) = acc a vcs
acc a ((v, c) : vcs)  = do
  let i = ord c - ord 'a'
  v' <- readArray a i
  writeArray a i $! v + v'
  acc a vcs

main :: IO ()
main = do
  voteText <- TIO.getContents
  -- Strategy: Label each vote with its count; use a fold to
  -- accumulate votes.  Finally, sort the candidates in
  -- descending vote count order and print.
  a <- newListArray (0, 5) (repeat 0)
  mapM_ (acc a) $
    map (zip [6,5..1] . T.unpack . T.take 6) $ T.lines voteText
  counts <- getElems a
  let votes = sortBy (comparing (Down . snd)) $
              zip ['a' ..] counts
  mapM_ (\(c, v) -> printf "%c: %d\n" c v) votes
