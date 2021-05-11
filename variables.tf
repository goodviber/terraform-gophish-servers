################################################################################
# ENV VARS
################################################################################

# https://www.terraform.io/docs/commands/environment-variables.html

variable "VM_USER" {
  default = "username"
  type = string
}

variable "VM_HOSTNAME" {
  default = "mail.your_domain_here.net"
  type = string
}

variable "VM_IMG_URL" {
  default = "https://cloud-images.ubuntu.com/releases/bionic/release/ubuntu-18.04-server-cloudimg-amd64.img"
  type = string
}

variable "VM_IMG_FORMAT" {
  default = "qcow2"
  type = string
}

variable "VM_CIDR_RANGE" {
  default = "10.10.10.10/24"
  type = string
}

variable "VPN_RANGE" {
  default = "10.0.0.0/16"
  type = string
}

variable "SUBNET_RANGE" {
  default = "10.0.1.0/24"
  type = string
}

# THIS SHOULD ONLY BE SET TO 1 OR 0, SO SET AS BOOL AND USE TERNARY

variable "VM_RESOURCES" {
  default = true
  type = bool
}

###################################
#          AWS CONFIG
###################################

# THIS SHOULD ONLY BE SET TO 1 OR 0, SO SET AS BOOL AND USE TERNARY

variable "AWS_RESOURCES" {
  default = false
  type = bool
}

variable "AWS_REGION" {
  default = "the_aws_region"
  type = string
}

###################################
#      AZURERM CONFIG
###################################

# THIS SHOULD ONLY BE SET TO 1 OR 0, SO SET AS BOOL AND USE TERNARY

variable "AZURERM_RESOURCES" {
  default = false
  type = bool
}

variable "AZURERM_LOCATION" {
  default = "uksouth"
  type = string
}

#####################################
#       CIVO CONFIG
#####################################

variable "CIVO_RESOURCES" {
  default = false
  type = bool
}

######################################
#         CLOUDFLARE CONFIG
######################################

variable "CLOUDFLARE_RESOURCES" {
  default = false
  type = bool
}

variable "zone_id" {
  default = "the zone id goes here"
}

variable "domain" {
  default = "your_domain_here.net"
}
