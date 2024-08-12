terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
}

# Network  
data "openstack_networking_network_v2" "provider_net" {  
  name = "${var.external_network}"  
}  