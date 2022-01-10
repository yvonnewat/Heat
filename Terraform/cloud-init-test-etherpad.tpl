#cloud-config
package_update: true
package_upgrade: true
package_reboot_if_required: true]
packages:
  - docker-ce
  - docker-ce-cli
  - containerd.io
runcmd:
  - exec &>/var/log/boot-config.log

  - curl https://raw.githubusercontent.com/flashvoid/demo-provision/main/ddns/namecheap/ddns-update -o /tmp/ddns-script
  - chmod +x /tmp/ddns-script

  # This delay to ensure floating ip gets associated to the instance
  # sleep 1m

  - set +x
  - /tmp/ddns-script yvonne ilikebubbletea.me $(ec2metadata --public-ipv4) ea2d5c1e46c14257aff7cf52c15515c3
  - set -x

  # This delay to allow DNS propagation to take place
  - sleep 3m

  # Create nginx proxy
  
  - docker pull nginxproxy/nginx-proxy
  - docker run --detach \
    --name nginx-proxy \
    --publish 80:80 \
    --publish 443:443 \
    --volume certs:/etc/nginx/certs \
    --volume vhost:/etc/nginx/vhost.d \
    --volume html:/usr/share/nginx/html \
    --volume /var/run/docker.sock:/tmp/docker.sock:ro \
    nginxproxy/nginx-proxy
  
  # Create nginx acme companion
  
  - docker pull nginxproxy/acme-companion
  - docker run --detach \
    --name nginx-proxy-acme \
    --volumes-from nginx-proxy \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume acme:/etc/acme.sh \
    --env "DEFAULT_EMAIL=admin@ilikebubbletea.me" \
    nginxproxy/acme-companion
    
  # Create etherpad container proxied with nginx

  - docker pull etherpad/etherpad
  - docker run -d \
    --name=etherpad \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=NZ \
    -p 443:443 \
    -v /path/to/appdata:/config \
    -v /path/to/data:/data \
    --restart unless-stopped \
    etherpad/etherpad
    
  - docker run -d --name nginx-proxy-acme \
    --env "VIRTUAL_HOST=yvonne.ilikebubbletea.me" \
    --env "LETSENCRYPT_HOST=yvonne.ilikebubbletea.me"  \
    --env "VIRTUAL_PORT=9001" --expose 9001 etherpad/etherpad
    
  - touch /deploy-complete
    
apt:
  sources:
    docker:
      source: deb https://download.docker.com/linux/ubuntu $RELEASE stable
      keyid: 9dc858229fc7dd38854ae2d88d81803c0ebfcd88
