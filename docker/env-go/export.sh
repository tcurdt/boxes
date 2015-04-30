#!/bin/sh
set -e

source `type -p gvp`

mkdir -p /app

# TODO gpm/gvp should install into another dir but /src/.godeps
# cd /src && gpm install

# go build \
#   -o bin/server \
#   src/..bla../server.go

# # package up the app
# cd /src && tar \
#   --exclude='.git' \
#   --transform 's,^\.,app,' \
#   -rvf /dst/root.tar .
