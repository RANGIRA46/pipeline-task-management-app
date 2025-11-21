# Terraform Azure Infrastructure

This directory contains Terraform configuration for provisioning Azure infrastructure for the Task Management application.

## 📁 Files

| File | Purpose |
|------|---------|
| `main.tf` | Main resource definitions (VM, VNet, NSG, ACR) |
| `variables.tf` | Input variable declarations |
| `outputs.tf` | Output values (IP addresses, ACR name, etc.) |
| `backend.tf` | Terraform Cloud/State backend configuration |
| `terraform.tfvars` | **SECRET** - Your actual Azure credentials (gitignored) |
| `terraform.tfvars.example` | Example variables file template |

## 🚀 Quick Start

### 1. Install Terraform
Download from: https://www.terraform.io/downloads

Or use Chocolatey (Windows):
```cmd
choco install terraform
```

### 2. Configure Credentials

Create `terraform.tfvars` with your Azure Service Principal:

```hcl
# Azure Credentials (from Azure Portal or az cli)
arm_client_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
arm_client_secret   = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
arm_subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
arm_tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# Project Configuration
project_name   = "devopspipeline"
environment    = "dev"
location       = "East US"
vm_size        = "Standard_B2s"
admin_username = "azureuser"
ssh_public_key = "ssh-rsa YOUR_PUBLIC_KEY_HERE"
```

**⚠️ NEVER commit `terraform.tfvars` - it's gitignored for security**

### 3. Initialize Terraform
```cmd
terraform init
```

### 4. Plan Infrastructure
```cmd
terraform plan
```

### 5. Apply (Create Resources)
```cmd
terraform apply
```

Type `yes` when prompted.

### 6. View Outputs
```cmd
terraform output
```

## 📦 Resources Created

| Resource | Purpose |
|----------|---------|
| **Resource Group** | Container for all Azure resources |
| **Virtual Network** | Private network (10.0.0.0/16) |
| **Subnet** | VM subnet (10.0.1.0/24) |
| **Network Security Group** | Firewall rules (SSH, HTTP, HTTPS) |
| **Public IP** | Static public IP for VM |
| **Network Interface** | VM network card |
| **Virtual Machine** | Ubuntu 22.04 LTS server |
| **Container Registry** | Azure ACR for Docker images |
| **Role Assignment** | AcrPull permission for VM |

## 🔐 Security Configuration

### NSG Rules (Inbound)
- **SSH** (22): Your IP only
- **HTTP** (80): Open (0.0.0.0/0)
- **HTTPS** (443): Open (0.0.0.0/0)
- **API** (4000): Open (should restrict in production)

### SSH Access
```cmd
ssh -i path/to/private_key azureuser@<VM_PUBLIC_IP>
```

Get VM IP:
```cmd
terraform output vm_public_ip
```

## 🛠️ Terraform Cloud (Optional)

This project uses Terraform Cloud for remote state management.

### Configuration (`backend.tf`)
```hcl
terraform {
  cloud {
    organization = "task-manager-organisation"
    workspaces {
      name = "devops-pipeline-infrastructure"
    }
  }
}
```

### Benefits
- **Remote State**: Team collaboration
- **State Locking**: Prevents concurrent changes
- **Version History**: Rollback capability
- **Secure Variables**: Store secrets safely

### Setup
1. Create account: https://app.terraform.io
2. Create organization: `task-manager-organisation`
3. Create workspace: `devops-pipeline-infrastructure`
4. Set variables in Terraform Cloud UI (or use `terraform.tfvars`)

## 📊 Important Outputs

After `terraform apply`, you'll get:

```
resource_group_name = "devopspipeline-dev-rg"
vm_public_ip        = "20.xxx.xxx.xxx"
acr_name            = "devopspipelinedevacr"
acr_login_server    = "devopspipelinedevacr.azurecr.io"
```

Use these for:
- SSH into VM
- Push Docker images to ACR
- Configure Ansible inventory

## 🔄 Managing Infrastructure

### Update Resources
Modify `main.tf` or `terraform.tfvars`, then:
```cmd
terraform plan
terraform apply
```

### Destroy Everything
```cmd
terraform destroy
```

**⚠️ This deletes ALL resources!**

### Destroy Specific Resource
```cmd
terraform destroy -target=azurerm_virtual_machine.main
```

### View State
```cmd
terraform show
terraform state list
```

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| **Invalid credentials** | Verify `terraform.tfvars` has correct Service Principal values |
| **Resource already exists** | Import: `terraform import azurerm_resource_group.main /subscriptions/.../resourceGroups/...` |
| **Terraform Cloud error** | Use local backend: comment out `cloud` block in `backend.tf` |
| **Quota exceeded** | Choose different region or smaller VM size |
| **State locked** | `terraform force-unlock <LOCK_ID>` |

### Enable Debug Logging
```cmd
set TF_LOG=DEBUG
terraform plan
```

## 🎯 Next Steps After Deployment

1. **SSH into VM** and verify it's running
   ```cmd
   ssh azureuser@<VM_PUBLIC_IP>
   ```

2. **Login to ACR** (from local machine)
   ```cmd
   az acr login --name <ACR_NAME>
   ```

3. **Build & Push Docker Images**
   ```cmd
   cd infra/scripts
   build-images.bat <ACR_NAME>
   push-images.bat <ACR_NAME>
   ```

4. **Deploy Application with Ansible**
   ```cmd
   cd infra/ansible
   ansible-playbook -i inventory/azure.yml playbooks/deploy-app.yml
   ```

5. **Verify Application**
   - Visit: `http://<VM_PUBLIC_IP>`

## 📖 Terraform Best Practices

1. **Version Control**: Commit `.tf` files, NOT `.tfvars` or `.tfstate`
2. **Variables**: Use variables for everything that changes
3. **Modules**: Group related resources (future improvement)
4. **State**: Use remote backend (Terraform Cloud or Azure Storage)
5. **Locking**: Prevent concurrent modifications
6. **Tagging**: Tag all resources with environment, project, owner

## 🔗 Useful Commands

```cmd
# Format code
terraform fmt

# Validate syntax
terraform validate

# Import existing resource
terraform import azurerm_resource_group.main /subscriptions/<sub-id>/resourceGroups/<rg-name>

# Target specific resource
terraform apply -target=azurerm_virtual_machine.main

# Refresh state from Azure
terraform refresh

# View specific output
terraform output vm_public_ip
```

## 💡 Cost Optimization

Current setup costs ~$50-100/month depending on:
- VM size (Standard_B2s)
- VM uptime (shut down when not using)
- ACR tier (Basic)
- Egress bandwidth

### Save Money
```cmd
# Stop VM (still pay for storage)
az vm deallocate --name devopspipeline-dev-vm --resource-group devopspipeline-dev-rg

# Start VM
az vm start --name devopspipeline-dev-vm --resource-group devopspipeline-dev-rg
```
