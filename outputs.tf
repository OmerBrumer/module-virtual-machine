output "id" {
  description = "Id of vm."
  value       = (var.os_type == "linux") ? azurerm_linux_virtual_machine.configuration[0].id : azurerm_windows_virtual_machine.configuration[0].id
}

output "name" {
  description = "Name of vm."
  value       = (var.os_type == "linux") ? azurerm_linux_virtual_machine.configuration[0].name : azurerm_windows_virtual_machine.configuration[0].name
}

output "object" {
  description = "Object of vm."
  value       = (var.os_type == "linux") ? azurerm_linux_virtual_machine.configuration[0] : azurerm_windows_virtual_machine.configuration[0]
}

output "principal_id" {
  description = "Principal id of vm."
  value       = (var.os_type == "linux") ? azurerm_linux_virtual_machine.configuration[0].identity[0].principal_id : azurerm_windows_virtual_machine.configuration[0].identity[0].principal_id
}

output "nic_id" {
  description = "Id of nic."
  value       = azurerm_network_interface.vm.id
}

output "nic_name" {
  description = "Name of nic."
  value       = azurerm_network_interface.vm.name
}

output "nic_object" {
  description = "Object of nic."
  value       = azurerm_network_interface.vm
}

output "nic_private_ip" {
  description = "Private ip address of the vm nic."
  value       = azurerm_network_interface.vm.private_ip_address
}