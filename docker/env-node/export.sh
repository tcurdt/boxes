#!/bin/sh
set -e

# install dependencies into /app/node_modules
mkdir -p /app
cp /src/package.json /app
cd /app && npm install --production

# package up node
cd / && tar \
  --exclude='usr/local/nodejs/lib/node_modules/npm/html' \
  --exclude='usr/local/nodejs/lib/node_modules/npm/man' \
  --exclude='usr/local/nodejs/include' \
  -cvf /dst/root.tar usr/local/nodejs

# package up the app
cd /src && tar \
  --exclude='.git' \
  --exclude='node_modules' \
  --transform 's,^\.,app,' \
  -rvf /dst/root.tar .
