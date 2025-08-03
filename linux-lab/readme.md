## Linux Lab

This lab provisions a Linux VM environment in Azure using Terraform. It is designed for testing, learning, and portfolio demonstration.

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
- Resource group name
- Virtual network name
- Subnet name
- (Add more as needed)

### Portfolio & Demonstration Value
This lab demonstrates:
- Automated VM and network provisioning with Terraform
- Use of variables and outputs
- Azure resource provisioning best practices
- Modular and reusable code

### Notes
- Edit `variables.tf` to customize deployment.
- Review `outputs.tf` for available outputs after deployment.
