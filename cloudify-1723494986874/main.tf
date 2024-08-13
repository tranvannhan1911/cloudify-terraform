terraform {
  required_version = ">= 0.12"
}

resource "openstack_compute_instance_v2" "openstack_compute_instance_2" {
  name              = "openstack_compute_instance_2"
  count             = 1
  image_id          = "b49a9f66-d9a8-4e55-a3c7-772dead91986"
  key_name          = "demo-key"
  availability_zone = ""
  flavor_id         = "Medium-2"
  user_data         = ""
}

