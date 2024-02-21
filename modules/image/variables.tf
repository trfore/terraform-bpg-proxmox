## Image Variables
variable "node" {
  description = "Name of Proxmox node to download image on, e.g. `pve`."
  type        = string
}

variable "image_filename" {
  description = "Filename, default `null` will extract name from URL."
  type        = string
  default     = null
}

variable "image_url" {
  description = "Image URL."
  type        = string
}

variable "image_checksum" {
  description = "Image checksum value."
  type        = string
}

variable "image_checksum_algorithm" {
  description = "Image checksum algorithm."
  type        = string
  default     = "sha256"
  validation {
    condition     = contains(["md5", "sha1", "sha224", "sha256", "sha384", "sha512"], var.image_checksum_algorithm)
    error_message = "Invalid checksum setting: ${var.image_checksum_algorithm}."
  }
}

variable "image_datastore_id" {
  description = "PVE disk location for images."
  type        = string
  default     = "local"
}

variable "image_content_type" {
  description = "File content type, `iso` for VM images or `vztmpl` for LXC images."
  type        = string
  default     = "iso"
  validation {
    condition     = contains(["iso", "vztmpl"], var.image_content_type)
    error_message = "Invalid content type: ${var.image_content_type}."
  }
}

variable "image_overwrite" {
  description = "Overwrite pre-existing image on PVE host."
  type        = bool
  default     = false
}

variable "image_upload_timeout" {
  description = "Image upload timeout in seconds."
  type        = number
  default     = 600
}
