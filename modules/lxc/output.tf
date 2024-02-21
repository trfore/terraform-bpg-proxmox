output "id" {
  description = "Container ID"
  value       = proxmox_virtual_environment_container.lxc.id
}

output "mac_address" {
  description = "Container MAC Address"
  value       = proxmox_virtual_environment_container.lxc.network_interface.*.mac_address[0]
}
