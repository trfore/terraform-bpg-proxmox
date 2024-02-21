output "id" {
  description = "Instance VM ID"
  value       = proxmox_virtual_environment_vm.vm.id
}

output "public_ipv4" {
  description = "Instance Public IPv4 Address"
  value       = flatten(proxmox_virtual_environment_vm.vm.ipv4_addresses[1])
}

output "public_ipv6" {
  description = "Instance Public IPv6 Address"
  value       = flatten(proxmox_virtual_environment_vm.vm.ipv6_addresses[1])
}
