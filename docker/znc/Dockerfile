FROM tcurdt/debian
ENV ZNC_VERSION 1.6.0

# see http://sources.debian.net/src/znc/1.6.0-2/debian/rules/
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update \
  && apt-get install -y --no-install-recommends \
    curl ca-certificates \
    gcc g++ make libc6-dev libssl-dev \
    libssl1.0.0 \
  && mkdir -p /tmp/build \
  && curl -sL http://znc.in/releases/znc-${ZNC_VERSION}.tar.gz | tar -xzf - -C /tmp/build --strip=1 \
  && cd /tmp/build && ./configure \
    --prefix=/usr \
    --libdir=/usr/lib \
  && make && make install \
  && apt-get purge -y --auto-remove \
    curl ca-certificates \
    gcc g++ make libc6-dev libssl-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER daemon
WORKDIR /srv/znc
ENTRYPOINT [ "znc", "-f", "-d", "/srv/znc" ]

EXPOSE 6667
