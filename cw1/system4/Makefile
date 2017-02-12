### Franklin Schrans (fs2014)
# Based on Naranker Dulay's Makefile for Tutorial 2 (Distributed Algorithms)

.SUFFIXES: .erl .beam

MODULES  = system4 process pl app beb

# BUILD =======================================================

ERLC	= erlc -o ebin

L_ERL     = erl -noshell -pa ebin -setcookie pass

ebin/%.beam: %.erl
	$(ERLC) $<

all:	ebin ${MODULES:%=ebin/%.beam} 

ebin:	
	mkdir ebin

debug:
	erl -s crashdump_viewer start 

.PHONY: clean
clean:
	rm -f ebin/* erl_crash.dump

SYSTEM    = system4

run:	all
	$(L_ERL) -s $(SYSTEM) start
