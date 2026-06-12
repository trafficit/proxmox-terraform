#!/usr/bin/env bash
# Подгрузить секреты в Terraform:
#   source ./tf-env.sh && terraform apply

_tf_env() {
  local root secrets json

  root="$(cd "$(dirname "${BASH_SOURCE[1]:-${BASH_SOURCE[0]}}")" && pwd)"
  secrets="$root/secrets.enc.json"

  if ! command -v sops >/dev/null 2>&1; then
    echo "sops не найден" >&2
    return 1
  fi

  if ! json="$(sops -d "$secrets" 2>&1)"; then
    echo "Не удалось расшифровать $secrets" >&2
    echo "$json" >&2
    return 1
  fi

  export TF_VAR_proxmox_token="$(jq -r '.proxmox_token // ""' <<<"$json")"
  export TF_VAR_vm_admin_password="$(jq -r '.vm_admin_password // ""' <<<"$json")"

  if [[ -z "$TF_VAR_proxmox_token" ]]; then
    echo "Ошибка: в secrets.enc.json нет proxmox_token" >&2
    return 1
  fi

  if [[ -z "$TF_VAR_vm_admin_password" ]]; then
    echo "Ошибка: в secrets.enc.json нет vm_admin_password" >&2
    return 1
  fi

  echo "Terraform env OK"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  _tf_env
  exit $?
fi

_tf_env
