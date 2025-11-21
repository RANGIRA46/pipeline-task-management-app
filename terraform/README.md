# Terraform Infrastructure

Infrastructure as Code for Azure resources

## Prerequisites

- Terraform CLI (>= 1.5.0)
- Azure CLI
- Terraform Cloud account
- Azure Service Principal

## Setup

1. **Login to Azure**:
```bash
az login
```

2. **Create Service Principal**:
```bash
az ad sp create-for-rbac --name "devops-pipeline-sp" \
  --role="Contributor" \
  --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"
```

3. **Configure Terraform Cloud**:
- Create organization
- Create workspace: `devops-pipeline-infrastructure`
- Add variables:
  - `ARM_CLIENT_ID`
  - `ARM_CLIENT_SECRET` (sensitive)
  - `ARM_SUBSCRIPTION_ID`
  - `ARM_TENANT_ID`

4. **Update backend.tf**:
Replace `your-org-name` with your Terraform Cloud organization name.

## Usage

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy
```

## Resources Created

- Resource Group
- Virtual Network
- Subnet
- Network Security Group
- Public IP
- Network Interface
- Linux Virtual Machine (Ubuntu 22.04)
- Azure Container Registry
- SSH Key Resource

## Outputs

After applying, you'll get:
- VM Public IP
- ACR Login Server
- ACR Name
- Resource Group Name

## Variables

See `variables.tf` for all configurable variables.

Create `terraform.tfvars`:
```hcl
project_name   = "devopspipeline"
environment    = "dev"
location       = "East US"
vm_size        = "Standard_B2s"
admin_username = "azureuser"
ssh_public_key = "ssh-rsa AAAA..."
```
