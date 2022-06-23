# Create virtual network for wordpress
resource "openstack_networking_network_v2" "network_wordpress" {
  name           = "network_wordpress"
  admin_state_up = "true" 
}

# Create Public Subnet for wordpress VMs
resource "openstack_networking_subnet_v2" "subnet_wordpress" {
  name       = "subnet_wordpress"
  network_id = "${openstack_networking_network_v2.network_wordpress.id}" //在哪個虛擬網路下
  cidr       = "192.168.199.0/24"   //無類別域間路由（Classless Inter-Domain Routing）,指定一個給子網的網段
  ip_version = 4
}

# Create virtual network for database VM
resource "openstack_networking_network_v2" "network_database" {
  name           = "network_database"
  admin_state_up = "true"  
}
# Create Private subnet for database VM
resource "openstack_networking_subnet_v2" "subnet_database" {
  name       = "subnet_database"
  network_id = "${openstack_networking_network_v2.network_database.id}" 
  cidr       = "192.168.200.0/24"  
  ip_version = 4
}
data "openstack_networking_network_v2""external"{
    name="external"
}
# Creating Route table 
resource "openstack_networking_router_v2" "router_1" {
  name                = "my_router"
  admin_state_up      = true  
  external_network_id = data.openstack_networking_network_v2.external.id  //一個有連接外網的網路
}
# Associating route table to public subnet "subnet_wordpress"
resource "openstack_networking_router_interface_v2" "int_1" {
  router_id = "${openstack_networking_router_v2.router_1.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet_wordpress.id}"
  //depends_on=[openstack_networking_subnet_v2.subnet_wordpress]
}
# Associating route table to private subnet "subnet_database"
resource "openstack_networking_router_interface_v2" "int_2" {
  router_id = "${openstack_networking_router_v2.router_1.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet_database.id}"
  //depends_on=[openstack_networking_subnet_v2.subnet_database]
}
