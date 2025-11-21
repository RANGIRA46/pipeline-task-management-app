# 📖 Deployment Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Local Development Deployment](#local-development-deployment)
3. [Azure Infrastructure Provisioning](#azure-infrastructure-provisioning)
4. [Application Deployment to Azure](#application-deployment-to-azure)
5. [Post-Deployment Verification](#post-deployment-verification)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Tools
- **Git**: Version 2.x or higher
- **Docker Desktop**: Version 20.x or higher
- **Node.js**: Version 18.x or higher
- **Terraform CLI**: Version 1.5.x or higher
- **Ansible**: Version 2.9 or higher
- **Azure CLI**: Latest version

### Required Accounts
- GitHub account with repository access
- Azure account with active subscription
- Terraform Cloud account (free tier)

### Required Access
- Azure Service Principal with Contributor role
- SSH key pair for VM access
- GitHub repository write access

---

## Local Development Deployment

### Step 1: Clone Repository

```bash
git clone https://github.com/RANGIRA46/pipeline-task-management-app.git
cd pipeline-task-management-app
```

### Step 2: Install Dependencies

**Backend**:
```bash
cd backend
npm install
cd ..
```

**Frontend**:
```bash
cd frontend
npm install
cd ..
```

### Step 3: Configure Environment

Create `.env` file in the root directory:

```env
# Database Configuration
DB_USER=devops
DB_PASSWORD=devops123
DB_NAME=devops_app
DATABASE_URL=postgresql://devops:devops123@database:5432/devops_app

# Backend Configuration
PORT=3000
NODE_ENV=development

# Frontend Configuration
VITE_API_URL=http://localhost:3000
```

### Step 4: Start Local Development Environment

**Using Docker Compose** (Recommended):
```bash
docker-compose up --build
```

This will start:
- PostgreSQL database on port 5432
- Backend API on port 3000
- Frontend application on port 80

**Access the application**:
- Frontend: `http://localhost`
- Backend API: `http://localhost:3000`
- API Health: `http://localhost:3000/health`

### Step 5: Verify Local Deployment

```bash
# Check running containers
docker-compose ps

# View logs
docker-compose logs -f

# Test backend health
curl http://localhost:3000/health

# Test API endpoints
curl http://localhost:3000/api/tasks
```

### Step 6: Stop Local Environment

```bash
# Stop containers
docker-compose down

# Stop and remove volumes (clean restart)
docker-compose down -v
```

---

## Azure Infrastructure Provisioning

### Step 1: Create Azure Service Principal

```bash
# Login to Azure
az login

# Get your subscription ID
az account show --query id --output tsv

# Create Service Principal
az ad sp create-for-rbac \
  --name "pipeline-task-management-sp" \
  --role="Contributor" \
  --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"
```

**Save the output**:
```json
{
  "appId": "YOUR_CLIENT_ID",
  "displayName": "pipeline-task-management-sp",
  "password": "YOUR_CLIENT_SECRET",
  "tenant": "YOUR_TENANT_ID"
}
```

### Step 2: Configure Terraform Cloud

1. Go to [app.terraform.io](https://app.terraform.io)
2. Create organization (if not exists)
3. Create workspace: `pipeline-task-management-infrastructure`
4. Choose "CLI-driven workflow"
5. Configure workspace variables:
   - `ARM_CLIENT_ID` = YOUR_CLIENT_ID (from Step 1)
   - `ARM_CLIENT_SECRET` = YOUR_CLIENT_SECRET (sensitive)
   - `ARM_SUBSCRIPTION_ID` = YOUR_SUBSCRIPTION_ID
   - `ARM_TENANT_ID` = YOUR_TENANT_ID

### Step 3: Generate SSH Key Pair

```bash
# Generate SSH key for VM access
ssh-keygen -t rsa -b 4096 -f ~/.ssh/pipeline-task-management -N ""

# Display public key (you'll need this for Terraform)
cat ~/.ssh/pipeline-task-management.pub
```

### Step 4: Configure Terraform Variables

```bash
cd infra/terraform

# Create terraform.tfvars from template
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars
notepad terraform.tfvars
```

Add your values:
```hcl
arm_client_id       = "YOUR_CLIENT_ID"
arm_client_secret   = "YOUR_CLIENT_SECRET"
arm_subscription_id = "YOUR_SUBSCRIPTION_ID"
arm_tenant_id       = "YOUR_TENANT_ID"
ssh_public_key      = "ssh-rsa AAAA... (paste your public key)"

# Optional overrides
project_name = "pipelinetask"
environment = "prod"
```

### Step 5: Initialize Terraform

```bash
# Login to Terraform Cloud
terraform login

# Initialize Terraform
terraform init
```

**Expected output**:
```
Initializing Terraform Cloud...
Initializing provider plugins...
Terraform has been successfully initialized!
```

### Step 6: Plan Infrastructure

```bash
# Review what will be created
terraform plan
```

**Review the plan** to ensure:
- Resource Group will be created
- Virtual Network and Subnet configured
- Network Security Group with correct rules
- Public IP allocated
- Virtual Machine provisioned
- Azure Container Registry created
- Role assignments configured

### Step 7: Apply Infrastructure

```bash
# Provision infrastructure
terraform apply

# Type 'yes' when prompted
```

**Provisioning time**: Approximately 5-10 minutes

### Step 8: Collect Terraform Outputs

```bash
# Save all outputs to file
terraform output -json > terraform-outputs.json

# Display key outputs
terraform output vm_public_ip
terraform output acr_login_server
terraform output acr_name
```

**Save these values** - you'll need them for:
- GitHub Secrets configuration
- Ansible deployment
- Application access

### Step 9: Configure Azure Container Registry

```bash
# Get ACR credentials
az acr credential show --name $(terraform output -raw acr_name)
```

**Save**:
- `username` → ACR_USERNAME for GitHub Secrets
- `passwords[0].value` → ACR_PASSWORD for GitHub Secrets

---

## Application Deployment to Azure

### Step 1: Configure GitHub Secrets

Go to: `https://github.com/RANGIRA46/pipeline-task-management-app/settings/secrets/actions`

Add these secrets:

**Azure Credentials**:
- `ARM_CLIENT_ID` = (from Service Principal)
- `ARM_CLIENT_SECRET` = (from Service Principal)
- `ARM_SUBSCRIPTION_ID` = (your Azure subscription ID)
- `ARM_TENANT_ID` = (your Azure tenant ID)

**Azure Container Registry**:
- `ACR_NAME` = (from `terraform output acr_name`)
- `ACR_LOGIN_SERVER` = (from `terraform output acr_login_server`)
- `ACR_USERNAME` = (from ACR credentials)
- `ACR_PASSWORD` = (from ACR credentials)

**VM Access**:
- `VM_PUBLIC_IP` = (from `terraform output vm_public_ip`)
- `SSH_PRIVATE_KEY` = (content of `~/.ssh/pipeline-task-management` file)

**Database**:
- `DB_USER` = `devops`
- `DB_PASSWORD` = (choose a strong password)
- `DB_NAME` = `devops_app`

**Terraform Cloud**:
- `TF_API_TOKEN` = (from app.terraform.io → User Settings → Tokens)

### Step 2: Trigger Manual Deployment

**Option A: Push to Main Branch**

```bash
# Push your code to main branch
git push origin main
```

This will automatically trigger the CD pipeline.

**Option B: Manual Workflow Trigger**

1. Go to: `https://github.com/RANGIRA46/pipeline-task-management-app/actions`
2. Select "CD Pipeline" workflow
3. Click "Run workflow"
4. Select branch: `main`
5. Click "Run workflow"

### Step 3: Monitor Deployment

1. Go to the GitHub Actions tab
2. Click on the running workflow
3. Monitor each job:
   - **build-and-push**: Docker images building and pushing to ACR
   - **deploy**: Ansible configuring the VM and deploying containers
   - **post-deployment**: Smoke tests verifyingthe deployment

**Expected duration**: 10-15 minutes

### Step 4: Verify Deployment

```bash
# Get your VM IP
VM_IP=$(cd infra/terraform && terraform output -raw vm_public_ip)

# Test frontend
curl http://$VM_IP

# Test backend health
curl http://$VM_IP:3000/health

# Test API
curl http://$VM_IP:3000/api/tasks
```

---

## Post-Deployment Verification

### Application Health Checks

```bash
# Frontend accessibility
curl -I http://YOUR_VM_IP

# Backend health endpoint
curl http://YOUR_VM_IP:3000/health

# Database connectivity
curl http://YOUR_VM_IP:3000/api/health/database
```

### Docker Container Status

```bash
# SSH into VM
ssh -i ~/.ssh/pipeline-task-management azureuser@YOUR_VM_IP

# Check running containers
docker ps

# View container logs
docker logs devops-app_frontend_1
docker logs devops-app_backend_1
docker logs devops-app_database_1

# Check container health
docker inspect --format='{{.State.Health.Status}}' devops-app_backend_1
```

### Security Verification

```bash
# Check firewall status
sudo ufw status

# Verify fail2ban
sudo systemctl status fail2ban

# Check security updates
sudo unattended-upgrades --dry-run
```

### Performance Checks

```bash
# Check system resources
htop

# View application metrics
docker stats

# Check disk usage
df -h
```

---

## Troubleshooting

### Common Issues

#### Issue 1: Terraform Apply Fails

**Symptoms**:
- Authentication errors
- Resource name conflicts
- Quota exceeded

**Solutions**:

```bash
# Verify Azure credentials
az login
az account show

# Check Service Principal permissions
az role assignment list --assignee YOUR_CLIENT_ID

# Verify quota
az vm list-usage --location "East US" -otable

# Fix resource naming conflicts
# Edit infra/terraform/variables.tf
# Change project_name to something unique
```

#### Issue 2: Docker Build Fails in CI/CD

**Symptoms**:
- "No such file or directory"
- Context errors

**Solutions**:

```bash
# Verify Dockerfile paths locally
docker build -f infra/docker/backend.Dockerfile -t test-backend .
docker build -f infra/docker/frontend.Dockerfile -t test-frontend .

# Check .dockerignore
cat .dockerignore

# Verify file structure
ls -la infra/docker/
```

#### Issue 3: Ansible Deployment Fails

**Symptoms**:
- SSH connection timeout
- Permission denied
- ACR login failure

**Solutions**:

```bash
# Test SSH connection
ssh -i ~/.ssh/pipeline-task-management azureuser@YOUR_VM_IP

# Verify NSG rules
az network nsg rule list --resource-group YOUR_RG --nsg-name YOUR_NSG

# Test ACR login manually
az acr login --name YOUR_ACR_NAME

# Check Ansible inventory
cat ansible/inventory/hosts
```

#### Issue 4: Application Not Accessible

**Symptoms**:
- Connection refused
- Timeout errors
- 502 Bad Gateway

**Solutions**:

```bash
# On the VM, check container status
sudo docker ps -a

# Check container logs
sudo docker logs devops-app_backend_1

# Restart containers
cd /opt/devops-app
sudo docker-compose restart

# Check network connectivity
curl localhost:3000/health  # From VM
curl YOUR_VM_IP:3000/health  # From local machine
```

#### Issue 5: Database Connection Errors

**Symptoms**:
- "Connection refused"
- "Password authentication failed"

**Solutions**:

```bash
# Check PostgreSQL container
sudo docker logs devops-app_database_1

# Verify environment variables
sudo cat /opt/devops-app/.env

# Test database connection
sudo docker exec devops-app_database_1 psql -U devops -d devops_app -c "SELECT version();"

# Recreate database container
cd /opt/devops-app
sudo docker-compose down database
sudo docker-compose up -d database
```

### Getting Help

If issues persist:

1. **Check GitHub Actions logs**: Detailed error messages in workflow runs
2. **Review Terraform state**: `terraform show` for current infrastructure state
3. **Ansible verbose mode**: Run playbook with `-vvv` flag
4. **Application logs**: Check backend/frontend logs in Docker
5. **Azure Portal**: Review resource status and metrics

### Emergency Rollback

If deployment causes critical issues:

```bash
# Rollback to previous Docker images
cd /opt/devops-app
sudo docker-compose down
# Edit docker-compose.yml to use previous image tags
sudo docker-compose up -d

# Destroy and recreate infrastructure
cd infra/terraform
terraform destroy
terraform apply
```

---

## Best Practices

### Before Deployment

- ✅ Test locally with Docker Compose
- ✅ Run linting and tests: `npm run lint && npm test`
- ✅ Verify CI pipeline passes
- ✅ Review Terraform plan before applying
- ✅ Backup any critical data

### During Deployment

- ✅ Monitor GitHub Actions workflow progress
- ✅ Watch for error messages in logs
- ✅ Verify each deployment stage completes
- ✅ Keep SSH session open to VM for quick debugging

### After Deployment

- ✅ Run all smoke tests
- ✅ Verify health endpoints
- ✅ Check security scan results
- ✅ Monitor application metrics
- ✅ Document any issues encountered

---

## Additional Resources

- [Azure Documentation](https://docs.microsoft.com/azure)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Ansible Documentation](https://docs.ansible.com)
- [Docker Documentation](https://docs.docker.com)
- [GitHub Actions Documentation](https://docs.github.com/actions)

---

**Last Updated**: 2025-11-21  
**Version**: 1.0  
**Maintained By**: DevOps Team
