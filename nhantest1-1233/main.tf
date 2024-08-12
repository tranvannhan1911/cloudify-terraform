terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

variable "external_network" {
    default = "provider-net3" 
}

# Configure the OpenStack Provider
provider "openstack" {
  user_name   = "${var.OS_USERNAME}"
  tenant_id = "${var.OS_TENANT_ID}"
  password    = "${var.OS_PASSWORD}"
  auth_url    = "${var.OS_AUTH_URL}"
  region      = "${var.OS_REGION_NAME}"
}

data "openstack_networking_network_v2" "provider_net" {  
  name = "${var.external_network}"  
}  
  
resource "openstack_networking_router_v2" "webapp_router" {  
  name                = "webapp_router"  
  admin_state_up      = true  
  external_network_id = data.openstack_networking_network_v2.provider_net.id  
}  
  
resource "openstack_networking_network_v2" "webapp_network" {  
  name           = "webapp_network"  
  admin_state_up = true  
}  
  
resource "openstack_networking_subnet_v2" "webapp_subnet" {  
  name            = "webapp_subnet"  
  network_id      = openstack_networking_network_v2.webapp_network.id  
  cidr            = "10.0.0.0/24"  
  ip_version      = 4  
  dns_nameservers = ["1.1.1.1"]  
}  
  
resource "openstack_networking_router_interface_v2" "webapp_router_interface" {  
  router_id = openstack_networking_router_v2.webapp_router.id  
  subnet_id = openstack_networking_subnet_v2.webapp_subnet.id  
}  
  
resource "openstack_compute_secgroup_v2" "webapp_secgroup" {  
  name        = "webapp_secgroup"  
  description = "Allow web traffic"  
  rule {  
    from_port   = 80  
    to_port     = 80  
    ip_protocol = "tcp"  
    cidr        = "0.0.0.0/0"  
  }
}  
  
resource "openstack_compute_floatingip_v2" "webapp_floatingip" {  
  pool = "provider-net3"
}  
  
# Volume  
data "openstack_images_image_v2" "ubuntu_image" {  
  name = "UBUNTU-22.04-25092023"  
}  
  
resource "openstack_blockstorage_volume_v3" "webapp_volume" {  
  name        = "webapp_volume"  
  description = "Volume for webapp"  
  size        = 40  
  volume_type = "Premium-SSD"  
  image_id    = data.openstack_images_image_v2.ubuntu_image.id  
}

resource "openstack_blockstorage_volume_v3" "webapp_volume_1" {  
  name        = "webapp_volume_1"  
  description = "Volume for webapp"  
  size        = 40  
  volume_type = "Premium-SSD"  
  image_id    = data.openstack_images_image_v2.ubuntu_image.id  
}
  
data "openstack_compute_flavor_v2" "s2_medium_1" {  
  name = "4C4G"  
}  
  
/* Userdata  
#cloud-config  
package_update: true  
chpasswd:  
  list: |    root:Welcome***123packages:  
  - nginx  - gitruncmd:  
  - systemctl enable nginx  - systemctl start nginx  - git clone https://github.com/cloudacademy/static-website-example.git  - cp -r ./static-website-example/* /var/www/html/  - rm -r ./static-website-example*/  

#Webapp Instance
resource "openstack_compute_instance_v2" "webapp_instance" {  
  name            = "webapp_instance"  
  image_id        = data.openstack_images_image_v2.ubuntu_image.id  
  flavor_id       = data.openstack_compute_flavor_v2.s2_medium_1.id  
  #key_pair        = data.openstack_compute_keypair_v2.webapp_key.name  
  security_groups = [openstack_compute_secgroup_v2.webapp_secgroup.name]  
  availability_zone = "nova"  
  
  user_data = "#cloud-config\npackage_update: true\nchpasswd:\n  list: |\n    root:Welcome***123\npackages:\n  - nginx\n  - git\nruncmd:\n  - systemctl enable nginx\n  - systemctl start nginx\n  - git clone https://github.com/cloudacademy/static-website-example.git\n  - cp -r ./static-website-example/* /var/www/html/\n  - rm -r ./static-website-example"  
  network {  
    name = openstack_networking_network_v2.webapp_network.name  
  }  
  block_device {  
    uuid                  = openstack_blockstorage_volume_v3.webapp_volume.id  
    source_type           = "volume"  
    destination_type      = "volume"  
    boot_index            = 0  
    delete_on_termination = true  
  }  
}

#Webapp-1 Instance
resource "openstack_compute_instance_v2" "webapp_instance_1" {  
  name            = "webapp_instance_1"  
  image_id        = data.openstack_images_image_v2.ubuntu_image.id  
  flavor_id       = data.openstack_compute_flavor_v2.s2_medium_1.id  
  #key_pair        = data.openstack_compute_keypair_v2.webapp_key.name  
  security_groups = [openstack_compute_secgroup_v2.webapp_secgroup.name]  
  availability_zone = "nova"  
  
  user_data = "#cloud-config\npackage_update: true\nchpasswd:\n  list: |\n    root:Welcome***123\npackages:\n  - nginx\n  - git\nruncmd:\n  - systemctl enable nginx\n  - systemctl start nginx\n  - git clone https://github.com/cloudacademy/static-website-example.git\n  - cp -r ./static-website-example/* /var/www/html/\n  - rm -r ./static-website-example"  
  network {  
    name = openstack_networking_network_v2.webapp_network.name  
  }  
  block_device {  
    uuid                  = openstack_blockstorage_volume_v3.webapp_volume_1.id  
    source_type           = "volume"  
    destination_type      = "volume"  
    boot_index            = 0  
    delete_on_termination = true  
  }  
}


resource "openstack_lb_loadbalancer_v2" "webapp" {
  name = "webapp"
  vip_address = "10.0.0.100"
  vip_subnet_id = openstack_networking_subnet_v2.webapp_subnet.id
  flavor_id = "0d0c5e88-521e-44a5-8b71-d1b4e6309dd9"
  admin_state_up = true
}


resource "openstack_lb_listener_v2" "webapp_listener" {
  name = "webapp_listener"
  protocol = "HTTP"
  protocol_port = "80"
  loadbalancer_id = openstack_lb_loadbalancer_v2.webapp.id
}
resource "openstack_lb_pool_v2" "webapp_pool" {
  lb_method = "SOURCE_IP"
  protocol    = "HTTP"
  listener_id = openstack_lb_listener_v2.webapp_listener.id
  admin_state_up = true
}

resource "openstack_lb_members_v2" "webapp_members" {
  pool_id = openstack_lb_pool_v2.webapp_pool.id

  member {
    address = openstack_compute_instance_v2.webapp_instance.access_ip_v4
    protocol_port = 80
  }

  member {
    address = openstack_compute_instance_v2.webapp_instance_1.access_ip_v4
    protocol_port = 80
  }
}

resource "openstack_lb_monitor_v2" "webapp_monitor" {
  name = "webapp_monitor"
  pool_id = openstack_lb_pool_v2.webapp_pool.id
  type = "PING"
  delay = 5
  timeout = 5
  max_retries = 3
}

data "openstack_networking_port_v2" "port_vip_lb" {
  network_id = openstack_networking_network_v2.webapp_network.id
  fixed_ip = "10.0.0.100"
  depends_on = [ openstack_lb_loadbalancer_v2.webapp ]
}
  
resource "openstack_networking_floatingip_associate_v2" "webapp_floatingip_associate" {  
  floating_ip = "103.71.97.39"
  port_id = data.openstack_networking_port_v2.port_vip_lb.id
}
  
output "webapp_public_ip" {  
  value       = openstack_networking_floatingip_associate_v2.webapp_floatingip_associate  
  description = "Web Application URL"  
}  
  
output "webapp_vip" {  
  value       = openstack_lb_listener_v2.webapp_listener  
  description = "Web Application VIP"  
}  