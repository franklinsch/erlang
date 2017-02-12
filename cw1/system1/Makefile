### Franklin Schrans (fs2014)
# Based on Naranker Dulay's Makefile for Tutorial 2 (Distributed Algorithms)

.SUFFIXES: .erl .beam

MODULES  = system1 client  

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

SYSTEM    = system1

run1:	all
	$(L_ERL) -s $(SYSTEM) start 1000 1000

run2:	all
	$(L_ERL) -s $(SYSTEM) start 0 3000
