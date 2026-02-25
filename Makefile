############################################################################
# You can define your own path to ROCQBIN by creating a file called
# "settings.sh" and placing the right definitions into it, e.g.
#    ROCQBIN=/var/tmp/charguer/v8.4/bin/
#
# Note that ROCQBIN should have a leading slash.
# Note that if you add a settings.sh file, you need to do "make clean" first.

# Default paths for ROCQBIN, etc are as follows:

ROCQBIN=

# Use bash as the default shell
SHELL=/bin/bash


#######################################################

ROCQINCLUDES=-R rocq JsCert
ROCQC=$(ROCQBIN)rocq compile
ROCQDEP=$(ROCQBIN)rocq dep
ROCQFLAGS=

OCAMLBUILD=ocamlbuild
OCAMLBUILDFLAGS=-cflags "-w -20"

#######################################################
# MAIN SOURCE FILES

JS_SRC=\
	rocq/JsNumber.v \
	rocq/JsSyntax.v \


#######################################################
# MAIN TARGETS

all: rocq

.PHONY: all

#######################################################
# Rocq Compilation Implicit Rules
%.v.d: %.v
	$(ROCQDEP) $(ROCQINCLUDES) $< > $@

# If this rule fails for some reason, try `make clean_all && make`
%.vo: %.v
	$(ROCQC) $(ROCQFLAGS) $(ROCQINCLUDES) $<

#######################################################
# JsAst Specific Rules
.PHONY: rocq proof

rocq: Makefile.rocq
	@$(MAKE) -f Makefile.rocq

install: Makefile.rocq
	@$(MAKE) -f Makefile.rocq install

#######################################################
# CLEAN
.PHONY: clean

clean:
	-rm -f rocq/*.{vo,glob,d}

cleanall:
	@$(MAKE) clean
	-rm -f Makefile.rocq Makefile.rocq.conf .Makefile.rocq.d .rocqdeps.d

##
Makefile.rocq: Makefile $(JS_SRC)
	@rocq makefile -f _RocqProject $(JS_SRC) -o Makefile.rocq

