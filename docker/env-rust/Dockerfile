FROM tcurdt/debian

# ENV RUST_VERSION 1.0.0-beta.2
ENV RUST_VERSION nightly

RUN DEBIAN_FRONTEND=noninteractive apt-get -y update \
  && apt-get install -y --no-install-recommends \
    curl ca-certificates \
    # build-essential \
  && curl -sSL https://static.rust-lang.org/dist/rust-$RUST_VERSION-x86_64-unknown-linux-gnu.tar.gz | tar --exclude='*/rust-docs' -xzv -C /tmp && mv /tmp/rust-$RUST_VERSION-x86_64-unknown-linux-gnu /tmp/rust \
  && sed --in-place '/rust-docs/d' /tmp/rust/components \
  && /tmp/rust/install.sh \
  && rm -rf /tmp/rust \
  && apt-get purge -y --auto-remove \
    curl ca-certificates \
    # build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && mkdir -p /builder

ADD export.sh /usr/bin/export.sh

# ENV PATH /usr/local/rust/bin:$PATH

WORKDIR /src
VOLUME [ "/src", "/dst" ]
CMD [ "/bin/bash" ]