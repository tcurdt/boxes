#!/bin/sh
set -e

# install dependencies into /app/node_modules
mkdir -p /app
cp /src/package.json /app
cd /app && npm install --production

# package up iojs
cd / && tar \
  --exclude='usr/local/iojs/lib/node_modules/npm/html' \
  --exclude='usr/local/iojs/lib/node_modules/npm/man' \
  --exclude='usr/local/iojs/include' \
  -cvf /dst/root.tar usr/local/iojs

# package up the app
cd /src && tar \
  --exclude='.git' \
  --exclude='node_modules' \
  --transform 's,^\.,app,' \
  -rvf /dst/root.tar .
