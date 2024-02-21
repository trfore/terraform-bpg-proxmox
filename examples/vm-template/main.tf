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
  ssh {
    agent       = true
    username    = var.pve_user
    password    = var.pve_password
    private_key = var.pve_ssh_key_private
  }
}

# Create a custom cloud-init config using BPG provider
resource "proxmox_virtual_environment_file" "cloud_vendor_config" {
  node_name    = "pve"
  datastore_id = "local"
  content_type = "snippets"

  source_raw {
    file_name = "vendor-data.yaml"
    data      = <<-EOF
      #cloud-config
      packages:
        - qemu-guest-agent
      package_update: true
      power_state:
        mode: reboot
        timeout: 30
      EOF
  }

  lifecycle {
    prevent_destroy = true
  }
}

module "ubuntu22" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/vm-template"

  node = "pve" # Required

  # Image Variables
  image_url                = "https://cloud-images.ubuntu.com/releases/22.04/release-20240207/ubuntu-22.04-server-cloudimg-amd64.img" # Required
  image_checksum           = "7eb9f1480956af75359130cd41ba24419d6fd88d3af990ea9abe97c2f9459fda"                                       # Required
  image_checksum_algorithm = "sha256"                                                                                                 # Optional
  image_overwrite          = false                                                                                                    # Optional

  # VM Template Variables
  vm_id          = 9022                                             # Required
  vm_name        = "ubuntu22"                                       # Optional
  description    = "Terraform generated template on ${timestamp()}" # Optional
  tags           = ["terraform", "template", "ubuntu"]              # Optional
  ci_vendor_data = "local:snippets/vendor-data.yaml"                # Optional
}

module "debian12" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/vm-template"

  node = "pve"

  # Image Variables
  image_filename           = "debian-12-generic-amd64.img" # Convert *.qcow2 image to *.img
  image_url                = "https://cloud.debian.org/images/cloud/bookworm/20240211-1654/debian-12-generic-amd64-20240211-1654.qcow2"
  image_checksum           = "b679398972ba45a60574d9202c4f97ea647dd3577e857407138b73b71a3c3c039804e40aac2f877f3969676b6c8a1ebdb4f2d67a4efa6301c21e349e37d43ef5"
  image_checksum_algorithm = "sha512"
  image_overwrite          = false

  # VM Template Variables
  vm_id          = 9012
  vm_name        = "debian12"
  description    = "Terraform generated template on ${timestamp()}"
  tags           = ["terraform", "template", "debian"]
  ci_vendor_data = "local:snippets/vendor-data.yaml"
}
