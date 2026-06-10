terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.66.1"
    }
  }
}

# Объявляем переменную для токена
variable "proxmox_token" {
  type      = string
  sensitive = true # Защищает от случайного вывода токена в логи терминала
}

provider "proxmox" {
  endpoint  = "https://192.168.1.55:8006/"
  api_token = var.proxmox_token # Подставляем переменную сюда
  insecure  = true
}

resource "proxmox_virtual_environment_vm" "test_vm" {
  name      = "tf-ubuntu-server"
  node_name = "pclaud"
  vm_id     = 200

  clone {
    vm_id = 9000
  }

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
    datastore_id = "local-lvm"
    size         = 20
    interface    = "scsi0"
  }

  network_device {
    bridge = "vmbr0"
  }
}
