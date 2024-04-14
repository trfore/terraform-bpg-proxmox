terraform {
  required_version = ">=1.5.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.53.1"
    }
  }
}

resource "proxmox_virtual_environment_download_file" "image" {
  node_name          = var.node
  content_type       = var.image_content_type
  datastore_id       = var.image_datastore_id
  file_name          = var.image_filename
  url                = var.image_url
  checksum           = var.image_checksum
  checksum_algorithm = var.image_checksum_algorithm
  overwrite          = var.image_overwrite
  upload_timeout     = var.image_upload_timeout

  lifecycle {
    prevent_destroy = true
  }
}
