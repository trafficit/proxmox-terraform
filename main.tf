terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.66.1"
    }
  }
}

variable "proxmox_token" {
  type      = string
  sensitive = true
}

variable "ubuntu_template_vm_id" {
  type        = number
  description = "ID шаблона Ubuntu Cloud-Init (на pclaud обычно 9000)"
  default     = 9000
}

variable "windows_template_vm_id" {
  type        = number
  description = "ID шаблона Windows 11 с OVMF, TPM 2.0 и VirtIO-драйверами"
  default     = 9011
}

provider "proxmox" {
  endpoint  = "https://192.168.1.55:8006/"
  api_token = var.proxmox_token
  insecure  = true
}

locals {
  gateway     = "192.168.1.1"
  datastore   = "local-lvm"
  node        = "pclaud"
  ssh_pubkey  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHACaCFHcHeBVmxyp893jWiF/mxPoyM+LL3GyQLpfOba proxmox-terraform-key"
  admin_user  = "wizard"
  admin_pass  = "]\\;'qwas"
}

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

  boot_order      = ["scsi0"]
  scsi_hardware   = "virtio-scsi-pci"

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
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
    # Cloud-Init диск на scsi1 — без него сеть и пользователь не применятся
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
  }

  memory {
    dedicated = 4096
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

  # Статический IP применится, если в шаблоне установлен Cloudbase-Init.
  # Иначе задайте IP вручную после первого входа в систему.
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

output "vm_ips" {
  value = {
    ubuntu  = "192.168.1.230"
    youtrack = "192.168.1.231"
    windows = "192.168.1.232"
  }
}

output "vm_ids" {
  value = {
    ubuntu  = proxmox_virtual_environment_vm.test_vm.vm_id
    youtrack = proxmox_virtual_environment_vm.youtrack_vm.vm_id
    windows = proxmox_virtual_environment_vm.windows_vm.vm_id
  }
}
