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
| 232 | 192.168.1.232 | tf-windows11 (шаблон 9011) |

## Git

```bash
git add *.tf tf-env.sh README.md secrets.enc.json inventory.ini deploy_youtrack.yml .gitignore
# НЕ коммитить: *.tfstate*, .terraform/, secrets.json (без .enc)
```
