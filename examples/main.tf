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