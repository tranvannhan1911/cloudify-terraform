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
  tenant_id = "${var.TENANT_ID}"
  password    = "${var.OS_PASSWORD}"
  auth_url    = "${var.AUTH_URL}"
  region      = "${var.REGION_NAME}"
}

# Network  
data "openstack_networking_network_v2" "provider_net" {  
  name = "${var.external_network}"  
}