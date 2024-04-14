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
  insecure  = true
}

# Create Single LXC
module "lxc_minimal_config" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/lxc"

  node                = "pve"                                                      # Required
  lxc_id              = 100                                                        # Required
  os_template         = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst" # Required
  os_type             = "ubuntu"                                                   # Optional, recommended
  user_ssh_key_public = "~/.ssh/id_ed25519.pub"                                    # Optional, recommended
}

output "id" {
  value = module.lxc_minimal_config.id
}

output "mac_address" {
  value = module.lxc_minimal_config.mac_address
}

# Create Multiple LXC
module "lxc_multiple_config" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/lxc"

  for_each = tomap({
    "lxc-example-01" = {
      id       = 101
      template = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
      os_type  = "ubuntu"
    },
    "lxc-example-02" = {
      id       = 102
      template = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
      os_type  = "ubuntu"
    },
  })

  node                = "pve"                   # Required
  lxc_id              = each.value.id           # Required
  lxc_name            = each.key                # Optional
  os_template         = each.value.template     # Required
  os_type             = each.value.os_type      # Optional, recommended
  user_ssh_key_public = "~/.ssh/id_ed25519.pub" # Optional, recommended
}

output "id_multiple_lxcs" {
  value = { for k, v in module.lxc_multiple_config : k => v.id }
}

output "mac_address_multiple_lxcs" {
  value = { for k, v in module.lxc_multiple_config : k => v.mac_address }
}

# Create Single LXC with Static IP Address
module "lxc_static_ip_config" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/lxc"

  node                = "pve"                                                      # Required
  lxc_id              = 103                                                        # Required
  lxc_name            = "lxc-example-static-ip"                                    # Optional
  description         = "terraform provisioned on ${timestamp()}"                  # Optional
  os_template         = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst" # Required
  os_type             = "ubuntu"                                                   # Optional, recommended
  user_ssh_key_public = "~/.ssh/id_ed25519.pub"                                    # Optional, recommended
  vlan_tag            = "1"                                                        # Optional, recommended
  ipv4 = [
    {
      ipv4_address = "192.168.1.103/24"
      ipv4_gateway = "192.168.1.1"
    },
  ]
}

# Create Single LXC with Additional Mountpoints
module "lxc_mountpoint_config" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/lxc"

  node                = "pve"                                                      # Required
  lxc_id              = 104                                                        # Required
  lxc_name            = "lxc-example-mountpoints"                                  # Optional
  os_template         = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst" # Required
  os_type             = "ubuntu"                                                   # Optional, recommended
  user_ssh_key_public = "~/.ssh/id_ed25519.pub"                                    # Optional, recommended
  mountpoint = [
    {
      mp_volume = "local-lvm"
      mp_size   = "4G"
      mp_path   = "/mnt/local"
      mp_backup = true
    },
    {
      mp_volume    = "local-lvm"
      mp_size      = "4G"
      mp_path      = "/mnt/configs"
      mp_read_only = true
    }
  ]
}
