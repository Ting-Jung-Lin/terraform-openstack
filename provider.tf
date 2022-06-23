terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
    }
  }
}
provider "openstack" {
  user_name   = "admin"
  auth_url    = "https://10.0.2.15:5000/v3/"
  region      = "microstack"
  domain_name = "Default"
  insecure = true
}
