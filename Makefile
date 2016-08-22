SOURCES := $(shell find . -name "*.go" ! -path "./vendor/*")

BINARY=mooove
VERSION=v0.1.0
BUILD := $(shell git rev-parse --short HEAD)

LDFLAGS=-ldflags "-X main.Version=${VERSION} \
		-X main.Build=${BUILD}"

all: bin/$(BINARY) bin/$(BINARY)_darwin-amd64 bin/$(BINARY)_linux-amd64

vendor: glide.yaml
	@glide install
	@touch $@

update:
	@glide update -u -s --delete

bin/$(BINARY): $(SOURCES) vendor
	@go build ${LDFLAGS} -o $@ .

bin/$(BINARY)_darwin-amd64: $(SOURCES) vendor
	@GOOS=darwin GOARCH=amd64 go build ${LDFLAGS} -o $@ .

bin/$(BINARY)_linux-amd64: $(SOURCES) vendor
	@GOOS=linux GOARCH=amd64 go build ${LDFLAGS} -o $@ .

bin/$(BINARY)_windows-amd64.exe: $(SOURCES) vendor
	@GOOS=windows GOARCH=amd64 go build -o $@ .

clean:
	@if [ -f bin/$(BINARY) ]; then rm -f bin/$(BINARY); fi
	@if [ -f bin/$(BINARY)_darwin-amd64 ]; then rm -f bin/$(BINARY)_darwin-amd64; fi
	@if [ -f bin/$(BINARY)_linux-amd64 ]; then rm -f bin/$(BINARY)_linux-amd64; fi
	@if [ -f bin/$(BINARY)_windows-amd64.exe ]; then rm -f bin/$(BINARY)_windows-amd64.exe; fi
	@if [ -f vendor ]; then rm -f vendor; fi

.PHONY: update clean
