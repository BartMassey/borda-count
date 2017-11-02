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

The programs (in the order they were written) are as
follows. The slowdowns given are relative to tab.c running
votes19.txt on a modern PC.

* `tab-transpose.hs`: Transposes the votes file to get each
  score rank together, then plays games with `replicate` to
  get everything counted. Fails on large inputs. Runs very
  slowly in any case. Uggh.

* `tab-iterate.hs`: Scores all the votes, then totals up the
  score of each candidate in turn. Slowdown 51x.

* `tab-fast.hs`: Accumulates votes into a candidate vote
  totals list on the fly. Slowdown 33x.

* `tab-map.hs`: Uses an accumulating map constructor to
  total up all the votes on the fly. Slowdown 22x.

* `tab-faster.hs`: Accumulates votes into a candidate vote
  totals IOUArray on the fly. Slowdown 13x.

* `tab-text.hs`: Use `Data.Text.Lazy` instead of `String`
  for some internal operations. Also, rewrites the structure
  a bit. Slowdown 13x.

* `tab-fastmap.hs`: A pure variant of `tab-bs` that uses a
  map from vote patterns to score lists to score. Slowdown
  16x.

* `tab-lines.hs`: Reads and processes votes a line at a
  time. Uses `Data.ByteString.Char8` for reading as it seems
  to be substantially faster (?). Slowdown 11x.

* `tab-vector.hs`: Uses `Data.ByteString.Lazy.Char8` for
  reading as `tab-bs` does, but uses `Data.Vector.Unboxed`
  for storage (thus getting rid of `Data.Array.IO` for
  cleanliness). Slowdown 6x.

* `tab-bs.hs`: Use `Data.ByteString.Lazy.Char8` instead of
  `String` for some internal operations. About three times
  as fast as `tab-text`. Slowdown 5x.

* `tab-mvector.hs`: As `tab-vector`, but uses
  `Data.Vector.Mutable.Unboxed` for storage. Slowdown 5x.

* `tab.py`: Python version for comparison. Slowdown 57x.

* `tab.c`: C version for comparison.

* `tab.rs`: Highly-optimized Rust version for
  comparison. Speedup 2x.

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
`make`. To build everything including the Prolog programs,
use `make everything`. To run timing tests, say `make time`.

The performance differences of these programs are pretty
noticeable. However, many fail for large vote file
inputs. To see this, say `"sh doubler.sh"` and try the
various programs on large(-ish) files.
