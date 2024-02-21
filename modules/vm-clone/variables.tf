## VM Variables
variable "node" {
  description = "Name of Proxmox node to provision VM on, e.g. `pve`."
  type        = string
}

variable "vm_id" {
  description = "ID number for new VM."
  type        = number
}

variable "vm_name" {
  description = "VM name, must be alphanumeric (may contain dash: `-`). Defaults to using PVE naming, e.g. 'Copy-of-VM-<template_name>'."
  type        = string
  default     = null
}

variable "description" {
  description = "VM description."
  type        = string
  default     = null
}

variable "tags" {
  description = "Proxmox tags for the VM."
  type        = list(string)
  default     = null
}

variable "template_id" {
  description = "Proxmox template ID to clone."
  type        = number
}

variable "full_clone" {
  description = "Create a full independent clone; setting to `false` will create a linked clone."
  type        = bool
  default     = true
}

variable "os_type" {
  description = "QEMU OS type, e.g. `l26` for Linux 6.x - 2.6 kernel."
  type        = string
  default     = "l26"
}

variable "bios" {
  description = "VM bios, setting to `ovmf` will automatically create a EFI disk."
  type        = string
  default     = "seabios"
  validation {
    condition     = contains(["seabios", "ovmf"], var.bios)
    error_message = "Invalid bios setting: ${var.bios}. Valid options: 'seabios' or 'ovmf'."
  }
}

variable "qemu_guest_agent" {
  description = "Enable QEMU guest agent."
  type        = bool
  default     = true
}

variable "display_type" {
  type    = string
  default = "std"
}

variable "display_memory" {
  type    = number
  default = 16
}

variable "vcpu" {
  description = "Number of CPU cores."
  type        = number
  default     = 1
}

variable "vcpu_type" {
  description = "CPU type."
  type        = string
  default     = "host"
}

variable "memory" {
  description = "Memory size in `MiB`."
  type        = number
  default     = 1024
}

variable "memory_floating" {
  description = "Minimum memory size in `MiB`, setting this value enables memory ballooning."
  type        = number
  default     = 1024
}

### Disk Variables
variable "scsihw" {
  description = "Storage controller, e.g. `virtio-scsi-pci`."
  type        = string
  default     = "virtio-scsi-pci"
}

variable "disks" {
  type = list(object({
    disk_storage   = optional(string, "local-lvm")
    disk_interface = optional(string, "scsi0")
    disk_size      = optional(number, 8)
    disk_format    = optional(string, "raw")
    disk_cache     = optional(string, "writeback")
    disk_iothread  = optional(bool, false)
    disk_ssd       = optional(bool, true)
    disk_discard   = optional(string, "on")
    }
  ))
  default = [{
    disk_storage   = "local-lvm"
    disk_interface = "scsi0"
    disk_size      = 8
    disk_format    = "raw"
    disk_cache     = "writeback"
    disk_iothread  = false
    disk_ssd       = true
    disk_discard   = "on"
  }]
}

variable "efi_disk_storage" {
  description = "EFI disk storage location."
  type        = string
  default     = "local-lvm"
}

variable "efi_disk_format" {
  description = "EFI disk storage format."
  type        = string
  default     = "raw"
}

variable "efi_disk_type" {
  description = "EFI disk OVMF firmware version."
  type        = string
  default     = "4m"
}

variable "efi_disk_pre_enrolled_keys" {
  description = "EFI disk enable pre-enrolled secure boot keys."
  type        = bool
  default     = true
}

### Network Variables
variable "vnic_model" {
  description = "Networking adapter model, e.g. `virtio`."
  type        = string
  default     = "virtio"
}

variable "vnic_bridge" {
  description = "Networking adapter bridge, e.g. `vmbr0`."
  type        = string
  default     = "vmbr0"
}

variable "vlan_tag" {
  description = "Networking adapter VLAN tag."
  type        = string
  default     = "1"
}

### Cloud-init Variables
variable "ci_user" {
  description = "Cloud-init 'default' user."
  type        = string
  default     = null
}

variable "ci_ssh_key" {
  description = "File path to SSH key for 'default' user, e.g. `~/.ssh/id_ed25519.pub`."
  type        = string
  default     = null
}

variable "ci_dns_domain" {
  description = "DNS domain name, e.g. `example.com`. Default `null` value will use PVE host settings."
  type        = string
  default     = null
}

variable "ci_dns_server" {
  description = "DNS server, e.g. `192.168.1.1`. Default `null` value will use PVE host settings."
  type        = string
  default     = null
}

variable "ci_ipv4_cidr" {
  description = "Default uses DHCP, for a static address set CIDR, e.g. `192.168.1.254/24`."
  type        = string
  default     = "dhcp"
}

variable "ci_ipv4_gateway" {
  description = "Default `null` will use `DHCP`, for a static address add IP, e.g. `192.168.1.1`."
  type        = string
  default     = null
}

variable "ci_meta_data" {
  description = "Add a custom cloud-init `meta` configuration file, e.g `local:snippets/meta-data.yaml`."
  type        = string
  default     = null
}

variable "ci_network_data" {
  description = "Add a custom cloud-init `network` configuration file, e.g `local:snippets/network-data.yaml`."
  type        = string
  default     = null
}

variable "ci_user_data" {
  description = "Add a custom cloud-init `user` configuration file, e.g `local:snippets/user-data.yaml`."
  type        = string
  default     = null
}

variable "ci_vendor_data" {
  description = "Add a custom cloud-init `vendor` configuration file, e.g `local:snippets/vendor-data.yaml`."
  type        = string
  default     = null
}
