#cloud-config
package_update: true
package_upgrade: true
package_reboot_if_required: true
runcmd:
  - exec &>/var/log/boot-config.log
  - apt-get update
  - apt-get install -y docker.io
  - docker pull etherpad/etherpad
  - docker pull nginxproxy/nginx-proxy
  - docker pull nginxproxy/acme-companion

  - curl https://raw.githubusercontent.com/flashvoid/demo-provision/main/ddns/namecheap/ddns-update -o /tmp/ddns-script
  - chmod +x /tmp/ddns-script

  # This delay to ensure floating ip gets associated to the instance
  # sleep 1m

  - set +x
  - /tmp/ddns-script yvonne ilikebubbletea.me $(ec2metadata --public-ipv4) ea2d5c1e46c14257aff7cf52c15515c3
  - set -x

  # This delay to allow DNS propagation to take place
  - sleep 3m

  - docker run --detach \
    --name nginx-proxy \
    --publish 80:80 \
    --publish 443:443 \
    --volume certs:/etc/nginx/certs \
    --volume vhost:/etc/nginx/vhost.d \
    --volume html:/usr/share/nginx/html \
    --volume /var/run/docker.sock:/tmp/docker.sock:ro \
    nginxproxy/nginx-proxy
    
  - docker run --detach \
    --name nginx-proxy-acme \
    --volumes-from nginx-proxy \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume acme:/etc/acme.sh \
    --env "DEFAULT_EMAIL=admin@ilikebubbletea.me" \
    nginxproxy/acme-companion
    
  - docker run -d --name web \
    --env "VIRTUAL_HOST=yvonne.ilikebubbletea.me" \
    --env "LETSENCRYPT_HOST=yvonne.ilikebubbletea.me"  \
    --env "VIRTUAL_PORT=9001" --expose 9001 etherpad/etherpad
