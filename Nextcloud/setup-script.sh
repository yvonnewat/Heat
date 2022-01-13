#!/bin/bash

host_name=$1
domain_name=$2
ddns_password=$3
ip_address=$4

bash -x ddns-script.sh $host_name $domain_name $ip_address $ddns_password 

# DNS propagation delay
sleep 1m

# Pull containers
docker pull nginxproxy/nginx-proxy
docker pull nginxproxy/acme-companion
docker pull linuxserver/nextcloud

# Run nginx-proxy
docker run --detach \
 --name nginx-proxy \
 --publish 80:80 \
 --publish 443:443 \
 --volume certs:/etc/nginx/certs \
 --volume vhost:/etc/nginx/vhost.d \
 --volume html:/usr/share/nginx/html \
 --volume /var/run/docker.sock:/tmp/docker.sock:ro \
 nginxproxy/nginx-proxy
    
# Run acme-companion
docker run --detach \
 --name nginx-proxy-acme \
 --volumes-from nginx-proxy \
 --volume /var/run/docker.sock:/var/run/docker.sock:ro \
 --volume acme:/etc/acme.sh \
 --env "DEFAULT_EMAIL=admin@$domain_name" \
 nginxproxy/acme-companion
    
# Run nextcloud container
docker run -d \
 --name=nextcloud \
 -e PUID=1000 \
 -e PGID=1000 \
 -e TZ=NZ \
 --env "VIRTUAL_HOST=$host_name.$domain_name" \
 --env "LETSENCRYPT_HOST=$host_name.$domain_name"  \
 --env "VIRTUAL_PORT=8000" \
 -p 443:443 \
 -v /path/to/appdata:/config \
 -v /path/to/data:/data \
 --restart unless-stopped \
 --expose 8000 \
 linuxserver/nextcloud
