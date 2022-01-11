# Terraform config file

terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

provider "openstack" { 
  allow_reauth = false
}

# Parameters/Variables

variable "host_name" {
  description = "host name to associate with IP address"
  type = string
  default = "yvonne"
}

variable "domain_name" {
  description = "domain name to associate with IP address"
  type = string
  default = "ilikebubbletea.me"
}

variable "ddns_script_url" {
  description = "URL of a script that will configure update ddns (called as ./ddns-script <hostname> <ip> <password>)"
  type = string
  default = "https://raw.githubusercontent.com/flashvoid/demo-provision/main/ddns/namecheap/ddns-update"
}

variable "ddns_password" {
  description = "ddns password to use"
  type = string
  sensitive = true
  default = "ea2d5c1e46c14257aff7cf52c15515c3"
}

variable "flavor_name" {
  description = "Flavor name for compute server"
  type = string
  default = "c1.c4r4"
}

variable "keyname" {
  description = "Keypair used for compute node"
  type = string
  default = "mykey"
}

variable "image_name" {
  description = "OS image for compute node"
  type = string
  default = "ubuntu-18.04-x86_64"
}

# Data

data "openstack_compute_flavor_v2" "flavor" {
  name = var.flavor_name
}

data "openstack_networking_network_v2" "public_net" {
  name = "public-net"
}

data "openstack_images_image_v2" "server_image" {
  name = var.image_name
  most_recent = true
}

# Resources

resource "openstack_networking_network_v2" "y_network" {
  name = "y_network"
}

resource "openstack_networking_subnet_v2" "y_subnet" {
  network_id = openstack_networking_network_v2.y_network.id
  name = "y_subnet"
  cidr = "192.168.199.0/24"
}

resource "openstack_networking_router_v2" "y_router" {
  name = "y_router"
  external_network_id = data.openstack_networking_network_v2.public_net.id
}

resource "openstack_networking_router_interface_v2" "y_interface" {
  router_id = openstack_networking_router_v2.y_router.id
  subnet_id = openstack_networking_subnet_v2.y_subnet.id
}

resource "openstack_networking_secgroup_v2" "y_security_grp" {
  name = "y_security_grp"
}

resource "openstack_networking_secgroup_rule_v2" "security_group_rule1" {
  security_group_id = openstack_networking_secgroup_v2.y_security_grp.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 1
  port_range_max = 65535
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_port_v2" "y_port" {
  name = "y_port"
  network_id = openstack_networking_network_v2.y_network.id
  security_group_ids = [ openstack_networking_secgroup_v2.y_security_grp.id ]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.y_subnet.id
  }
}

resource "openstack_networking_floatingip_v2" "y_floating_ip" {
  pool = data.openstack_networking_network_v2.public_net.name
}

resource "openstack_networking_floatingip_associate_v2" "y_floating_ip_association" {
  floating_ip = openstack_networking_floatingip_v2.y_floating_ip.address
  port_id = openstack_networking_port_v2.y_port.id
}

resource "openstack_compute_instance_v2" "qa_server" {
  name = "y_nextcloud_server"
  key_pair = var.keyname

  flavor_id = data.openstack_compute_flavor_v2.flavor.id

  network {
    port = openstack_networking_port_v2.y_port.id
  }

   block_device {
     delete_on_termination = true 
     source_type = "image"
     volume_size = 10
     destination_type = "volume"
     uuid = data.openstack_images_image_v2.server_image.id
  }

  user_data = templatefile("./cloud-init-test-etherpad.tpl", {
    domain_name = var.domain_name,
    host_name = var.host_name,
    ddns_password = var.ddns_password,
    ddns_script_url = var.ddns_script_url,
    ip_address = openstack_networking_floatingip_v2.y_floating_ip.address})
}

output "floating_ip" {
  value = openstack_networking_floatingip_v2.y_floating_ip.address
}
