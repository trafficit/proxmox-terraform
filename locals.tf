locals {
  gateway    = "192.168.1.1"
  datastore  = "local-lvm"
  node       = "pclaud"
  ssh_pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHACaCFHcHeBVmxyp893jWiF/mxPoyM+LL3GyQLpfOba proxmox-terraform-key"
  admin_user = "wizard"
  admin_pass = var.vm_admin_password
}
