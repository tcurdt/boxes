DOCKER=docker@`boot2docker ip`

CA=docker-registry
DOMAIN=vafer.org
PORT=5000
CLIENT=laptop

# copy
scp -i ~/.ssh/id_boot2docker \
  /Users/tcurdt/Projects/ca/$CA/ca/ca.crt \
  /Users/tcurdt/Projects/ca/$CA/clients/$CLIENT/client.crt \
  /Users/tcurdt/Projects/ca/$CA/clients/$CLIENT/client.key \
  ${DOCKER}:

# move in place
ssh -i ~/.ssh/id_boot2docker ${DOCKER} " \
  sudo mkdir -p /etc/docker/certs.d/$DOMAIN:$PORT ; \
  sudo mv ca.crt /etc/docker/certs.d/$DOMAIN:$PORT/$DOMAIN.crt ; \
  sudo chmod 440 /etc/docker/certs.d/$DOMAIN:$PORT/$DOMAIN.crt ; \
  sudo mv client.crt /etc/docker/certs.d/$DOMAIN:$PORT/client.cert ; \
  sudo chmod 440 /etc/docker/certs.d/$DOMAIN/client.cert ; \
  sudo mv client.key /etc/docker/certs.d/$DOMAIN:$PORT/client.key ; \
  sudo chmod 400 /etc/docker/certs.d/$DOMAIN:$PORT/client.key ; \
  sudo chown -R root:root /etc/docker/certs.d/$DOMAIN:$PORT ; \
  sudo find /etc/docker/certs.d
"
