SOURCES := $(shell find . -name "*.go" ! -path "./vendor/*")

BINARY=mooove

all: bin/$(BINARY)

vendor: glide.yaml
	@glide install

bin/$(BINARY): $(SOURCES) vendor
	@go build -o $@ .

clean:
	@if [ -f bin$(BINARY) ]; rm -f bin/$(BINARY); fi

.PHONY: clean
