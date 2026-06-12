# ============================================================================
# 1. ТЕСТОВАЯ ВИРТУАЛЬНАЯ МАШИНА (Ubuntu Server)
# ============================================================================
resource "proxmox_virtual_environment_vm" "test_vm" {
  name      = "tf-ubuntu-server"
  node_name = local.node
  vm_id     = 230

  clone {
    vm_id = var.ubuntu_template_vm_id
  }

  boot_order    = ["scsi0"]
  scsi_hardware = "virtio-scsi-pci"

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 4096
  }

  agent {
    enabled = true
  }

  disk {
    datastore_id = local.datastore
    size         = 20
    interface    = "scsi0"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    interface    = "scsi1"
    datastore_id = local.datastore

    ip_config {
      ipv4 {
        address = "192.168.1.230/24"
        gateway = local.gateway
      }
    }

    user_account {
      username = local.admin_user
      password = local.admin_pass
      keys     = [local.ssh_pubkey]
    }
  }
}

# ============================================================================
# 2. СЕРВЕР YOUTRACK
# ============================================================================
resource "proxmox_virtual_environment_vm" "youtrack_vm" {
  name      = "tf-youtrack-server"
  node_name = local.node
  vm_id     = 231

  clone {
    vm_id = var.ubuntu_template_vm_id
  }

  boot_order    = ["scsi0"]
  scsi_hardware = "virtio-scsi-pci"

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 4608
  }

  agent {
    enabled = true
  }

  disk {
    datastore_id = local.datastore
    size         = 30
    interface    = "scsi0"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    interface    = "scsi1"
    datastore_id = local.datastore

    ip_config {
      ipv4 {
        address = "192.168.1.231/24"
        gateway = local.gateway
      }
    }

    user_account {
      username = local.admin_user
      password = local.admin_pass
      keys     = [local.ssh_pubkey]
    }
  }
}

# ============================================================================
# 3. WINDOWS 11
# ============================================================================
resource "proxmox_virtual_environment_vm" "windows_vm" {
  count = var.create_windows_vm ? 1 : 0

  name      = "tf-windows11"
  node_name = local.node
  vm_id     = 232

  clone {
    vm_id = var.windows_template_vm_id
  }

  bios    = "ovmf"
  machine = "q35"

  boot_order    = ["scsi0"]
  scsi_hardware = "virtio-scsi-pci"

  operating_system {
    type = "win11"
  }

  cpu {
    cores = 4
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 8192
  }

  agent {
    enabled = true
  }

  efi_disk {
    datastore_id = local.datastore
    type         = "4m"
  }

  tpm_state {
    version      = "v2.0"
    datastore_id = local.datastore
  }

  disk {
    datastore_id = local.datastore
    size         = 64
    interface    = "scsi0"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    interface    = "ide2"
    datastore_id = local.datastore

    ip_config {
      ipv4 {
        address = "192.168.1.232/24"
        gateway = local.gateway
      }
    }
  }
}
