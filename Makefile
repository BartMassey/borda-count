# Copyright © 2013 Bart Massey
# [This program is licensed under the "MIT License"]
# Please see the file COPYING in the source
# distribution of this software for license terms.

# Makefile for Borda Count Haskell demos

CC = gcc
CFLAGS = -Wall -O2 -std=c99
HC = ghc
HFLAGS = -Wall -O2
TARGETS = tab-iterate tab-map tab-transpose tab-fast tab-faster \
          tab-text tab-c

all: $(TARGETS)

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

tab-c: tab.c
	$(CC) $(CFLAGS) -o tab-c tab.c

clean:
	-rm -f $(TARGETS) *.o *.hi
