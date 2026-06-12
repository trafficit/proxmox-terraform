output "vm_ips" {
  value = {
    ubuntu   = "192.168.1.230"
    youtrack = "192.168.1.231"
    windows  = var.create_windows_vm ? "192.168.1.232" : null
  }
}

output "vm_ids" {
  value = {
    ubuntu   = proxmox_virtual_environment_vm.test_vm.vm_id
    youtrack = proxmox_virtual_environment_vm.youtrack_vm.vm_id
    windows  = var.create_windows_vm ? proxmox_virtual_environment_vm.windows_vm[0].vm_id : null
  }
}
