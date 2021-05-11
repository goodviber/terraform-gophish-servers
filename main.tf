################################################################################
# DATA TEMPLATES
################################################################################

# https://www.terraform.io/docs/providers/template/d/file.html

# https://www.terraform.io/docs/providers/template/d/cloudinit_config.html

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init_2.cfg")
  vars = {
    VM_USER = var.VM_USER
    VM_HOSTNAME = var.VM_HOSTNAME
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
}


################################################################################
# VM_RESOURCES
################################################################################

resource "libvirt_pool" "vm" {
  count = var.VM_RESOURCES ? 1 : 0
  name = "${var.VM_HOSTNAME}_pool"
  type = "dir"
  path = "/tmp/terraform-provider-libvirt-pool-ubuntu"
}

# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "vm" {
  count  = var.VM_RESOURCES ? 1 : 0
  name   = "${var.VM_HOSTNAME}-${count.index}_volume.${var.VM_IMG_FORMAT}"
  pool   = libvirt_pool.vm[0].name
  source = var.VM_IMG_URL
  format = var.VM_IMG_FORMAT
}

# Create a public network for the VMs
resource "libvirt_network" "vm_public_network" {
   count = var.VM_RESOURCES ? 1: 0
   name = "${var.VM_HOSTNAME}_network"
   mode = "nat"
   domain = "${var.VM_HOSTNAME}.local"
   addresses = [var.VM_CIDR_RANGE]
   dhcp {
    enabled = true
   }
   dns {
    enabled = true
   }
}

# for more info about parameter check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field

resource "libvirt_cloudinit_disk" "cloudinit" {
  count = var.VM_RESOURCES ? 1 : 0
  name           = "${var.VM_HOSTNAME}_cloudinit.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.vm[0].name
}

# Create the machine
resource "libvirt_domain" "vm" {
  count  = var.VM_RESOURCES ? 1 : 0
  name   = "${var.VM_HOSTNAME}-${count.index}"
  memory = "9182"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.cloudinit[0].id

  # Automate the creation of public network
  network_interface {
    network_id = libvirt_network.vm_public_network[0].id
    network_name = libvirt_network.vm_public_network[0].name
  }

  # IMPORTANT
  # Ubuntu can hang if a isa-serial is not present at boot time.
  # If you find your CPU 100% and never is available this is why.
  #
  # This is a known bug on cloud images, since they expect a console
  # we need to pass it:
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.vm[0].id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

