## Provider Login Variables
variable "pve_token_id" {
  description = "Proxmox API token name."
  sensitive   = true
}

variable "pve_token_secret" {
  description = "Proxmox API token value."
  sensitive   = true
}

variable "pve_api_url" {
  description = "Proxmox API endpoint, e.g. 'https://pve.example.com/api2/json'"
  type        = string
  sensitive   = true
  validation {
    condition     = can(regex("(?i)^http[s]?://.*/api2/json$", var.pve_api_url))
    error_message = "Proxmox API Endpoint Invalid. Check URL - Scheme and Path required."
  }
}

## Proxmox SSH Variables
variable "pve_host_address" {
  description = "Proxmox host address, e.g. '192.168.1.100' or 'https://pve.example.com/'"
  type        = string
  sensitive   = true
}

variable "pve_host_port" {
  description = "Proxmox host SSH port"
  type        = string
  sensitive   = true
  default     = "22"
}

variable "pve_user" {
  description = "Proxmox username"
  type        = string
  sensitive   = true
}

variable "pve_password" {
  description = "Proxmox password for SSH"
  type        = string
  sensitive   = true
  default     = null
}

variable "pve_ssh_key_private" {
  description = "File path to private SSH key for PVE - overrides 'pve_password'"
  type        = string
  sensitive   = true
  default     = null
}
