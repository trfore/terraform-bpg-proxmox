terraform {
  required_version = ">=1.5.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.46.0"
    }
  }
}

resource "proxmox_virtual_environment_container" "lxc" {
  node_name    = var.node
  vm_id        = var.lxc_id
  description  = var.description
  tags         = var.tags
  unprivileged = var.unprivileged

  operating_system {
    template_file_id = var.os_template
    type             = var.os_type
  }

  initialization {
    hostname = var.lxc_name

    ip_config {
      dynamic "ipv4" {
        for_each = var.ipv4
        content {
          address = ipv4.value.ipv4_address
          gateway = ipv4.value.ipv4_gateway
        }
      }
    }

    user_account {
      keys     = [file("${var.user_ssh_key_public}")]
      password = var.user_password
    }
  }

  network_interface {
    name    = var.vnic_name
    bridge  = var.vnic_bridge
    vlan_id = var.vlan_tag
  }

  cpu {
    cores = var.vcpu
  }

  memory {
    dedicated = var.memory
    swap      = var.memory_swap
  }

  disk {
    datastore_id = var.disk_storage
    size         = var.disk_size
  }

  dynamic "mount_point" {
    for_each = (var.mountpoint != null ? var.mountpoint : [])
    content {
      volume    = mount_point.value.mp_volume
      size      = mount_point.value.mp_size
      path      = mount_point.value.mp_path
      backup    = mount_point.value.mp_backup
      read_only = mount_point.value.mp_read_only
    }
  }

  started       = var.start_on_create
  start_on_boot = var.start_on_boot
  dynamic "startup" {
    for_each = (var.start_on_boot == true ? [1] : [])
    content {
      order      = var.start_order
      up_delay   = var.start_delay
      down_delay = var.shutdown_delay
    }
  }
}
