
# distributed algorithms, n.dulay, 4 jan 17
# simple build and run makefile, v1

.SUFFIXES: .erl .beam

MODULES  = system1 system2 system3 system4 system5 peer1 peer3 peer4 peer5
HOSTS    = 3
HOSTSm1  = 2

# BUILD =======================================================

ERLC	= erlc -o ebin

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

# LOCAL RUN ===================================================

SYSTEM    = system1
L_SYSTEM  = system2

L_HOST    = localhost.localdomain
L_ERL     = erl -noshell -pa ebin -setcookie pass
L_ERLNODE = node

run1:	all
	$(L_ERL) -s $(SYSTEM) start

run2:	all
	$(L_ERL) -s system2 start

run3:	all
	$(L_ERL) -s system3 start

run4:	all
	$(L_ERL) -s system4 start

run5:	all
	$(L_ERL) -s system5 start

# to run manually, run make node1 and make node2 in separate windows
# then make man2, remove manually
node1:	all
	$(L_ERL) -name $(L_ERLNODE)1@$(L_HOST)

node2:	all
	$(L_ERL) -name $(L_ERLNODE)2@$(L_HOST)

man2:	all
	$(L_ERL) -name $(L_ERLNODE)3@$(L_HOST) -s $(L_SYSTEM) start 
