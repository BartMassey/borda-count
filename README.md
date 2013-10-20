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

* `tab-iterate.hs`: Score all the votes, then total up the
  score of each candidate in turn.

* `tab-map.hs`: Uses an accumulating map constructor to
  total up all the votes on the fly.

* `tab-transpose.hs`: Transposes the votes file to get
  each score rank together, then plays games with
  `replicate` to get everything counted.

* `tab-fast.hs`: Accumulates votes into a candidate vote
  totals list on the fly. Not terribly fast.

* `tab-faster.hs`: Accumulates votes into a candidate vote
  totals IOUArray on the fly. About twice as fast.

* `tab-text.hs`: Use `Data.Text` instead of `String`
  for some internal operations.

* `tab-py.hs`: Python version for comparison.

* `tab.c`: C version for comparison.

To build these programs, just type `make`.

The performance differences of these programs are pretty
noticeable. However, they all fail for large vote file
inputs. To see this, say `"sh doubler.sh"` and try the
various programs on large(-ish) files.
