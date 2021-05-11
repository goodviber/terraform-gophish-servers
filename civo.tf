#resource "civo_network" "postfix_network" {
  #label = "postfix_network"
#}

#resource "civo_firewall" "postfix_firewall" {
  #name = "postfix_firewall"
#}

#resource "civo_firewall_wall" "http" {
  #firewall_id = civo_firewall.postfix_firewall.id
  #protocol = "tcp"
  #start_port = "80"
  #end_port = "80"
  #cidr = ["0.0.0.0/0"]
  #direction = "ingress"
  #label = "server internet"
  #depends_on = [civo_firewall.postfix_firewall]
#}

#resource "civo_firewall_wall" "shh" {
  #firewall_id = civo_firewall.postfix_firewall.id
  #protocol = "tcp"
  #start_port = "22"
  #end_port = "22"
  #cidr = ["0.0.0.0/0"]
  #direction = "ingress"
  #label = "server ssh"
  #depends_on = [civo_firewall.postfix_firewall]
#}

#resource "civo_firewall_wall" "smtp" {
  #firewall_id = civo_firewall.postfix_firewall.id
  #protocol = "tcp"
  #start_port = "25"
  #end_port = "25"
  #cidr = ["0.0.0.0/0"]
  #direction = "ingress"
  #label = "server smtp"
  #depends_on = [civo_firewall.postfix_firewall]
#}

#resource "civo_firewall_wall" "egress" {
  #firewall_id = civo_firewall.postfix_firewall.id
  #protocol = "tcp"
  #start_port = "*"
  #end_port = "*"
  #cidr = ["0.0.0.0/0"]
  #direction = "egress"
  #label = "server egress"
  #depends_on = [civo_firewall.postfix_firewall]
#}

#resource "civo_instance" "postfix_instance" {
  #hostname = var.VM_HOSTNAME
  #tags = ["postfix"]
  #size = element(data.civo_instances_size.small.sizes, 0).name
  #template = element(data.template_file.user_data.rendered)
#}

#data "civo_instances_size" "small" {
    #filter {
        #key = "cpu_cores"
        #values = [1,2]
    #}

    #sort {
        #key = "disk_gb"
        #direction = "desc"
    #}
#}

#output "instance_sizes" {
  #value = data.civo_instances_size.small
#}
