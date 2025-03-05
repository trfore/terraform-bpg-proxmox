# Contributing

## Contribute

- [Fork the repository](https://github.com/trfore/terraform-bpg-proxmox/fork) on github and clone it.
- Create a new branch and add your code.
- Test your changes locally on your PVE cluster.
- Push the changes to your fork and submit a pull-request on github.

```sh
git clone https://github.com/USERNAME/terraform-bpg-proxmox && cd terraform-bpg-proxmox
git checkout -b MY_BRANCH
# add code and test
git push -u origin MY_BRANCH
gh pr create --title 'feature: add ...'
```

### Testing

- Duplicate the [examples](./examples) folder with the name `examples.private`.
  - The [.gitignore](.gitignore) excludes all files and folders with the `*.private` extension.
- Change into the new directory, ex: `cd example.private/vm-clone`
- Set the modules source to the local file system `source = "../../modules/vm-clone"`
  - Find and replace `github.com/trfore/terraform-bpg-proxmox/` with `../..`
- Modify the example code as required for your cluster.

  - Add an `proxmox.tfvars` file to the folder with your cluster variables or use environment vars.

    ```HCL
    # proxmox.tfvars
    pve_api_url      = "https://pve.example.com/api2/json"
    pve_token_id     = "terraform@pam!MYTOKEN"
    pve_token_secret = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    ```

- Run terraform

  ```bash
  terraform init

  # test all module configurations
  terraform apply -var-file proxmox.tfvars

  # OR target specific module configuration
  terraform apply -var-file proxmox.tfvars -target 'module.vm_minimal_config'

  # revert the changes on your cluster
  terraform destroy -var-file proxmox.tfvars -target 'module.vm_minimal_config'
  ```

  <details>
    <summary>Terraform: Deploy Single VM on Configuration with Multiple VMs</summary>

  ```bash
  terraform apply -var-file proxmox.tfvars -target 'module.vm_multiple_config["vm-example-02"]'

  terraform destroy -var-file proxmox.tfvars -target 'module.vm_multiple_config["vm-example-02"]'
  ```

  </details>

- Review the changes to your PVE cluster.
- If applicable or with large/breaking changes, add universal code example(s) to the [examples](./examples) folder.

## Additional References

- [Github Docs: Forking a repository](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo#forking-a-repository)
