## Image Variables
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
  description = "PVE folder name for images."
  type        = string
  default     = "iso"
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
  description = "Name, must be alphanumeric (may contain dash: `-`). Defaults to PVE naming, `VM <VM_ID>`."
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

variable "machine_type" {
  description = "Hardware layout for the VM, `q35` or `x440i`."
  type        = string
  default     = "q35"
  validation {
    condition     = contains(["q35", "x440i"], var.machine_type)
    error_message = "Unknown machine setting."
  }
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

## Disk Variables
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

variable "disk_storage" {
  description = "Disk storage location."
  type        = string
  default     = "local-lvm"
}

variable "disk_interface" {
  description = "Disk storage interface."
  type        = string
  default     = "scsi0"
}

variable "disk_size" {
  type    = number
  default = 8
}

variable "disk_format" {
  type    = string
  default = "raw"
}

variable "disk_cache" {
  type    = string
  default = "writeback"
}

variable "disk_iothread" {
  description = "Enable IO threading."
  type        = bool
  default     = false
}

variable "disk_ssd" {
  description = "Enable SSD emulation."
  type        = bool
  default     = true
}

variable "disk_discard" {
  description = "Enable TRIM."
  type        = string
  default     = "on"
}

## Cloud-init Variables
variable "ci_interface" {
  description = "Hardware interface for cloud-init configuration data."
  type        = string
  default     = "ide2"
}

variable "ci_datasource_type" {
  description = "Type of cloud-init datasource."
  type        = string
  default     = "nocloud"
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
