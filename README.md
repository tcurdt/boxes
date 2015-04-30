ansible-playbook -i inventory.cfg -u root -k vserver.yml
ansible-playbook -i inventory.cfg vserver.yml

ansible-playbook -i inventory.cfg vserver.yml --tags "site"
ansible-playbook -i inventory.cfg vserver.yml --tags "user"

docker run --name nginx \
  --restart=always \
  --net=host \
  -p 0.0.0.0:80:80 \
  -p 0.0.0.0:443:443 \
  -v /srv/nginx:/srv/nginx:ro \
  -v /var/run/app:/var/run/app:rw \
  -v /etc/nginx/sites-available:/etc/nginx/sites-available:ro \
  -v /etc/nginx/sites-enabled:/etc/nginx/sites-enabled:ro \
  -v /etc/nginx/upstream.d:/etc/nginx/upstream.d:ro \
  -dt tcurdt/nginx

docker run --name upstream \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /etc/nginx/upstream.d/generated:/srv/upstream/generated:rw \
  -dt tcurdt/upstream

docker run --name znc \
  --restart=always \
  --net=host \
  -p 0.0.0.0:6667:6667 \
  -v /srv/znc:/srv/znc:rw \
  -dt tcurdt/znc

docker run --name registry \
  --restart=always \
  --net=host \
  -p 0.0.0.0:5000:5000 \
  -v /srv/registry/storage:/storage \
  -v /srv/registry/config:/config \
  -dt tcurdt/registry

docker run \
  -v /Users/tcurdt/Projects/ca/vafer.org/ca:/ca:ro \
  -v /Users/tcurdt/Projects/ca/vafer.org/servers/vafer.org:/server:ro \
  -v /Users/tcurdt/Projects/ca/vafer.org/clients/torsten:/client:ro \
  tcurdt/boot2docker
 > boot2docker.iso



// working
wget -qO- https://vafer.org:5000/v2/ \
  --no-check-certificate \
  --ca-certificate vafer.org/ca/ca.crt \
  --certificate vafer.org/clients/torsten/client.crt \
  --private-key vafer.org/clients/torsten/client.key

// not loading
curl --insecure \
  --cert client.crt \
  --key client.key \
  https://vafer.org:5000/v2/

// crash
curl --insecure \
  --cert client.p12 \
  --pass torsten \
  https://vafer.org:5000/v2/

boot2docker ssh curl -s --insecure https://vafer.org:5000/v2/

openssl s_client \
  -connect vafer.org:5000 \
  -servername vafer.org \
  -cert vafer.org/clients/torsten/client.crt \
  -key vafer.org/clients/torsten/client.key \
  -CAfile vafer.org/ca/ca.crt

    vafer.org
openssl s_client \
  -connect 5.189.136.58:5000 \
  -CAfile vafer.org/ca/ca.crt \
  -servername vafer.org

openssl s_client \
  -connect 5.189.136.58:5000 \
  -servername vafer.org \
  -state -debug



docker run --name registry \
  --entrypoint /bin/bash \
  -p 0.0.0.0:5000:5000 \
  -v /srv/registry/storage:/storage:rw \
  -v /srv/registry/config:/config:ro \
  --rm -it tcurdt/registry


docker run --name znc \
  --entrypoint /bin/sh \
  -p 0.0.0.0:6667:6667 \
  -v /srv/znc:/srv/znc:rw \
  --rm -it tcurdt/znc
  znc -d /srv/znc --makepem

docker run --name nginx \
  --entrypoint /bin/sh \
  --net=host \
  -p 0.0.0.0:80:80 \
  -p 0.0.0.0:443:443 \
  -v /srv/nginx:/srv/nginx \
  -v /etc/nginx/sites-available:/etc/nginx/sites-available \
  -v /etc/nginx/sites-enabled:/etc/nginx/sites-enabled \
  -v /etc/nginx/upstream.d:/etc/nginx/upstream.d \
  --rm -it tcurdt/nginx

docker run --name lifeisforsurfing \
  -p 8000:8000 \
  --label org.vafer.upstream=8000 \
  --rm -it vafer.org:5000/lifeisforsurfing
