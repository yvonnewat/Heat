#cloud-config
package_update: true
package_upgrade: true
package_reboot_if_required: true
packages:
  - docker-ce
  - docker-ce-cli
  - containerd.io
runcmd:
  - curl -fsSL "https://raw.githubusercontent.com/flashvoid/demo-provision/main/ddns/namecheap/ddns-update" > ddns-script.sh
  - chmod +x ddns-script.sh 
  - curl -fsSL "https://raw.githubusercontent.com/yvonnewat/Heat/main/Terraform/setup-script.sh" > setup-script.sh
  - chmod +x setup-script.sh
  - echo $host_name $domain_name $ddns_password > test.txt
  - cat test.txt
  - ./setup-script.sh $host_name $domain_name $ddns_password
  - touch /deploy-complete
apt:
  sources:
    docker:
      source: deb https://download.docker.com/linux/ubuntu $RELEASE stable
      keyid: 9dc858229fc7dd38854ae2d88d81803c0ebfcd88
