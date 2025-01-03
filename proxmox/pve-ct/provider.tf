terraform {
  required_version = "1.5.5"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure     = true
  pm_api_url          = var.proxmox_host.pm_api_url
  pm_user             = var.proxmox_user
  pm_password         = var.proxmox_password
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
}
