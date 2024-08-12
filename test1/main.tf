terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

variable "OS_PASSWORD" {
  type = string
}


# Configure the OpenStack Provider
provider "openstack" {
}

output "print_password" {
  value = var.OS_PASSWORD
}