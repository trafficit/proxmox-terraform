# Proxmox Terraform

Развёртывание ВМ в Proxmox VE. Секреты — только в `secrets.enc.json` (SOPS), в git идут **только** `.tf` файлы и зашифрованный `secrets.enc.json`.

## Структура

```
versions.tf variables.tf locals.tf provider.tf vms.tf outputs.tf
secrets.enc.json          # SOPS — токен и пароли (коммитить можно)
inventory.ini deploy_youtrack.yml tf-env.sh
```

## Секреты (`secrets.enc.json`)

```json
{
  "proxmox_token": "root@pam!terraform=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "vm_admin_password": "]\\;'qwas"
}
```

Редактирование:

```bash
sops secrets.enc.json
```

Проверка токена:

```bash
curl -sk -H "Authorization: PVEAPIToken=$(sops -d secrets.enc.json | jq -r .proxmox_token)" \
  https://192.168.1.55:8006/api2/json/version
```

## Деплой

```bash
terraform init
source ./tf-env.sh && terraform plan
source ./tf-env.sh && terraform apply
```

## ВМ

| VM ID | IP | Имя |
|-------|-----|-----|
| 230 | 192.168.1.230 | tf-ubuntu-server |
| 231 | 192.168.1.231 | tf-youtrack-server |
| 232 | 192.168.1.232 | tf-windows11 — **выключено по умолчанию** (шаблона 9011 на pclaud нет) |

### Windows 11 — пока НЕ ТРОГАТЬ

На `pclaud` **нет** шаблона `9011` (есть только `9000` Ubuntu).  
`create_windows_vm=true` **сейчас упадёт** с `unable to find configuration file for VM 9011`.

**Сейчас** достаточно:

```bash
source ./tf-env.sh && terraform apply
```

(`create_windows_vm` по умолчанию `false` — Windows не создаётся.)

**Когда** сделаешь шаблон Win11 в Proxmox UI (Convert to template, VM ID `9011`):

```bash
source ./tf-env.sh && terraform apply -var="create_windows_vm=true"
```

## Зачем `versions.tf` в git

Это **не** «пулить версии Docker». Файл фиксирует версию **Terraform-провайдера** `bpg/proxmox` (`0.66.1`), чтобы у всех `terraform init` скачивал один и тот же провайдер. Стандартная практика Terraform.

## Git

```bash
git add *.tf tf-env.sh README.md secrets.enc.json inventory.ini deploy_youtrack.yml .gitignore
# НЕ коммитить: *.tfstate*, .terraform/, secrets.json (без .enc)
```
