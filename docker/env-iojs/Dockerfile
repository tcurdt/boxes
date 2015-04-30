FROM tcurdt/debian

ENV IOJS_VERSION 1.8.1

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
  9554F04D7259F04124DE6B476D5A82AC7E37093B \
  DD8F2338BAE7501E3DD5AC78C273792F7D83545D

RUN DEBIAN_FRONTEND=noninteractive apt-get -y update \
  && apt-get install -y --no-install-recommends \
    curl ca-certificates \
  && curl -SLO "https://iojs.org/dist/v$IOJS_VERSION/iojs-v$IOJS_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://iojs.org/dist/v$IOJS_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " iojs-v$IOJS_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "iojs-v$IOJS_VERSION-linux-x64.tar.gz" -C /usr/local \
  && mv /usr/local/iojs-v$IOJS_VERSION-linux-x64 /usr/local/iojs \
  && rm "iojs-v$IOJS_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
  && apt-get purge -y --auto-remove \
    curl ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && mkdir -p /builder

ADD export.sh /usr/bin/export.sh

ENV PATH /usr/local/iojs/bin:$PATH

WORKDIR /src
VOLUME [ "/src", "/dst" ]
CMD [ "/bin/bash" ]
