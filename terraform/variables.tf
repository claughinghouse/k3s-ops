#-------------------------------------------------------------------------------------------#
# Proxmox Variables
# Reference: https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/index.md
#-------------------------------------------------------------------------------------------#

variable "proxmox_ignore_tls" {
  description = "Disable TLS verification while connecting"
  type        = string
  default     = "true"
}
