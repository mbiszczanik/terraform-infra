## Static Website Lab

This lab demonstrates how to deploy a static website using Azure Storage and Terraform. It is intended for testing, learning, and portfolio demonstration.

### Prerequisites
- Azure CLI
- Terraform >= 1.0
- Azure subscription

### Usage
```sh
az login
terraform init -upgrade
terraform plan -out main.tfplan
terraform apply main.tfplan
```

To destroy resources:
```sh
terraform destroy
```

### Outputs
- Storage account name
- Static website endpoint

### Portfolio & Demonstration Value
This lab demonstrates:
- Automated static website deployment with Terraform
- Use of variables and outputs
- Azure resource provisioning best practices
- Modular and reusable code

### Notes
- Edit `variables.tf` to customize deployment.
- Review `outputs.tf` for available outputs after deployment.
