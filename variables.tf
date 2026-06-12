variable "proxmox_token" {
  type        = string
  sensitive   = true
  description = "API-токен Proxmox: root@pam!terraform=..."
}

variable "vm_admin_password" {
  type        = string
  sensitive   = true
  description = "Пароль cloud-init пользователя wizard на Linux-ВМ."
}

variable "ubuntu_template_vm_id" {
  type        = number
  description = "ID шаблона Ubuntu Cloud-Init (на pclaud обычно 9000)."
  default     = 9000
}

variable "windows_template_vm_id" {
  type        = number
  description = "ID шаблона Windows 11 с OVMF, TPM 2.0 и VirtIO-драйверами."
  default     = 9011
}
