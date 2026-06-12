provider "proxmox" {
  endpoint  = "https://192.168.1.55:8006/"
  api_token = var.proxmox_token
  insecure  = true
}
