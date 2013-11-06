-- Copyright © 2013 Bart Massey
-- [This program is licensed under the "MIT License"]
-- Please see the file COPYING in the source
-- distribution of this software for license terms.

-- Tabulate votes using Borda Count (or thereabouts).

import Data.List
import Data.Char
import qualified Data.Map as M
import Data.Ord
import qualified Data.ByteString.Lazy.Char8 as B
import Text.Printf

candidates :: String
candidates = ['a'..'f']

nCandidates :: Integral a => a
nCandidates = fromIntegral $ length candidates

choices :: Int -> [a] -> [[a]]
choices 0 _ = [[]]
choices _ [] = []
choices n xs | n > length xs = []
choices n (x : xs) =
  map (x :) (choices (n - 1) xs) ++ choices n xs

tallyMap :: M.Map B.ByteString [Int]
tallyMap = 
  M.fromList $ map scoreify $ makeperms
  where
    scoreify s = (pad s, score s)
      where
        pad s' = B.pack $ dash s'
          where
            dash s'' = s'' ++ replicate (nCandidates - length s'') '-'
        score s' = map snd $ sort $ fixup $ 
                    zip s' [nCandidates - 2, nCandidates - 1..0] 
          where
            fixup s'' = s'' ++ zip (candidates \\ map fst s'') [0..]
    makeperms = concatMap obliterate [0..nCandidates - 1]
      where
        obliterate n = concatMap permutations $ 
                        choices (nCandidates - n) candidates

main :: IO ()
main = do
  voteText <- B.getContents
  -- Strategy: Label each vote with its count; use a fold to
  -- accumulate votes.  Finally, sort the candidates in
  -- descending vote count order and print.
  let counts = 
        foldl' tally (replicate nCandidates 0) $ B.lines voteText
        where
          tally cur pat =
            let Just incs = M.lookup (B.take nCandidates pat) tallyMap in
            zipWith (+) cur incs
  let votes = sortBy (comparing (Down . snd)) $
              zip ['a' ..] counts
  mapM_ (\(c, v) -> printf "%c: %d\n" c v) votes
