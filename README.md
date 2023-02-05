<!-- BEGIN_TF_DOCS -->

# Azure Linux/Windows Virtual Machine and Diagnostic Setting module
Managed disk is optional

## Examples
```hcl
module "workspoke_virtual_machine" {
  source = "./modules/compute/virtual_machine"

  vm_name                    = "brumer-final-terraform-workspoke-vm"
  resource_group_name        = "brumer-final-terraform-workspoke"
  location                   = "West Europe"
  subnet_id                  = "/subscriptions/d94fe338-52d8-4a44-acd4-4f8301adf2cf/resourceGroups/brumer-final-terraform-workspoke-rg/providers/Microsoft.Network/virtualNetworks/brumer-final-terraform-workspoke-vnet/subnets/MainSubnet"
  computer_name              = "brumer"
  admin_username             = "brumer"
  log_analytics_workspace_id = "/subscriptions/d94fe338-52d8-4a44-acd4-4f8301adf2cf/resourcegroups/brumer-final-terraform-hub-rg/providers/microsoft.operationalinsights/workspaces/brumer-final-terraform-hub-log-analytics"
}
```

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Id of vm. |
| <a name="output_name"></a> [name](#output\_name) | Name of vm. |
| <a name="output_nic_id"></a> [nic\_id](#output\_nic\_id) | Id of nic. |
| <a name="output_nic_name"></a> [nic\_name](#output\_nic\_name) | Name of nic. |
| <a name="output_nic_object"></a> [nic\_object](#output\_nic\_object) | Object of nic. |
| <a name="output_nic_private_ip"></a> [nic\_private\_ip](#output\_nic\_private\_ip) | Private ip address of the vm nic. |
| <a name="output_object"></a> [object](#output\_object) | Object of vm. |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | Principal id of vm. |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | (Optional)(Optional for Windows, Optional for Linux)The password associated with the local administrator account. | `string` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | (Required)Specifies the name of the local administrator account. | `string` | n/a | yes |
| <a name="input_computer_name"></a> [computer\_name](#input\_computer\_name) | (Required)Specifies the name of the Virtual Machine. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required)The location to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required)A container that holds related resources for an Azure solution. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required)ID of VM's subnet. | `string` | n/a | yes |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | (Required)Name of Virtual Machine. | `string` | n/a | yes |
| <a name="input_admin_ssh_key_public_key_file"></a> [admin\_ssh\_key\_public\_key\_file](#input\_admin\_ssh\_key\_public\_key\_file) | (Optional)SSH private key. | `string` | `null` | no |
| <a name="input_enable_accelerated_networking"></a> [enable\_accelerated\_networking](#input\_enable\_accelerated\_networking) | (Optional)Should Accelerated Networking be enabled? Defaults to `false`. | `bool` | `false` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | (Optional)Specifies a list of User Assigned Managed Identity IDs to be assigned to this Virtual Machine. | `list(string)` | `null` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | (Optional)The type of identity used for the managed cluster. Conflict with `client_id` and `client_secret`. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`(to enable both). If `UserAssigned` or `SystemAssigned, UserAssigned` is set, an `identity_ids` must be set as well. | `string` | `"SystemAssigned"` | no |
| <a name="input_image_reference"></a> [image\_reference](#input\_image\_reference) | (Optional)This block provisions the Virtual Machine from one of two sources: an Azure Platform Image (e.g. Ubuntu/Windows Server) or a Custom Image. | <pre>map(object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  }))</pre> | <pre>{<br>  "linux": {<br>    "offer": "UbuntuServer",<br>    "publisher": "Canonical",<br>    "sku": "16.04-LTS",<br>    "version": "latest"<br>  },<br>  "windows": {<br>    "offer": "WindowsServer",<br>    "publisher": "MicrosoftWindowsServer",<br>    "sku": "2016-Datacenter",<br>    "version": "latest"<br>  }<br>}</pre> | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | (Required)Log analytics workspace id to send logs from the current resource. | `string` | `null` | no |
| <a name="input_os_disk_caching"></a> [os\_disk\_caching](#input\_os\_disk\_caching) | (Optional)Specifies the caching requirements for the OS Disk. | `string` | `"ReadWrite"` | no |
| <a name="input_os_disk_create_option"></a> [os\_disk\_create\_option](#input\_os\_disk\_create\_option) | (Required)Storage OS disk create option. | `string` | `"FromImage"` | no |
| <a name="input_os_disk_managed_disk_type"></a> [os\_disk\_managed\_disk\_type](#input\_os\_disk\_managed\_disk\_type) | (Optional)The Type of Storage Account which should back this the Internal OS Disk. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`. | `string` | `"Standard_LRS"` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | (Optional)Specifies the Operating System on the OS Disk. Possible values are Linux and Windows. | `string` | `"linux"` | no |
| <a name="input_private_ip_allocation"></a> [private\_ip\_allocation](#input\_private\_ip\_allocation) | (Optional)Private IP Allocation's type. | `string` | `"Dynamic"` | no |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | (Optional)Role assignments for the log analytics | <pre>map(object({<br>    principal_id         = string<br>    role_definition_name = string<br>    scope                = string<br>  }))</pre> | `{}` | no |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | (Optional)SSH private key. | `string` | `null` | no |
| <a name="input_storage_data_disk_config"></a> [storage\_data\_disk\_config](#input\_storage\_data\_disk\_config) | (Optional)Map of objects to configure storage data disk(s). | <pre>map(object({<br>    name                 = optional(string)<br>    create_option        = optional(string, "Empty")<br>    disk_size_gb         = number<br>    lun                  = optional(number)<br>    caching              = optional(string, "ReadWrite")<br>    storage_account_type = optional(string, "StandardSSD_ZRS")<br>    source_resource_id   = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | (Required)Size of the VMs. | `string` | `"Standard_DS1_v2"` | no |



# Authors
Originally created by Omer Brumer
<!-- END_TF_DOCS -->