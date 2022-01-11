#!/bin/bash

host_name=$1
domain_name=$2
ddns_password=$3
ddns_delay=$4

set +x
/tmp/ddns-script $host_name $domain_name $(ec2metadata --public-ipv4) $ddns_password
set -x

# This delay to allow DNS propagation to take place
sleep $ddns_delay

# Create nginx proxy
docker pull nginxproxy/nginx-proxy
docker run --detach \
--name nginx-proxy \
--publish 80:80 \
--publish 443:443 \
--volume certs:/etc/nginx/certs \
--volume vhost:/etc/nginx/vhost.d \
--volume html:/usr/share/nginx/html \
--volume /var/run/docker.sock:/tmp/docker.sock:ro \
nginxproxy/nginx-proxy

# Create nginx acme companion
docker pull nginxproxy/acme-companion
docker run --detach \
--name nginx-proxy-acme \
--volumes-from nginx-proxy \
--volume /var/run/docker.sock:/var/run/docker.sock:ro \
--volume acme:/etc/acme.sh \
--env "DEFAULT_EMAIL=admin@ilikebubbletea.me" \
nginxproxy/acme-companion
    
# Create etherpad container proxied with nginx
docker pull etherpad/etherpad
docker run -d \
--name=etherpad \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=NZ \
-p 443:443 \
-v /path/to/appdata:/config \
-v /path/to/data:/data \
--restart unless-stopped \
etherpad/etherpad
    
docker run -d --name web \
--env "VIRTUAL_HOST=$host_name.$domain_name" \
--env "LETSENCRYPT_HOST=$host_name.$domain_name"  \
--env "VIRTUAL_PORT=9001" --expose 9001 etherpad/etherpad
