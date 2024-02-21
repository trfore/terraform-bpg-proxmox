# BPG Proxmox VM Template Module

## Requirements

| Name        | Version  |
| ----------- | -------- |
| [terraform] | >= 1.5.0 |

### PVE Permissions

- Downloading image on a PVE node requires `Datastore.AllocateTemplate`, `Sys.Audit` and `Sys.Modify` permission to the
  root directory, `/`.

## Providers

| Name          | Version   |
| ------------- | --------- |
| [bpg proxmox] | >= 0.46.0 |

## Inputs

### Template Variables

| Variable         | Default   | Type         | Description                                                                               | Required |
| ---------------- | --------- | ------------ | ----------------------------------------------------------------------------------------- | -------- |
| node             |           | String       | Name of Proxmox node to download the image and provision VM on, e.g. `pve`                | **Yes**  |
| vm_id            |           | Number       | ID number for new VM                                                                      | **Yes**  |
| vm_name          | `null`    | String       | Name, must be alphanumeric (may contain dash: `-`). Defaults to PVE naming, `VM <VM_ID>`. | no       |
| description      | `null`    | String       | VM description                                                                            | no       |
| tags             | `null`    | List(String) | Proxmox tags for the VM                                                                   | no       |
| bios             | `seabios` | String       | VM bios, setting to `ovmf` will automatically create a EFI disk                           | no       |
| qemu_guest_agent | `true`    | Boolean      | Enable QEMU guest agent                                                                   | no       |
| machine_type     | `q35`     | String       | Hardware layout for the VM, `q35` or `x440i`.                                             | no       |
| vcpu             | `1`       | Number       | Number of CPU cores                                                                       | no       |
| vcpu_type        | `host`    | String       | CPU type                                                                                  | no       |
| memory           | `1024`    | Number       | Memory size in `MiB`                                                                      | no       |
| memory_floating  | `1024`    | Number       | Minimum memory size in `MiB`, setting this value enables memory ballooning                | no       |

### Disk Variables

| Variable                   | Default     | Type    | Description                                   | Required |
| -------------------------- | ----------- | ------- | --------------------------------------------- | -------- |
| efi_disk_storage           | `local-lvm` | String  | EFI disk storage location                     | no       |
| efi_disk_format            | `raw`       | String  | EFI disk storage format                       | no       |
| efi_disk_type              | `4m`        | String  | EFI disk OVMF firmware version                | no       |
| efi_disk_pre_enrolled_keys | `true`      | Boolean | EFI disk enable pre-enrolled secure boot keys | no       |
| disk_storage               | `local-lvm` | String  | Disk storage location                         | no       |
| disk_interface             | `scsi0`     | String  | Disk storage interface                        | no       |
| disk_size                  | `8`         | Number  | Disk size                                     | no       |
| disk_format                | `raw`       | String  | Disk format                                   | no       |
| disk_cache                 | `writeback` | String  | Disk cache                                    | no       |
| disk_iothread              | `false`     | Boolean | Enable IO threading                           | no       |
| disk_ssd                   | `true`      | Boolean | Enable SSD emulation                          | no       |
| disk_discard               | `on`        | String  | Enable TRIM                                   | no       |

### Image Variables

| Variable                 | Default  | Type    | Description                                         | Required |
| ------------------------ | -------- | ------- | --------------------------------------------------- | -------- |
| image_filename           | `null`   | String  | Filename, default `null` will extract name from URL | no       |
| image_url                |          | String  | Image URL                                           | **Yes**  |
| image_checksum           |          | String  | Image checksum value                                | **Yes**  |
| image_checksum_algorithm | `sha256` | String  | Image checksum algorithm                            | no       |
| image_datastore_id       | `local`  | String  | PVE disk location for images                        | no       |
| image_content_type       | `iso`    | String  | PVE folder name for images                          | no       |
| image_overwrite          | `false`  | Boolean | Overwrite pre-existing image on PVE host            | no       |
| image_upload_timeout     | `600`    | Number  | Image upload timeout in seconds                     | no       |

### Cloud-init Variables

| Variable           | Default   | Type   | Description                                                                                  | Required |
| ------------------ | --------- | ------ | -------------------------------------------------------------------------------------------- | -------- |
| ci_interface       | `ide2`    | String | Hardware interface for cloud-init configuration data                                         | no       |
| ci_datasource_type | `nocloud` | String | Type of cloud-init datasource                                                                | no       |
| ci_meta_data       | `null`    | String | Add a custom cloud-init `meta` configuration file, e.g `local:snippets/meta-data.yaml`       | no       |
| ci_network_data    | `null`    | String | Add a custom cloud-init `network` configuration file, e.g `local:snippets/network-data.yaml` | no       |
| ci_user_data       | `null`    | String | Add a custom cloud-init `user` configuration file, e.g `local:snippets/user-data.yaml`       | no       |
| ci_vendor_data     | `null`    | String | Add a custom cloud-init `vendor` configuration file, e.g `local:snippets/vendor-data.yaml`   | no       |

## Examples

- [See example Template configurations](../../examples/vm-template/main.tf)

## CLI Commands

Downloaded images are protected from deletion, so calling `terraform destroy` will fail. To delete a specific template
use the example below:

```sh
# remove vm template
terraform destroy -target='module.ubuntu22.proxmox_virtual_environment_vm.vm_template'
```

[terraform]: https://github.com/hashicorp/terraform
[bpg proxmox]: https://github.com/bpg/terraform-provider-proxmox
