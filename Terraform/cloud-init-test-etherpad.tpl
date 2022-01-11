#cloud-config
package_update: true
package_upgrade: true
package_reboot_if_required: true
packages:
  - docker-ce
  - docker-ce-cli
  - containerd.io
runcmd:
  - curl $ddns_script_url -o /tmp/ddns-script
  - chmod +x /tmp/ddns-script
  - curl https://raw.githubusercontent.com/yvonnewat/Heat/main/Terraform/setup-script.sh > setup-script.sh
  - chmod +x setup-script.sh
  - ./setup-script.sh
  - touch /deploy-complete
apt:
  sources:
    docker:
      source: deb https://download.docker.com/linux/ubuntu $RELEASE stable
      keyid: 9dc858229fc7dd38854ae2d88d81803c0ebfcd88
