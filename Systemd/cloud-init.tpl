#cloud-config
package_update: true
package_upgrade: true
package_reboot_if_required: true
runcmd:
  - apt-get update
  - apt-get install -y curl git
  - curl -fsSL https://deb.nodesource.com/setup_current.x | bash -
  - apt-get install -y nodejs
  - mkdir /etherpad
  - cd /etherpad
  - git clone --branch master https://github.com/ether/etherpad-lite.git
  - cd ~
  - curl -fsSL https://raw.githubusercontent.com/yvonnewat/Heat/main/Systemd/run-etherpad.sh
  - cd /etc/systemd/system
  - curl -fsSL https://raw.githubusercontent.com/yvonnewat/Heat/main/Systemd/run-etherpad.service
  - systemctl daemon-reload 
  - systemctl enable run-etherpad.service 
  - systemctl start --no-block run-etherpad.service 
  - touch /deploy-complete
