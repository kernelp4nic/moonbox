-include ./config.make

all:
	-@echo Nothing to do

install:
	install -d $(prefix)/bin
	install -m 0755 ./bin/moonbox $(prefix)/bin

uninstall:
	rm -rf $(prefix)/bin/moonbox

test:
	bats test/test_suite.bats

.PHONY: test
