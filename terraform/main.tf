terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.5"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.6.3"
    }
  }
}

provider "proxmox" {
  pm_api_url      = data.sops_file.proxmox_secrets.data["proxmox_api_url"]
  pm_user         = data.sops_file.proxmox_secrets.data["proxmox_api_user"]
  pm_password     = data.sops_file.proxmox_secrets.data["proxmox_api_pass"]
  pm_tls_insecure = var.proxmox_ignore_tls
  pm_parallel     = 2
  // pm_parallel hardcoded to 2 as workaround to "transport is closing" issue
  // Ref: github.com/Telmate/terraform-provider-proxmox/issues/257
}

data "sops_file" "proxmox_secrets" {
  source_file = "secret.sops.yaml"
}
