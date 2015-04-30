#!/bin/sh
set -e

export CA=`openssl x509 -noout -subject -in /ca/ca.crt | sed -n '/^subject/s/^.*CN=//p'`
export DOMAIN=`openssl x509 -noout -subject -in /server/server.crt | sed -n '/^subject/s/^.*CN=//p'`

PORT=5000

mkdir -p $ROOTFS/etc/docker/certs.d/$DOMAIN:$PORT

cp /ca/ca.crt $ROOTFS/etc/docker/certs.d/$DOMAIN:$PORT/$CA.crt
cp /client/client.crt $ROOTFS/etc/docker/certs.d/$DOMAIN:$PORT/client.cert
cp /client/client.key $ROOTFS/etc/docker/certs.d/$DOMAIN:$PORT/client.key

chown -R root:root $ROOTFS/etc/docker/certs.d/$DOMAIN:$PORT

chmod 440 $ROOTFS/etc/docker/certs.d/$DOMAIN:$PORT/$CA.crt
chmod 440 $ROOTFS/etc/docker/certs.d/$DOMAIN:$PORT/client.cert
chmod 400 $ROOTFS/etc/docker/certs.d/$DOMAIN:$PORT/client.key

/make_iso.sh 1>/dev/null 2>/dev/null
cat /boot2docker.iso