terraform {
  required_version = ">= 0.12"
}

resource "openstack_compute_instance_v2" "Server_20240813T001838132Z" {
  name              = "Server_20240813T001838132Z"
  count             = 1
  image_id          = ""
  key_name          = ""
  availability_zone = ""
  flavor_id         = ""
  user_data         = ""
}

