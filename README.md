# Terraform BPG Proxmox Modules

This repository contains modules and examples for deploying linux containers and virtual machines on [Proxmox] using
[Terraform] or [OpenTofu] with the [BPG Proxmox] provider.

## Requirements

| Name          | Version   |
| ------------- | --------- |
| [Terraform]   | >= 1.5.0  |
| [OpenTofu]    | >= 1.6.0  |
| [Proxmox]     | >= 8.0    |
| [BPG Proxmox] | >= 0.46.0 |

## Image Module

<details>
  <summary>Code Example: Download VM Images</summary>

```HCL
module "ubuntu22" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/image"

  node           = "pve"
  image_url      = "https://cloud-images.ubuntu.com/releases/22.04/release-20240207/ubuntu-22.04-server-cloudimg-amd64.img"
  image_checksum = "7eb9f1480956af75359130cd41ba24419d6fd88d3af990ea9abe97c2f9459fda"
}
```

</details>

<details>
  <summary>Code Example: Download Linux Containers</summary>

```HCL
# LXC are updated daily, set DATE and SHASUM values!
module "lxc_ubuntu22" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/image"

  node               = "pve"
  image_filename     = "ubuntu-22.04-cloudimg-amd64-<DATE>.tar.xz"
  image_url          = "https://images.linuxcontainers.org/images/ubuntu/jammy/amd64/cloud/<DATE>_07%3A42/rootfs.tar.xz"
  image_checksum     = "<SHASUM>"
  image_content_type = "vztmpl"
}
```

</details>

- The module can also be used to download multiple images and/or containers. See [`examples/image`](./examples/image/main.tf)
  for full working examples.
- See [`modules/image/README.md`](./modules/image/README.md#inputs) for a list of variables.

## LXC Container Module

<details>
  <summary>Code Example: Create A Linux Container</summary>

```HCL
module "single_lxc" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/lxc"

  node                = "pve"
  lxc_id              = 100
  lxc_name            = "lxc-example"
  description         = "terraform provisioned on ${timestamp()}"
  tags                = ["ubuntu"]
  os_template         = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  os_type             = "ubuntu"
  vcpu                = 1
  memory              = 1024
  memory_swap         = 1024
  user_ssh_key_public = "~/.ssh/id_ed25519.pub"
  vlan_tag            = "1"
  ipv4 = [
    {
      ipv4_address = "192.168.1.100/24"
      ipv4_gateway = "192.168.1.1"
    },
  ]
}
```

</details>

<details>
  <summary>Code Example: Create Multiple Linux Containers</summary>

```HCL
module "multiple_lxc" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/lxc"

  for_each = tomap({
    "lxc-example-01" = {
      id       = 101
      template = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
      os_type  = "ubuntu"
    },
    "lxc-example-02" = {
      id       = 102
      template = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
      os_type  = "ubuntu"
    },
  })

  node                = "pve"
  lxc_id              = each.value.id
  lxc_name            = each.key
  os_template         = each.value.template
  os_type             = each.value.os_type
  user_ssh_key_public = "~/.ssh/id_ed25519.pub"
}
```

</details>

- See [`examples/lxc`](./examples/lxc/main.tf) for full working
- See [`modules/lxc/README.md`](./modules/lxc/README.md#inputs) for a list of variables.
  examples.

## VM Clone Module

<details>
  <summary>Code Example: Clone A Single VM</summary>

```HCL
module "single_vm" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/vm-clone"

  node        = "pve"
  vm_id       = 100
  vm_name     = "vm-example"
  template_id = 9000
  ci_ssh_key  = "~/.ssh/id_ed25519.pub"
}
```

</details>

<details>
  <summary>Code Example: Clone Multiple VMs</summary>

```HCL
module "multiple_vm" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/vm-clone"

  for_each = tomap({
    "vm-example-01" = {
      id       = 101
      template = 9000
    },
    "vm-example-02" = {
      id       = 102
      template = 9022
    },
  })

  node        = "pve"
  vm_id       = each.value.id
  vm_name     = each.key
  template_id = each.value.template
  ci_ssh_key  = "~/.ssh/id_ed25519.pub"
}
```

</details>

- See [`examples/vm-clone`](./examples/vm-clone/main.tf) for full working examples.
- See [`modules/vm-clone/README.md`](./modules/vm-clone/README.md#inputs) for a list of variables.

## VM Template Module

<details>
  <summary>Code Example: Create VM Template</summary>

```HCL
module "ubuntu22" {
  source = "github.com/trfore/terraform-bpg-proxmox//modules/vm-template"

  node = "pve"

  # Image Variables
  image_url                = "https://cloud-images.ubuntu.com/releases/22.04/release-20240301/ubuntu-22.04-server-cloudimg-amd64.img"
  image_checksum           = "fa2146bb04e505ef9ebfaff951cfa59514593c86c6cecd79317a8487a363ebc2"
  image_checksum_algorithm = "sha256"
  image_overwrite          = false

  # VM Template Variables
  vm_id          = 9022
  vm_name        = "ubuntu22"
  description    = "Terraform generated template on ${timestamp()}"
  tags           = ["template", "ubuntu"]
}
```

</details>

- See [`examples/vm-template`](./examples/vm-template/main.tf) for full working examples.
- See [`modules/vm-template/README.md`](./modules/vm-template/README.md#inputs) for a list of variables.

## Proxmox API Token

### Permission Requirements

```sh Grant Terraform Access to Proxmox
# create role in PVE 8
pveum role add TerraformUser -privs "Datastore.Allocate \
  Datastore.AllocateSpace Datastore.AllocateTemplate \
  Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify \
  SDN.Use VM.Allocate VM.Audit VM.Clone VM.Config.CDROM \
  VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType \
  VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate \
  VM.Monitor VM.PowerMgmt User.Modify"

# create group
pveum group add terraform-users

# add permissions
pveum acl modify /sdn/zones -group terraform-users -role TerraformUser
pveum acl modify /storage -group terraform-users -role TerraformUser
pveum acl modify /vms -group terraform-users -role TerraformUser

# create user 'terraform'
pveum useradd terraform@pve -groups terraform-users

# generate a token
pveum user token add terraform@pve token -privsep 0
```

For the image and vm-template modules, downloading images on a PVE node requires `Datastore.AllocateTemplate`,
`Sys.Audit` and `Sys.Modify` permission to the root directory, `/`.

```sh
pveum acl modify / -group terraform-users -role TerraformUser
```

## License

See [LICENSE](LICENSE) for more information.

## Author

Taylor Fore (<https://github.com/trfore>)

### Additional Modules, Templates & Tools

| Github Repo                 | Description                                                            |
| --------------------------- | ---------------------------------------------------------------------- |
| [packer-proxmox-templates]  | Collection of Packer Templates for Proxmox                             |
| [proxmox-template-scripts]  | Collection of Bash Scripts to Download Images and Create PVE Templates |
| [terraform-bpg-proxmox]     | Terraform Modules for the BPG Proxmox Provider                         |
| [terraform-telmate-proxmox] | Terraform Modules for the Telmate Proxmox Provider                     |

## References

OpenTofu/Terraform:

- [GitHub: BPG/Terraform-Provider-Proxmox]

Linux Container Images:

- [Linux Containers | LXC Images](https://images.linuxcontainers.org/images/)
  - We suggesting using the cloud-init enabled images: `<DISTRO>/amd64/cloud/rootfs.tar.xz`.

Linux VM Cloud Images:

- [OpenStack: Cloud Images], collection of image links.
- [CentOS Cloud Images]
  - Default User: `centos`
  - Use `CentOS-Stream-GenericCloud-X-latest.x86_64.qcow2`
- [Debian Cloud Images]
  - Default User: `debian`
  - Use `debian-1x-generic-amd64.qcow2`
  - Avoid:
    - `genericcloud` images fail to run `cloud-init`
    - `nocloud` images do not have `cloud-init` installed and defaults to a password-less `root` user.
- [Fedora Cloud Images]
  - Default User: `fedora`
  - Use `Fedora-Cloud-Base-Generic.x86_64-XX-XX.qcow2`
- [Ubuntu Cloud Images]
  - Default User: `ubuntu`
  - Use `ubuntu-2x.04-server-cloudimg-amd64.img`

[Terraform]: https://github.com/hashicorp/terraform
[OpenTofu]: https://opentofu.org/
[Proxmox]: https://www.proxmox.com/
[BPG Proxmox]: https://github.com/bpg/terraform-provider-proxmox
[GitHub: BPG/Terraform-Provider-Proxmox]: https://github.com/bpg/terraform-provider-proxmox
[CentOS Cloud Images]: https://cloud.centos.org/
[Debian Cloud Images]: https://cloud.debian.org/images/cloud/
[Fedora Cloud Images]: https://fedoraproject.org/cloud/download
[Ubuntu Cloud Images]: https://cloud-images.ubuntu.com/releases/
[OpenStack: Cloud Images]: https://docs.openstack.org/image-guide/obtain-images.html
[packer-proxmox-templates]: https://github.com/trfore/packer-proxmox-templates
[proxmox-template-scripts]: https://github.com/trfore/proxmox-template-scripts
[terraform-bpg-proxmox]: https://github.com/trfore/terraform-bpg-proxmox
[terraform-telmate-proxmox]: https://github.com/trfore/terraform-telmate-proxmox
