terraform {
  required_version = ">= 0.12"
}

resource "openstack_lb_loadbalancer_v2" "openstack_lb_loadbalancer_v2_1" {
  name        = "openstack_lb_loadbalancer_v2_1"
  description = ""
}

