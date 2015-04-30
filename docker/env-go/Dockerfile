FROM tcurdt/debian

ENV GOLANG_VERSION 1.4.2
ENV GPM_VERSION 1.3.2
ENV GVP_VERSION 0.2.0

RUN DEBIAN_FRONTEND=noninteractive apt-get -y update \
  && apt-get install -y --no-install-recommends \
    curl ca-certificates \
    build-essential \
  && curl -sSL https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz | tar -xzv -C /usr/local \
  && curl -sSL https://github.com/pote/gpm/archive/v$GPM_VERSION.tar.gz | tar -xzv -C /usr/src \
  && mv /usr/src/gpm-$GPM_VERSION /usr/src/gpm \
  && cd /usr/src/gpm && ./configure && make install 2>&1 \
  && curl -sSL https://github.com/pote/gvp/archive/v$GVP_VERSION.tar.gz | tar -xzv -C /usr/src \
  && mv /usr/src/gvp-$GVP_VERSION /usr/src/gvp \
  && cd /usr/src/gvp && ./configure && make install 2>&1 \
  && rm -rf /usr/src \
  && apt-get purge -y --auto-remove \
    curl ca-certificates \
    build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && mkdir -p /builder

ADD export.sh /usr/bin/export.sh

ENV PATH /usr/local/go/bin:$PATH

WORKDIR /src
VOLUME [ "/src", "/dst" ]
CMD [ "/bin/bash" ]
