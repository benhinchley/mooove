SOURCES := $(shell find . -name "*.go" ! -path "./vendor/*")

BINARY=mooove

all: bin/$(BINARY)

vendor: glide.yaml
	@glide install
	@touch $@

bin/$(BINARY): $(SOURCES) vendor
	@go build -o $@ .

clean:
	@if [ -f bin/$(BINARY) ]; then rm -f bin/$(BINARY); fi
	@if [ -f vendor ]; then rm -f vendor; fi

.PHONY: clean
