variable "resource_group_name" {
  description = "(Required)A container that holds related resources for an Azure solution."
  type        = string
}

variable "location" {
  description = "(Required)The location to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'."
  type        = string
}

# NIC inputs
variable "subnet_id" {
  description = "(Required)ID of VM's subnet."
  type        = string
}

variable "private_ip_allocation" {
  description = "(Optional)Private IP Allocation's type."
  type        = string
  default     = "Dynamic"
}

variable "enable_accelerated_networking" {
  description = "(Optional)Should Accelerated Networking be enabled? Defaults to `false`."
  type        = bool
  default     = false
}

# Virtual Machine 
variable "vm_name" {
  description = "(Required)Name of Virtual Machine."
  type        = string
}

variable "vm_size" {
  description = "(Required)Size of the VMs."
  type        = string
  default     = "Standard_DS1_v2"
}

# Virtual Machine OS
variable "os_disk_create_option" {
  description = "(Required)Storage OS disk create option."
  type        = string
  default     = "FromImage"
}

variable "os_type" {
  description = "(Optional)Specifies the Operating System on the OS Disk. Possible values are Linux and Windows."
  type        = string
  default     = "linux"

  validation {
    condition     = contains(["linux", "windows"], var.os_type)
    error_message = "The os type value must be \"linux\" or \"windows\"."
  }
}

variable "os_disk_caching" {
  description = "(Optional)Specifies the caching requirements for the OS Disk."
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_managed_disk_type" {
  description = "(Optional)The Type of Storage Account which should back this the Internal OS Disk. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`."
  type        = string
  default     = "Standard_LRS"
}

variable "image_reference" {
  description = "(Optional)This block provisions the Virtual Machine from one of two sources: an Azure Platform Image (e.g. Ubuntu/Windows Server) or a Custom Image."
  type = map(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))
  default = {
    "linux" : {
      "publisher" : "Canonical",
      "offer" : "UbuntuServer",
      "sku" : "16.04-LTS",
      "version" : "latest"
    },
    "windows" : {
      "publisher" : "MicrosoftWindowsServer",
      "offer" : "WindowsServer",
      "sku" : "2016-Datacenter",
      "version" : "latest"
    }
  }
}

# Virtual Machine login
variable "computer_name" {
  description = "(Required)Specifies the name of the Virtual Machine."
  type        = string
}

variable "admin_username" {
  description = "(Required)Specifies the name of the local administrator account."
  type        = string
}

variable "admin_password" {
  description = "(Optional)(Optional for Windows, Optional for Linux)The password associated with the local administrator account."
  type        = string
  sensitive   = true
}

# Virtual Machine Identity
variable "identity_type" {
  description = "(Optional)The type of identity used for the managed cluster. Conflict with `client_id` and `client_secret`. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`(to enable both). If `UserAssigned` or `SystemAssigned, UserAssigned` is set, an `identity_ids` must be set as well."
  type        = string
  default     = "SystemAssigned"

  validation {
    condition     = var.identity_type == "SystemAssigned" || var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned"
    error_message = "`identity_type`'s possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`(to enable both)."
  }
}

variable "identity_ids" {
  description = "(Optional)Specifies a list of User Assigned Managed Identity IDs to be assigned to this Virtual Machine."
  type        = list(string)
  default     = null
}

# SSH Connection inputs
variable "admin_ssh_key_public_key_file" {
  description = "(Optional)SSH private key."
  type        = string
  default     = null
}

variable "ssh_private_key" {
  description = "(Optional)SSH private key."
  type        = string
  default     = null
}

# Disk attachment
variable "storage_data_disk_config" {
  description = "(Optional)Map of objects to configure storage data disk(s)."
  type = map(object({
    name                 = optional(string)
    create_option        = optional(string, "Empty")
    disk_size_gb         = number
    lun                  = optional(number)
    caching              = optional(string, "ReadWrite")
    storage_account_type = optional(string, "StandardSSD_ZRS")
    source_resource_id   = optional(string)
  }))
  default = {}
}

variable "log_analytics_workspace_id" {
  description = "(Required)Log analytics workspace id to send logs from the current resource."
  type        = string
  default     = null
}

variable "role_assignments" {
  description = "(Optional)Role assignments for the log analytics."
  type = map(object({
    role_definition_name = string
    scope                = string
  }))
  default = {}
}