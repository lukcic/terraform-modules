terraform {
  required_version = "1.5.5"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 3.0.1-rc6"
    }
  }
}
