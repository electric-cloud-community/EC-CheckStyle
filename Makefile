# Makefile

SRCTOP=..
include $(SRCTOP)/build/vars.mak

PLUGIN_PATCH_LEVEL=2.0.5

build: package
unittest:
systemtest: test-setup test-run
checkstyletest:
	$(MAKE) NTESTFILES="systemtest/checkStyle.ntest" RUNCHECKSTYLETESTS=1 test-setup test-run

NTESTFILES ?= systemtest

test-setup:
	$(EC_PERL) ../EC-CheckStyle/systemtest/setup.pl $(TEST_SERVER) $(PLUGINS_ARTIFACTS)

test-run: systemtest-run

include $(SRCTOP)/build/rules.mak
