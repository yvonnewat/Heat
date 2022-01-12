#!/bin/bash

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
 --env "DEFAULT_EMAIL=mail@yourdomain.tld" \
 nginxproxy/acme-companion
    
# Run nextcloud container
docker run -d \
 --name=nextcloud \
 -e PUID=1000 \
 -e PGID=1000 \
 -e TZ=NZ \
 -p 443:443 \
 -v /path/to/appdata:/config \
 -v /path/to/data:/data \
 --restart unless-stopped \
 linuxserver/nextcloud

# Run nextcloud container proxied with nginx
docker run -d --name y-web \
    --name nginx-proxy-acme \
    --env "VIRTUAL_HOST=yvonne.intern.103.197.63.182.nip.io" \
    --env "LETSENCRYPT_HOST=yvonne.intern.103.197.63.182.nip.io" \
    --env "VIRTUAL_PORT=8000" --expose 8000 linuxserver/nextcloud
