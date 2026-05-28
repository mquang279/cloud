terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

locals {
  vm_names = ["vm1", "vm2"]
}

resource "libvirt_volume" "ubuntu_base" {
  name   = "ubuntu-base.qcow2"
  pool   = "default"
  source = "${path.module}/ubuntu.img"
  format = "qcow2"
}

resource "libvirt_volume" "vm_disk" {
  count          = 2
  name           = "${local.vm_names[count.index]}.qcow2"
  pool           = "default"
  base_volume_id = libvirt_volume.ubuntu_base.id
  size           = 20 * 1024 * 1024 * 1024
}

data "template_file" "user_data" {
  count = 2

  template = file("${path.module}/cloud_init.cfg")

  vars = {
    hostname = local.vm_names[count.index]
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count = 2

  name      = "${local.vm_names[count.index]}-commoninit.iso"
  pool      = "default"
  user_data = data.template_file.user_data[count.index].rendered
}

resource "libvirt_domain" "ubuntu_vm" {
  count = 2

  name   = local.vm_names[count.index]
  memory = "4096"
  vcpu   = 4

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = libvirt_volume.vm_disk[count.index].id
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

output "vm_ips" {
  value = {
    for vm in libvirt_domain.ubuntu_vm :
    vm.name => vm.network_interface[0].addresses
  }
}

