# Borda Count in Haskell
Copyright © 2013 Bart Massey  
*This work is made available under the MIT License: please
see the file COPYING for license details.*

These little demos are small Haskell programs that compute a
[Borda Count](http://en.wikipedia.org/wiki/Borda_count) on
the votes in the file `votes.txt`. Each line of that file
contains the vote for one voter, consisting of a
rank-ordering of the candidate identifier letters *a*
through *f* from best to worst.

The programs (in the order they were written) are:

* `tab-iterate.hs`: Scores all the votes, then totals up the
  score of each candidate in turn. May fail on large inputs.

* `tab-map.hs`: Uses an accumulating map constructor to
  total up all the votes on the fly. Fails on large inputs.

* `tab-transpose.hs`: Transposes the votes file to get
  each score rank together, then plays games with
  `replicate` to get everything counted. Fails
  on large inputs.

* `tab-fast.hs`: Accumulates votes into a candidate vote
  totals list on the fly. Not terribly fast.

* `tab-faster.hs`: Accumulates votes into a candidate vote
  totals IOUArray on the fly. About twice as fast.

* `tab-text.hs`: Use `Data.Text.Lazy` instead of `String`
  for some internal operations. Also, rewrites the structure
  a bit. About twice as fast as `tab-faster`.

* `tab-bs.hs`: Use `Data.ByteString.Lazy` instead of
  `String` for some internal operations. About three times
  as fast as `tab-text`.

* `tab.py`: Python version for comparison.

* `tab.c`: C version for comparison. About 5 times faster
  than `tab-bs`.

* `tab.pro`: Prolog version for comparison.  SWI Prolog
  (`swipl`) will be needed to build, so not included in the
  default build targets: build with `make everything`. Run
  with `swipl -x tab-prolog`. Very slow. Fails on large inputs.

* `tab-transpose.pro`: Prolog version for comparison.  This
  version uses explicit arguments rather than lists, so
  slightly faster that `tab.pro` but much more fragile.  SWI
  Prolog (`swipl`) will be needed to build, so not included
  in the default build targets: build with `make
  everything`. Run with `swipl -x
  tab-transpose-prolog`. Very slow. Fails on large inputs.

To build everything except the Prolog programs, just type
`make`.

The performance differences of these programs are pretty
noticeable. However, they all fail for large vote file
inputs. To see this, say `"sh doubler.sh"` and try the
various programs on large(-ish) files.
