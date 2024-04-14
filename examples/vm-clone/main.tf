terraform {
  required_version = ">=1.5.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.53.1"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pve_api_url
  api_token = "${var.pve_token_id}=${var.pve_token_secret}"
  insecure  = false
}

# Create Single VM
module "vm_minimal_config" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/vm-clone"

  node        = "pve"                   # required
  vm_id       = 100                     # required
  vm_name     = "vm-example-minimal"    # optional
  template_id = 9000                    # required
  ci_ssh_key  = "~/.ssh/id_ed25519.pub" # optional, add SSH key to "default" user
}

output "id" {
  value = module.vm_minimal_config.id
}

output "public_ipv4" {
  value = module.vm_minimal_config.public_ipv4
}

# Create Multiple VMs
module "vm_multiple_config" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/vm-clone"

  for_each = tomap({
    "vm-example-01" = {
      id       = 101
      template = 9000
    },
    "vm-example-02" = {
      id       = 102
      template = 9022
    },
  })

  node        = "pve"                   # required
  vm_id       = each.value.id           # required
  vm_name     = each.key                # optional
  template_id = each.value.template     # required
  ci_ssh_key  = "~/.ssh/id_ed25519.pub" # optional, add SSH key to "default" user
}

output "id_multiple_vms" {
  value = { for k, v in module.vm_multiple_config : k => v.id }
}

output "public_ipv4_multiple_vms" {
  value = { for k, v in module.vm_multiple_config : k => flatten(v.public_ipv4) }
}

# Create Single VM with Additional Disks
module "vm_disk_config" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/vm-clone"

  node        = "pve"                   # required
  vm_id       = 103                     # required
  vm_name     = "vm-example-disks"      # optional
  template_id = 9000                    # required
  ci_ssh_key  = "~/.ssh/id_ed25519.pub" # optional, add SSH key to "default" user
  disks = [
    {
      disk_interface = "scsi0", # default cloud image boot drive
      disk_size      = 10,
    },
    {
      disk_interface = "scsi1", # example add extra disk
      disk_size      = 4,
    },
  ]
}

# Create Single VM using UEFI
module "vm_uefi_config" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/vm-clone"

  node        = "pve"                   # required
  vm_id       = 104                     # required
  vm_name     = "vm-example-uefi"       # optional
  template_id = 9000                    # required
  bios        = "ovmf"                  # optional, set UEFI bios
  ci_ssh_key  = "~/.ssh/id_ed25519.pub" # optional, add SSH key to "default" user
}
