# BPG Proxmox Image Module

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
| [bpg proxmox] | >= 0.53.1 |

## Inputs

### Image Variables

| Variable                 | Default  | Type    | Description                                                                | Required |
| ------------------------ | -------- | ------- | -------------------------------------------------------------------------- | -------- |
| node                     |          | String  | Name of Proxmox node to download the image and provision VM on, e.g. `pve` | **Yes**  |
| image_filename           | `null`   | String  | Filename, default `null` will extract name from URL                        | no       |
| image_url                |          | String  | Image URL                                                                  | **Yes**  |
| image_checksum           |          | String  | Image checksum value                                                       | **Yes**  |
| image_checksum_algorithm | `sha256` | String  | Image checksum algorithm                                                   | no       |
| image_datastore_id       | `local`  | String  | PVE disk location for images                                               | no       |
| image_content_type       | `iso`    | String  | File content type, `iso` for VM images or `vztmpl` for LXC images          | no       |
| image_overwrite          | `false`  | Boolean | Overwrite pre-existing image on PVE host                                   | no       |
| image_upload_timeout     | `600`    | Number  | Image upload timeout in seconds                                            | no       |

## Outputs

| Name | Description |
| ---- | ----------- |
| `id` | File ID     |

## Examples

- [See example Template configurations](../../examples/image/main.tf)

## Links

- [Linux Containers | LXC Images](https://images.linuxcontainers.org/images/)
  - We suggesting using the cloud-init enabled images: `<DISTRO>/amd64/cloud/rootfs.tar.xz`.

[terraform]: https://github.com/hashicorp/terraform
[bpg proxmox]: https://github.com/bpg/terraform-provider-proxmox
