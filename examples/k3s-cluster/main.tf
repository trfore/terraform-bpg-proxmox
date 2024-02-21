terraform {
  required_version = ">=1.5.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.46.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pve_api_url
  api_token = "${var.pve_token_id}=${var.pve_token_secret}"
  insecure  = false
}

resource "null_resource" "cloud_init" {
  connection {
    host        = var.pve_host_address
    port        = var.pve_host_port
    user        = var.pve_user
    password    = var.pve_password
    private_key = file(var.pve_ssh_key_private)
  }

  provisioner "file" {
    content     = file("${path.module}/files/vendor-data.yaml")
    destination = "/var/lib/vz/snippets/vendor-data.yaml"
  }
}

module "k3s_cluster" {
  depends_on = [null_resource.cloud_init]
  source     = "github.com/trfore/terraform-bpg-proxmox//modules/vm-clone"

  for_each = tomap({
    "k3s-controller" = {
      id           = 210
      ipv4_cidr    = "192.168.1.210/24"
      ipv4_gateway = "192.168.1.1"
    },
    "k3s-node1" = {
      id           = 211
      ipv4_cidr    = null # use DHCP
      ipv4_gateway = null # use DHCP
    },
    "k3s-node2" = {
      id           = 212
      ipv4_cidr    = null
      ipv4_gateway = null
    },
  })

  node            = "pve"                             # required
  vm_id           = each.value.id                     # required
  vm_name         = each.key                          # optional
  template_id     = 9000                              # required
  vcpu            = 2                                 # optional
  memory          = 4096                              # optional
  ci_ssh_key      = "~/.ssh/id_ed25519.pub"           # optional, add SSH key to "default" user
  ci_ipv4_cidr    = each.value.ipv4_cidr              # optional
  ci_ipv4_gateway = each.value.ipv4_gateway           # optional
  ci_vendor_data  = "local:snippets/vendor-data.yaml" # optional
}

locals {
  controller_ip = module.k3s_cluster["k3s-controller"].public_ipv4[0]
  agent_ips     = { for k, v in module.k3s_cluster : k => v.public_ipv4[0] if k != "k3s-controller" }
}

output "id" {
  value = { for k, v in module.k3s_cluster : k => v.id }
}

output "public_ipv4" {
  value = { for k, v in module.k3s_cluster : k => v.public_ipv4[0] }
}

output "controller_node_ip" {
  value = local.controller_ip
}

output "agent_node_ips" {
  value = local.agent_ips
}

resource "random_string" "k3s_token" {
  length  = 64
  special = false
}

resource "null_resource" "controller" {
  connection {
    host = local.controller_ip
    user = "ubuntu"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | K3S_TOKEN=${random_string.k3s_token.result} sh -"
    ]
  }
}

resource "null_resource" "agents" {
  for_each = local.agent_ips

  connection {
    host = each.value
    user = "ubuntu"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | K3S_URL=https://${local.controller_ip}:6443 K3S_TOKEN=${random_string.k3s_token.result} sh -"
    ]
  }
}
