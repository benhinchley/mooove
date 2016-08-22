SOURCES := $(shell find . -name "*.go" ! -path "./vendor/*")

VERSION=v0.1.0
BUILD := $(shell git rev-parse --short HEAD)

all: dev

vendor: glide.yaml
	@glide install
	@touch $@

update:
	@glide update -u -s --delete

build: fmt $(SOURCES) vendor
	@M_RELEASE=1 M_VER=${VERSION} M_BUILD=${BUILD} sh -c "'$(CURDIR)/scripts/build.bash'"
	@touch $@

dev: fmt $(SOURCES) vendor
	@M_DEV=1 M_VER=${VERSION} M_BUILD=${BUILD} sh -c "'$(CURDIR)/scripts/build.bash'"
	@touch $@

fmt: $(SOURCES)
	@gofmt -w $(SOURCES)

clean:
	@if [ -f vendor ]; then rm -f vendor; fi
	@if [ -f dev ]; then rm -f dev; fi
	@if [ -f build ]; then rm -f dev; fi

.PHONY: update fmt clean
