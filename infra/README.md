# Infrastructure Overview

This directory contains all infrastructure-as-code (IaC), containerization, and configuration management files for the Task Management Pipeline application.

## 📁 Directory Structure

```
infra/
├── terraform/          # Azure infrastructure provisioning
├── docker/             # Docker container configurations
├── ansible/            # Server configuration management
├── kubernetes/         # Kubernetes manifests (optional)
├── scripts/            # Deployment and utility scripts
└── README.md          # This file
```

## 🏗️ Infrastructure Components

### 1. Terraform (Azure Cloud)
- **Location**: `./terraform/`
- **Purpose**: Provision Azure resources (VMs, ACR, networking)
- **Commands**:
  ```bash
  cd terraform
  terraform init
  terraform plan
  terraform apply
  ```

### 2. Docker
- **Location**: `./docker/`
- **Purpose**: Application containerization
- **Services**:
  - Backend API (Node.js/Express)
  - Frontend UI (React/Vite)
  - PostgreSQL Database
- **Commands**:
  ```bash
  docker compose up --build
  ```

### 3. Ansible
- **Location**: `./ansible/`
- **Purpose**: Configure Azure VMs, deploy applications
- **Playbooks**:
  - `setup-vm.yml` - Initial server setup
  - `deploy-app.yml` - Application deployment
  - `security-hardening.yml` - Security configuration

### 4. Kubernetes (Optional)
- **Location**: `./kubernetes/`
- **Purpose**: Container orchestration (if scaling beyond single VM)
- **Manifests**: Deployments, Services, Ingress, ConfigMaps

### 5. Scripts
- **Location**: `./scripts/`
- **Purpose**: Automation scripts for common tasks
- **Scripts**:
  - `deploy.sh` / `deploy.bat` - Full deployment pipeline
  - `build-images.sh` - Build & push Docker images
  - `health-check.sh` - Infrastructure health checks

## 🚀 Quick Start

### Prerequisites
- Docker Desktop installed
- Terraform installed
- Azure CLI (optional, for manual operations)
- Ansible (for VM configuration)

### Local Development
```bash
# 1. Start local environment with Docker
cd infra/docker
docker compose up --build

# Access:
# - Frontend: http://localhost
# - Backend API: http://localhost:4000
# - Database: localhost:5432
```

### Azure Deployment

#### Step 1: Configure Credentials
```bash
# Create terraform/terraform.tfvars with your Azure Service Principal
cd infra/terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with real values
```

#### Step 2: Provision Infrastructure
```bash
# From project root
terraform-docker.bat plan
terraform-docker.bat apply
```

#### Step 3: Configure VMs with Ansible
```bash
cd infra/ansible
ansible-playbook -i inventory/azure.yml playbooks/setup-vm.yml
ansible-playbook -i inventory/azure.yml playbooks/deploy-app.yml
```

#### Step 4: Deploy Application
```bash
cd infra/scripts
./deploy.sh production
```

## 🔐 Security Notes

- **Never commit** `terraform.tfvars` (contains secrets)
- **Never commit** `.env` files with real credentials
- Store secrets in Azure Key Vault or GitHub Secrets
- Use SSH keys for VM access (no passwords)
- Enable NSG rules to restrict access

## 📊 Monitoring & Logs

- **Application Logs**: Check Docker logs or VM `/var/log/`
- **Infrastructure State**: `terraform show`
- **Health Checks**: `./scripts/health-check.sh`

## 🔄 CI/CD Integration

GitHub Actions workflows automatically:
1. Build Docker images on push
2. Run security scans
3. Push images to Azure Container Registry
4. Deploy to Azure VM (on main branch)

See `.github/workflows/` for pipeline configurations.

## 🆘 Troubleshooting

### Terraform Issues
- **Invalid credentials**: Check `terraform.tfvars`
- **State locked**: `terraform force-unlock <LOCK_ID>`
- **Resource conflicts**: Verify resource group doesn't exist

### Docker Issues
- **Port conflicts**: Stop other services using ports 80, 4000, 5432
- **Build failures**: Check Dockerfile syntax and build context
- **Network issues**: `docker network prune`

### Ansible Issues
- **Connection refused**: Verify VM public IP and SSH key
- **Permission denied**: Check SSH key permissions (600)
- **Python not found**: Ensure python3 installed on target VM

## 📚 Additional Resources

- [Terraform Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Ansible Documentation](https://docs.ansible.com/)

## 🏷️ Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-11-21 | Initial infrastructure setup |
