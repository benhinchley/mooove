#!/usr/bin/env bash
#
# build script for mooove

#set -eo pipefail

# get the parent directory of where this script is.
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )/.." && pwd )"

# change into that directory
cd "$DIR" || exit

# make sure version is provided
if [ ! "${M_VER}" ]; then
  echo "version not provided"
  return
fi

# make sure build has is provided
if [ ! "${M_BUILD}" ]; then
  echo "build hash no provided"
  return
fi

# set os and arch
XC_ARCH=${XC_ARCH:-"amd64"}
XC_OS=${XC_OS:-"linux darwin windows"}

# clean up from previous build
echo "cleaning out the garden"
if [ -d bin ]; then rm -f bin/*; fi
if [ -d pkg ]; then rm -rf pkg/*; fi
if [ ! -d bin/ ]; then mkdir -p bin; fi

# only build for your arch if in dev mode
if [[ -n "${M_DEV}" ]]; then
  echo "this is getting run?"
  XC_OS=$(go env GOOS)
  XC_ARCH=$(go env GOARCH)
fi

# check that we have gox installed
if ! which gox > /dev/null; then
  echo "installing gox"
  go get -u github/mitchellh/gox
fi

export CGO_ENABLED=0

LDFLAGS="-X main.Version=${M_VER} -X main.Build=${M_BUILD}"
if [[ -n "${M_RELEASE}" ]]; then
  LDFLAGS="${LDFLAGS} -s -w"
fi

# build
echo "building :hammer::package:"
gox \
  -os="${XC_OS}" \
  -arch="${XC_ARCH}" \
  -ldflags="${LDFLAGS}" \
  -output="pkg/{{.OS}}_{{.Arch}}/mooove" \
  .
