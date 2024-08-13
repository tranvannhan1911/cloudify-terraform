terraform {
  required_version = ">= 0.12"
}

resource "openstack_compute_instance_v2" "Server_20240813T002021100Z" {
  name              = "Server_20240813T002021100Z"
  count             = 1
  image_id          = ""
  key_name          = ""
  availability_zone = ""
  flavor_id         = ""
  user_data         = ""
}

resource "openstack_lb_loadbalancer_v2" "Load_Balancer_20240813T002031523Z" {
  name        = "Load_Balancer_20240813T002031523Z"
  description = ""
}

resource "openstack_compute_instance_v2" "Server_20240813T002047122Z" {
  name              = "Server_20240813T002047122Z"
  count             = 1
  image_id          = ""
  key_name          = ""
  availability_zone = ""
  flavor_id         = ""
  user_data         = ""
}

