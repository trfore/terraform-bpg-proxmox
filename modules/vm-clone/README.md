# Proxmox VM Clone Module

## Requirements

| Name        | Version  |
| ----------- | -------- |
| [terraform] | >= 1.5.0 |

## Providers

| Name          | Version   |
| ------------- | --------- |
| [bpg proxmox] | >= 0.53.1 |

## Inputs

### VM Variables

| Variable                   | Default           | Type         | Description                                                                    | Required |
| -------------------------- | ----------------- | ------------ | ------------------------------------------------------------------------------ | -------- |
| node                       |                   | String       | Name of Proxmox node to provision VM on, e.g. `pve`                            | **Yes**  |
| template_node              | `null`            | String       | Name of Proxmox node where the template resides, e.g. `pve`                    | no       |
| vm_id                      |                   | Number       | ID number for new VM                                                           | **Yes**  |
| vm_name                    | `null`            | String       | Defaults to using PVE naming, e.g. `Copy-of-VM-<template_name>`                | no       |
| description                | `null`            | String       | VM description                                                                 | no       |
| tags                       | `null`            | List(String) | Proxmox tags                                                                   | no       |
| template_id                |                   | Number       | Proxmox template ID to clone                                                   | **Yes**  |
| full_clone                 | `true`            | Boolean      | Create a full independent clone; setting to `false` will create a linked clone | no       |
| os_type                    | `l26`             | String       | QEMU OS type, e.g. `l26` for Linux 6.x - 2.6 kernel                            | no       |
| bios                       | `seabios`         | String       | VM bios, setting to `ovmf` will automatically create a EFI disk                | no       |
| machine                    | `q35`             | String       | QEMU machine type, e.g. `q35`                                                  | no       |
| qemu_guest_agent           | `true`            | Boolean      | Enable QEMU guest agent                                                        | no       |
| tablet                     | `false`           | Boolean      | Enable tablet for pointer                                                      | no       |
| display_type               | `std`             | String       |                                                                                | no       |
| display_memory             | `16`              | Number       |                                                                                | no       |
| vcpu                       | `1`               | Number       | Number of CPU cores                                                            | no       |
| vcpu_type                  | `host`            | String       | CPU type                                                                       | no       |
| memory                     | `1024`            | Number       | Memory size in `MiB`                                                           | no       |
| memory_floating            | `1024`            | Number       | Minimum memory size in `MiB`, setting this value enables memory ballooning     | no       |
| numa                       | `false`           | Boolean      | Emulate NUMA architecture                                                      | no       |
| numa_device                | `null`            | String       | Required if `numa=true`                                                        | Yes\*    |
| numa_cpus                  | `null`            | String       | Required if `numa=true`                                                        | Yes\*    |
| numa_memory                | `null`            | Number       | Required if `numa=true`                                                        | Yes\*    |
| numa_hostnodes             | `null`            | String       |                                                                                | no       |
| numa_policy                | `preferred`       | String       |                                                                                | no       |
| scsihw                     | `virtio-scsi-pci` | String       | Storage controller, e.g. `virtio-scsi-pci`                                     | no       |
| efi_disk_storage           | `local-lvm`       | String       | EFI disk storage location                                                      | no       |
| efi_disk_format            | `raw`             | String       | EFI disk storage format                                                        | no       |
| efi_disk_type              | `4m`              | String       | EFI disk OVMF firmware version                                                 | no       |
| efi_disk_pre_enrolled_keys | `true`            | Boolean      | EFI disk enable pre-enrolled secure boot keys                                  | no       |
| disks                      | See Below         | List(Object) | See [disks variables](#disks-variables) below                                  | no       |
| vnic_model                 | `virtio`          | String       | Networking adapter model, e.g. `virtio`                                        | no       |
| vnic_bridge                | `vmbr0`           | String       | Networking adapter bridge, e.g. `vmbr0`                                        | no       |
| vlan_tag                   | `null`               | Number       | Networking adapter VLAN tag                                                    | no       |

### Disks Variables

| Variable       | Default     | Type    | Description            | Required |
| -------------- | ----------- | ------- | ---------------------- | -------- |
| disk_storage   | `local-lvm` | String  | Disk storage location  | no       |
| disk_interface | `scsi0`     | String  | Disk storage interface | no       |
| disk_size      | `8`         | Number  | Disk size              | no       |
| disk_format    | `raw`       | String  | Disk format            | no       |
| disk_cache     | `writeback` | String  | Disk cache             | no       |
| disk_iothread  | `false`     | Boolean | Enable IO threading    | no       |
| disk_ssd       | `true`      | Boolean | Enable SSD emulation   | no       |
| disk_discard   | `on`        | String  | Enable TRIM            | no       |

### Cloud-init Variables

| Variable        | Default     | Type   | Description                                                                                  | Required |
| --------------- | ----------- | ------ | -------------------------------------------------------------------------------------------- | -------- |
| ci_user         | `null`      | String | Cloud-init 'default' user                                                                    | no       |
| ci_ssh_key      | `null`      | String | File path to SSH key for 'default' user, e.g. `~/.ssh/id_ed25519.pub`                        | no       |
| ci_dns_domain   | `null`      | String | DNS domain name, e.g. `example.com`. Default `null` value will use PVE host settings         | no       |
| ci_dns_server   | `null`      | String | DNS server, e.g. `192.168.1.1`. Default `null` value will use PVE host settings              | no       |
| ci_ipv4_cidr    | `dhcp`      | String | Default uses DHCP, for a static address set CIDR, e.g. `192.168.1.254/24`                    | no       |
| ci_ipv4_gateway | `null`      | String | Default `null` will use `DHCP`, for a static address add IP, e.g. `192.168.1.1`              | no       |
| ci_datastore_id | `local-lvm` | String | Disk storage location for the cloud-init disk.                                               | no       |
| ci_meta_data    | `null`      | String | Add a custom cloud-init `meta` configuration file, e.g `local:snippets/meta-data.yaml`       | no       |
| ci_network_data | `null`      | String | Add a custom cloud-init `network` configuration file, e.g `local:snippets/network-data.yaml` | no       |
| ci_user_data    | `null`      | String | Add a custom cloud-init `user` configuration file, e.g `local:snippets/user-data.yaml`       | no       |
| ci_vendor_data  | `null`      | String | Add a custom cloud-init `vendor` configuration file, e.g `local:snippets/vendor-data.yaml`   | no       |

## Outputs

| Name          | Description                  |
| ------------- | ---------------------------- |
| `id`          | Instance VM ID               |
| `public_ipv4` | Instance Public IPv4 Address |
| `public_ipv6` | Instance Public IPv6 Address |

## Examples

- [See example VM configurations](../../examples/vm-clone/main.tf)

[terraform]: https://github.com/hashicorp/terraform
[bpg proxmox]: https://github.com/bpg/terraform-provider-proxmox
