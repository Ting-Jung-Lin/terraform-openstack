# Create wordpress VM1 
resource "openstack_compute_instance_v2" "wordpress_1" {
  name            = "wordpress_1"  
  image_id        = var.image //要使用的映象檔id
  flavor_id       = "2"         //這裡選用 2GB RAM 以及 20GB 硬碟的選項    
  security_groups = ["${openstack_networking_secgroup_v2.secgroup_wordpress.name}"]   //要使用的security group
  user_data=file("./cloudinit")
  key_pair        = "my-keypair"     //公鑰
  network {
    name = "network_wordpress"
  }
  depends_on = [openstack_networking_subnet_v2.subnet_wordpress] //相依性，要等子網建好才能在子網裡建VM
}
# Create wordpress VM2
resource "openstack_compute_instance_v2" "wordpress_2" {
  name            = "wordpress_2"  
  image_id        = var.image
  flavor_id       = "2" 
  security_groups = ["${openstack_networking_secgroup_v2.secgroup_wordpress.name}"]
  user_data=file("./cloudinit")
  key_pair        = "my-keypair"   
  network {
    name = "network_wordpress"
  }
  depends_on = [openstack_networking_subnet_v2.subnet_wordpress]
}
# Create database instance
resource "openstack_compute_instance_v2" "database" {
  name            = "database"  
  image_id        = var.image
  flavor_id       = "2"
  security_groups = ["${openstack_networking_secgroup_v2.secgroup_database.name}"]
  user_data=file("./cloudinit")
  key_pair        = "my-keypair"
  network {
    name = "network_database"
  }
  depends_on = [openstack_networking_subnet_v2.subnet_database]
}

# manage your public key
resource "openstack_compute_keypair_v2" "test-keypair" {
  name       = "my-keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnD7J1pmKXr8YADL/W7GGmjjzk9rdSN69wVqiCSLHsBoeddBplWHfvSKlidAk5ahiHv1DP67H8enqRHcaPLXIuN9mVHBng6UPCoVnm8PLiKLLpoOHxhmmJGUl3pIiPpogbLziHlhVRMkb4HeIdJ+yV2c8cnBtGDSwrcqLL960uGXaN5ZGAJrRDchb9fYWAYfxajSRmvRs3HPWG4JyEsSXzG0HsRvNcNNVkhfxmZk4cz+XaqAff8LPSZcseIzVu9UQEF5QPxJ3+VBiCE23pus/M7jfvKivHyFm9Clf8F2OABsht0N8q1Yvbr3DfMoHRY7wlDOWXxdHJr5+rzZOucJ77SWXuOAnO1QpUYo30j1yokRWeiC57pJVCVFFe1tcgzLmPYiauxra3/a0gI81ggupKI2gp+x3Qjkyjtu0gqPVvfBtkSYoUVFJ0KIsWm4oRLb/fBqa4ruulu63ZmngdRZGB83C9lyrTZv7UIeiQSD8AZmoXxtfr/+BwfYYj1g0j/QM= openstack@openstack-VirtualBox"
}

# creating floating IP for wordpress_1
resource "openstack_networking_floatingip_v2" "floatip_1" {
  pool = "external"  //從外網網段池中提取 floating ip
}
resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip_1.address}"
  instance_id = "${openstack_compute_instance_v2.wordpress_1.id}"
}

# creating floating IP for wordpress_2
resource "openstack_networking_floatingip_v2" "floatip_2" {
  pool = "external"
}
resource "openstack_compute_floatingip_associate_v2" "fip_2" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip_2.address}"
  instance_id = "${openstack_compute_instance_v2.wordpress_2.id}"
}
