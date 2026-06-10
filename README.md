# Proxmox Virtual Environment Provisioning via Terraform

An automation project for deploying virtual machines in Proxmox VE using Terraform with secure secrets management.

## Tech Stack

* Terraform
* Proxmox Provider (bpg/proxmox)
* Mozilla SOPS (for secrets encryption)
* Age (for encryption key generation)

## Security Architecture

All sensitive data (API tokens, passwords) is stored inside the encrypted `secrets.enc.json` file. Encryption is handled via the AES-256-GCM algorithm using the SOPS utility and asymmetric Age keys.

The source code in `main.tf` contains no plaintext secrets and is completely safe for public repositories. Decryption occurs dynamically in-memory during the execution of Terraform commands.

## Quick Start

### Prerequisites

The host running Terraform must have `age` and `sops` utilities installed, along with the private key located at `~/.config/sops/age/keys.txt`.

### Initialization and Deployment

1. Clone the repository:
   ```bash
   git clone git@github.com:trafficit/proxmox-terraform.git
   cd proxmox-terraform
