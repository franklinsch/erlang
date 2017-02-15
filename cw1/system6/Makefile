### Franklin Schrans (fs2014)
# Based on Naranker Dulay's Makefile for Tutorial 2 (Distributed Algorithms)

.SUFFIXES: .erl .beam

MODULES  = system6 process lossyp2plinks app beb reliable_broadcast

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

SYSTEM    = system6

run1:	all
	$(L_ERL) -s $(SYSTEM) start 100 1000 100

run2:	all
	$(L_ERL) -s $(SYSTEM) start 100 1000 50

run3:	all
	$(L_ERL) -s $(SYSTEM) start 100 1000 0

run4:	all
	$(L_ERL) -s $(SYSTEM) start 0 1000 100

run5:	all
	$(L_ERL) -s $(SYSTEM) start 0 1000 50

run6:	all
	$(L_ERL) -s $(SYSTEM) start 0 1000 0
	
run7:	all
	$(L_ERL) -s $(SYSTEM) start 1000 1 100

run8:	all
	$(L_ERL) -s $(SYSTEM) start 1000 5000 50

run9:	all
	$(L_ERL) -s $(SYSTEM) start 1000 5000 80
