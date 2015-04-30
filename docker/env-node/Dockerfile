FROM tcurdt/debian

ENV NODEJS_VERSION 0.12.2

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
  114F43EE0176B71C7BC219DD50A3051F888C628D


RUN DEBIAN_FRONTEND=noninteractive apt-get -y update \
  && apt-get install -y --no-install-recommends \
    curl ca-certificates \
  && curl -SLO "https://nodejs.org/dist/v$NODEJS_VERSION/node-v$NODEJS_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODEJS_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODEJS_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODEJS_VERSION-linux-x64.tar.gz" -C /usr/local \
  && mv /usr/local/node-v$NODEJS_VERSION-linux-x64 /usr/local/nodejs \
  && rm "node-v$NODEJS_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
  && apt-get purge -y --auto-remove \
    curl ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && mkdir -p /builder

ADD export.sh /usr/bin/export.sh

ENV PATH /usr/local/nodejs/bin:$PATH

WORKDIR /src
VOLUME [ "/src", "/dst" ]
CMD [ "/bin/bash" ]