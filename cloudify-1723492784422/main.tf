
terraform {
  required_version = ">= 0.12"
}

resource "openstack_networking_network_v2" "Network-1" {
  name           = "Network 1"
  admin_state_up = "true"
}

resource "openstack_compute_instance_v2" "VM1" {
  name      = "VM1"
  image_id  = "ami-0c55b159cbfafe1f0"
  flavor_id = "t2.micro"
  block_device {
    uuid                  = "<image-id>"
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }
}

resource "openstack_blockstorage_volume_v3" "volume-1" {
  name = "volume 1"
}

resource "openstack_blockstorage_volume_v3" "volume-2" {
  name = "volume 2"
}

resource "openstack_compute_instance_v2" "VM2" {
  name      = "VM2"
  image_id  = "ami-0c55b159cbfafe1f0"
  flavor_id = "t2.micro"
  block_device {
    uuid                  = "<image-id>"
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }
}    
    