#!/bin/bash

host_name=$1
domain_name=$2
ddns_password=$3
ip_address=$4

docker pull nginxproxy/nginx-proxy
docker pull nginxproxy/acme-companion
docker pull etherpad/etherpad

bash -x ddns-script.sh $host_name $domain_name $ddns_password $ip_address

# This delay to allow DNS propagation to take place
sleep 3m

# Create nginx proxy
docker run --detach \
--name nginx-proxy \
--publish 80:80 \
--volume certs:/etc/nginx/certs \
--volume vhost:/etc/nginx/vhost.d \
--volume html:/usr/share/nginx/html \
--volume /var/run/docker.sock:/tmp/docker.sock:ro \
nginxproxy/nginx-proxy

# Create nginx acme companion
docker run --detach \
--name nginx-proxy-acme \
--volumes-from nginx-proxy \
--volume /var/run/docker.sock:/var/run/docker.sock:ro \
--volume acme:/etc/acme.sh \
--env "DEFAULT_EMAIL=admin@ilikebubbletea.me" \
nginxproxy/acme-companion
    
# Create etherpad container proxied with nginx
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
