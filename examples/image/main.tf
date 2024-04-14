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
  ssh {
    agent       = true
    username    = var.pve_user
    password    = var.pve_password
    private_key = var.pve_ssh_key_private
  }
}

# VM Image: Convert *.qcow2 image to *.img
module "debian12" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/image"

  node                     = "pve"
  image_filename           = "debian-12-generic-amd64.img"
  image_url                = "https://cloud.debian.org/images/cloud/bookworm/20240211-1654/debian-12-generic-amd64-20240211-1654.qcow2"
  image_checksum           = "b679398972ba45a60574d9202c4f97ea647dd3577e857407138b73b71a3c3c039804e40aac2f877f3969676b6c8a1ebdb4f2d67a4efa6301c21e349e37d43ef5"
  image_checksum_algorithm = "sha512"
}

# VM Image: Minimal configuration
module "ubuntu22" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/image"

  node           = "pve"
  image_url      = "https://cloud-images.ubuntu.com/releases/22.04/release-20240207/ubuntu-22.04-server-cloudimg-amd64.img"
  image_checksum = "7eb9f1480956af75359130cd41ba24419d6fd88d3af990ea9abe97c2f9459fda"
}

# LXC: Container images are updated daily, set DATE and SHASUM values!
module "lxc_ubuntu22" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/image"

  node               = "pve"
  image_filename     = "ubuntu-22.04-cloudimg-amd64-<DATE>.tar.xz"
  image_url          = "https://images.linuxcontainers.org/images/ubuntu/jammy/amd64/cloud/<DATE>_07%3A42/rootfs.tar.xz"
  image_checksum     = "<SHASUM>"
  image_content_type = "vztmpl"
}
