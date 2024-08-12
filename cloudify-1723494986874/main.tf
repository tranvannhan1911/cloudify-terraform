terraform {
  required_version = ">= 0.12"
}

resource "openstack_compute_instance_v2" "openstack_compute_instance_v2_1" {
  name              = "openstack_compute_instance_v2_1"
  count             = 1
  image_id          = ""
  key_name          = ""
  availability_zone = ""
  flavor_id         = ""
  user_data         = ""
}

resource "openstack_compute_instance_v2" "openstack_compute_instance_v2_2" {
  name              = "openstack_compute_instance_v2_2"
  count             = 1
  image_id          = ""
  key_name          = ""
  availability_zone = ""
  flavor_id         = ""
  user_data         = ""
}

