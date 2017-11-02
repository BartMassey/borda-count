# Copyright © 2013 Bart Massey
# [This program is licensed under the "MIT License"]
# Please see the file COPYING in the source
# distribution of this software for license terms.

# Makefile for Borda Count Haskell demos

CC = gcc
CFLAGS = -Wall -O4 -march=native -std=c99
HC = ghc
HFLAGS = -Wall -O2
TARGETS = tab-iterate tab-map tab-transpose tab-fast tab-c tab-simple

PC = swipl
PFLAGS = -O2
TARGETS = tab-iterate tab-map tab-transpose tab-fast tab-faster \
          tab-text tab-c tab-bs tab-lines tab-vector tab-mvector \
	  tab-fastmap tab-rs
DOUBLER = votes2.txt votes3.txt votes4.txt votes5.txt votes6.txt \
          votes7.txt votes8.txt votes9.txt votes10.txt votes11.txt \
          votes12.txt votes13.txt votes14.txt votes15.txt votes16.txt \
          votes17.txt votes18.txt votes19.txt votes20.txt
TIME = /usr/bin/time -f '%e'

PROLOG = tab-prolog.o tab-transpose-prolog.o

all: $(TARGETS)

everything: $(TARGETS) $(PROLOG)

tab-iterate: tab-iterate.hs
	$(HC) $(HFLAGS) --make tab-iterate.hs

tab-map: tab-map.hs
	$(HC) $(HFLAGS) --make tab-map.hs

tab-transpose: tab-transpose.hs
	$(HC) $(HFLAGS) --make tab-transpose.hs

tab-fast: tab-fast.hs
	$(HC) $(HFLAGS) --make tab-fast.hs

tab-faster: tab-faster.hs
	$(HC) $(HFLAGS) --make tab-faster.hs

tab-text: tab-text.hs
	$(HC) $(HFLAGS) --make tab-text.hs

tab-bs: tab-bs.hs
	$(HC) $(HFLAGS) --make tab-bs.hs

tab-lines: tab-lines.hs
	$(HC) $(HFLAGS) --make tab-lines.hs

tab-vector: tab-vector.hs
	$(HC) $(HFLAGS) --make tab-vector.hs

tab-mvector: tab-mvector.hs
	$(HC) $(HFLAGS) --make tab-mvector.hs

tab-fastmap: tab-fastmap.hs
	$(HC) $(HFLAGS) --make tab-fastmap.hs

tab-simple: tab-simple.hs
	$(HC) $(HCFLAGS) --make tab-simple.hs

tab-c: tab.c
	$(CC) $(CFLAGS) -o tab-c tab.c

tab-rs: tab.rs
	rustc -C lto -C opt-level=3 -o tab-rs tab.rs

tab-prolog.o: tab.pro
	$(PC) $(PFLAGS) -q -t main -o tab-prolog.o -c tab.pro

tab-transpose-prolog.o: tab-transpose.pro
	$(PC) $(PFLAGS) -q -t main -o tab-transpose-prolog.o -c tab-transpose.pro

$(DOUBLER):
	sh ./doubler.sh

time: all $(DOUBLER)
	-@for p in $(TARGETS); do echo -n "$$p: "; \
          $(TIME) ./$$p <votes19.txt 2>&1 >/dev/null; done
	@echo -n "python: "
	-@$(TIME) python3 tab.py <votes19.txt 2>&1 >/dev/null

clean:
	-rm -f $(TARGETS) $(PROLOG) *.o *.hi votes[1-9]*.txt
