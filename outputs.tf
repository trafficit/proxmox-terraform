output "vm_ips" {
  value = {
    ubuntu   = "192.168.1.230"
    youtrack = "192.168.1.231"
    windows  = "192.168.1.232"
  }
}

output "vm_ids" {
  value = {
    ubuntu   = proxmox_virtual_environment_vm.test_vm.vm_id
    youtrack = proxmox_virtual_environment_vm.youtrack_vm.vm_id
    windows  = proxmox_virtual_environment_vm.windows_vm.vm_id
  }
}
