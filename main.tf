/**
* # Azure Linux/Windows Virtual Machine and Diagnostic Setting module
* Managed disk is optional 
*/

resource "azurerm_role_assignment" "vm_uai_log_analytics_reader" {
  for_each = var.role_assignments == {} ? {} : var.role_assignments

  principal_id         = (var.os_type == "linux") ? azurerm_linux_virtual_machine.configuration[0].identity[0].principal_id : azurerm_windows_virtual_machine.configuration[0].identity[0].principal_id
  role_definition_name = each.value.role_definition_name
  scope                = each.value.scope

  depends_on = [
    azurerm_linux_virtual_machine.configuration[0],
    azurerm_windows_virtual_machine.configuration[0]
  ]
}

resource "azurerm_network_interface" "vm" {
  name                          = var.vm_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "${var.vm_name}-ip"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_allocation
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_linux_virtual_machine" "configuration" {
  count = var.os_type == "linux" ? 1 : 0

  name                  = var.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  network_interface_ids = [azurerm_network_interface.vm.id]

  source_image_reference {
    publisher = var.image_reference[var.os_type].publisher
    offer     = var.image_reference[var.os_type].offer
    sku       = var.image_reference[var.os_type].sku
    version   = var.image_reference[var.os_type].version
  }

  os_disk {
    name                 = "${var.vm_name}-disk"
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_managed_disk_type
  }

  computer_name  = var.computer_name
  admin_username = var.admin_username
  admin_password = var.admin_password

  disable_password_authentication = var.admin_password == null ? true : false

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_key_public_key_file == null ? [] : [var.admin_ssh_key_public_key_file]
    content {
      public_key = var.admin_ssh_key_public_key_file
      username   = var.admin_username
    }
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "UserAssigned, SystemAssigned" ? var.identity_ids : null
  }


  lifecycle {
    ignore_changes = [
      tags
    ]
  }

  depends_on = [
    azurerm_network_interface.vm
  ]
}

resource "azurerm_windows_virtual_machine" "configuration" {
  count = var.os_type == "windows" ? 1 : 0

  name                  = var.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  network_interface_ids = [azurerm_network_interface.vm.id]

  source_image_reference {
    publisher = var.image_reference[var.os_type].publisher
    offer     = var.image_reference[var.os_type].offer
    sku       = var.image_reference[var.os_type].sku
    version   = var.image_reference[var.os_type].version
  }

  os_disk {
    name                 = "${var.vm_name}-disk"
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_managed_disk_type
  }

  computer_name  = var.computer_name
  admin_username = var.admin_username
  admin_password = var.admin_password

  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "UserAssigned, SystemAssigned" ? var.identity_ids : null
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

  depends_on = [
    azurerm_network_interface.vm
  ]
}

resource "azurerm_managed_disk" "disk" {
  for_each = var.storage_data_disk_config

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_type = each.value.storage_account_type
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
  source_resource_id   = contains(["Copy", "Restore"], each.value.create_option) ? each.value.source_resource_id : null
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
  for_each = var.storage_data_disk_config

  managed_disk_id    = azurerm_managed_disk.disk[each.key].id
  virtual_machine_id = (var.os_type == "linux") ? azurerm_linux_virtual_machine.configuration[0].id : azurerm_windows_virtual_machine.configuration[0].id
  lun                = coalesce(each.value.lun, index(keys(var.storage_data_disk_config), each.key))
  caching            = each.value.caching
}

module "diagnostic_settings" {
  source = "git::https://github.com/OmerBrumer/module-diagnostic-setting.git"

  diagonstic_setting_name    = "${var.vm_name}-diagnostic-setting"
  log_analytics_workspace_id = var.log_analytics_workspace_id
  target_resource_id         = (var.os_type == "linux") ? azurerm_linux_virtual_machine.configuration[0].id : azurerm_windows_virtual_machine.configuration[0].id
}