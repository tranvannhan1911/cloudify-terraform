terraform {
  required_version = ">= 0.12"
}

resource "openstack_compute_instance_v2" "Server_20240813T003444504Z" {
  name              = "Server_20240813T003444504Z"
  count             = 1
  image_id          = ""
  key_name          = ""
  availability_zone = ""
  flavor_id         = ""
  user_data         = ""
}

resource "openstack_lb_loadbalancer_v2" "Load_Balancer_20240813T003445703Z" {
  name        = "Load_Balancer_20240813T003445703Z"
  description = ""
}

resource "openstack_compute_instance_v2" "Server_20240813T003450368Z" {
  name              = "Server_20240813T003450368Z"
  count             = 1
  image_id          = ""
  key_name          = ""
  availability_zone = ""
  flavor_id         = ""
  user_data         = ""
}

resource "openstack_compute_instance_v2" "Server_20240813T003658199Z" {
  name              = "Server_20240813T003658199Z"
  count             = 1
  image_id          = ""
  key_name          = ""
  availability_zone = ""
  flavor_id         = ""
  user_data         = ""
}

