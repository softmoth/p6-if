PERL6 ?= perl6
test:
	PERL6LIB=./lib prove -e $(PERL6) -v t
