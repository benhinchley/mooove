SOURCES := $(shell find . -name "*.go" ! -path "./vendor/*")

BINARY=mooove
VERSION=v0.1.0

LDFLAGS=-ldflags "-X main.Version=${VERSION}"

all: bin/$(BINARY) bin/$(BINARY)_darwin-amd64 bin/$(BINARY)_linux-amd64

vendor: glide.yaml
	@glide install
	@touch $@

update:
	@glide update -u -s

bin/$(BINARY): $(SOURCES) vendor
	@go build ${LDFLAGS} -o $@ .

bin/$(BINARY)_darwin-amd64: $(SOURCES) vendor
	@GOOS=darwin GOARCH=amd64 go build ${LDFLAGS} -o $@ .

bin/$(BINARY)_linux-amd64: $(SOURCES) vendor
	@GOOS=linux GOARCH=amd64 go build ${LDFLAGS} -o $@ .

clean:
	@if [ -f bin/$(BINARY) ]; then rm -f bin/$(BINARY); fi
	@if [ -f bin/$(BINARY)_darwin-amd64 ]; then rm -f bin/$(BINARY)_darwin-amd64; fi
	@if [ -f bin/$(BINARY)_linux-amd64 ]; then rm -f bin/$(BINARY)_linux-amd64; fi
	@if [ -f vendor ]; then rm -f vendor; fi

.PHONY: update clean
