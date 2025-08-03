
# Terraform Infra Portfolio

This repository contains a collection of Terraform-based infrastructure projects designed for testing, learning, and demonstration purposes. It serves as a portfolio to showcase my skills in Infrastructure as Code (IaC), automation, and cloud architecture (primarily Azure).

## Repository Structure

- **aks-lab/**: Deploys an Azure Kubernetes Service (AKS) cluster with supporting resources.
- **linux-lab/**: Provisions a Linux VM lab environment with networking.
- **static-website/infra/**: Deploys a static website using Azure Storage.

## Quickstart

### Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription

### Usage Example
Clone the repository:
```sh
git clone https://github.com/mbiszczanik/terraform-infra.git
cd terraform-infra
```

Initialize and deploy a lab (e.g., AKS):
```sh
cd aks-lab
az login
terraform init -upgrade
terraform plan -out main.tfplan
terraform apply main.tfplan
```

Destroy resources:
```sh
terraform destroy
```

Repeat for other labs as needed.

## Demonstration & Portfolio Value

This repository demonstrates:
- Modular and reusable Terraform code
- Azure resource provisioning (AKS, VMs, Storage, Networking)
- Use of variables, outputs, and best practices
- Documentation and automation
- (Optional) CI/CD with GitHub Actions

## To Do / Improvements
- Add architecture diagrams
- Add GitHub Actions for CI/CD
- Expand lab documentation and outputs
- Add more cloud providers (future)

---
Feel free to explore each lab and use this repository as a reference for your own infrastructure projects!
