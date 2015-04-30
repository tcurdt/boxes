FROM tcurdt/debian
ENV NGINX_VERSION 1.6.3

# see http://sources.debian.net/src/nginx/1.6.2-5/debian/rules/
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update \
  && apt-get install -y --no-install-recommends \
    curl ca-certificates \
    gcc g++ make libc6-dev libpcre++-dev libssl-dev libgeoip-dev openssl \
    geoip-bin geoip-database  \
    libpcre++0 libssl1.0.0 libgeoip1 \
  && mkdir -p /tmp/build \
  && curl -sL http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar -xzf - -C /tmp/build --strip=1 \
  && cd /tmp/build && ./configure \
    --sbin-path=/usr/sbin \
    --prefix=/usr/share/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    --lock-path=/var/lock/nginx.lock \
    --pid-path=/run/nginx.pid \
    --http-client-body-temp-path=/var/lib/nginx/body \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --http-scgi-temp-path=/var/lib/nginx/scgi \
    --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
    --with-debug \
    --with-pcre-jit \
    --with-ipv6 \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-http_geoip_module \
    --with-http_gzip_static_module \
    --with-http_gunzip_module \
    --with-http_spdy_module \
  && make && make install \
  && mkdir -p /var/lib/nginx/body \
  && mkdir -p /var/lib/nginx/proxy \
  && mkdir -p /var/lib/nginx/fastcgi \
  && mkdir -p /var/lib/nginx/uwsgi \
  && mkdir -p /var/lib/nginx/scgi \
  && openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048 \
  && apt-get purge -y --auto-remove \
    curl ca-certificates \
    gcc g++ make libc6-dev libpcre++-dev libssl-dev libgeoip-dev openssl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -f /var/log/error.log && rm -f /var/log/access.log && rm -rf /var/www/html

RUN mkdir -p /srv/nginx \
  && mkdir -p /etc/nginx/snippets \
  && mkdir -p /etc/nginx/upstream.d \
  && mkdir -p /etc/nginx/sites-enabled \
  && mkdir -p /etc/nginx/sites-available

COPY nginx.conf /etc/nginx/nginx.conf
COPY ssl.conf   /etc/nginx/snippets/ssl.conf
COPY proxy.conf /etc/nginx/snippets/proxy.conf

VOLUME [ "/etc/nginx/sites-enabled", "/etc/nginx/sites-available", "/etc/nginx/upstream.d", "/srv/nginx", "/var/run/app" ]

WORKDIR /srv/nginx
ENTRYPOINT [ "nginx" ]

EXPOSE 80
EXPOSE 443