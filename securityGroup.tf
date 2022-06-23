# security group for VM ( wordpress )
resource "openstack_networking_secgroup_v2" "secgroup_wordpress" {
  name        = "secgroup_wordpress"
  description = "My wordpress security group"
}
resource "openstack_networking_secgroup_rule_v2" "http_rule" {
  direction         = "ingress"        //封包傳進或傳出
  ethertype         = "IPv4"           //IPv4 or IPv6
  protocol          = "tcp"            //協定
  port_range_min    = 80               //指定 port 的範圍最小值，1 到 65535,允許http
  port_range_max    = 80               //指定 port 的範圍最大值
  remote_ip_prefix  = "0.0.0.0/0"      //指定封包的ip
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_wordpress.id}"  //必須將此 rule 加到一個 security group
}
resource "openstack_networking_secgroup_rule_v2" "https_rule" {
  direction         = "ingress"     
  ethertype         = "IPv4"        
  protocol          = "tcp"        
  port_range_min    = 443         //允許https 
  port_range_max    = 443             
  remote_ip_prefix  = "0.0.0.0/0"    
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_wordpress.id}"
}
resource "openstack_networking_secgroup_rule_v2" "ssh_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22       //允許ssh
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_wordpress.id}"
}
resource "openstack_networking_secgroup_rule_v2" "icmp_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"    //允許ping
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_wordpress.id}"
}

# Security group for database
resource "openstack_networking_secgroup_v2" "secgroup_database" {
  name        = "secgroup_database"
  description = "My database security group"
}
resource "openstack_networking_secgroup_rule_v2" "db_ssh_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "192.168.199.0/24"  //只允許public subnet的ip進來
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_database.id}"
}
resource "openstack_networking_secgroup_rule_v2" "db_icmp_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "192.168.199.0/24"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_database.id}"
}
resource "openstack_networking_secgroup_rule_v2" "db_rule" {
  direction         = "ingress"    
  ethertype         = "IPv4"      
  protocol          = "tcp"      
  port_range_min    = 3306       
  port_range_max    = 3306            
  remote_ip_prefix  = "192.168.199.0/24"     
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_database.id}"
}
