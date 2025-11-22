# 🔍 CD Pipeline Debug & Validation Guide

## 📋 Overview

This guide helps you debug and validate the CD (Continuous Deployment) pipeline for the Task Manager application.

---

## ✅ Pre-Deployment Checklist

### 1. Required GitHub Secrets

Navigate to: **Settings → Secrets and variables → Actions**

Ensure these secrets are configured:

| Secret Name | Description | How to Get |
|------------|-------------|-----------|
| `ACR_LOGIN_SERVER` | Azure Container Registry URL | From Azure Portal: ACR → Properties |
| `ACR_NAME` | Azure Container Registry name | Your ACR resource name |
| `ACR_USERNAME` | ACR username (or Service Principal) | From ACR Access Keys or Service Principal |
| `ACR_PASSWORD` | ACR password (or SP secret) | From ACR Access Keys or Service Principal |
| `ARM_CLIENT_ID` | Azure Service Principal client ID | From Service Principal creation |
| `ARM_CLIENT_SECRET` | Azure Service Principal secret | From Service Principal creation |
| `ARM_TENANT_ID` | Azure tenant ID | From Azure Portal |
| `VM_PUBLIC_IP` | Azure VM public IP address | From Azure Portal: VM → Networking |
| `SSH_PRIVATE_KEY` | SSH private key for VM access | Generated SSH key (see below) |
| `DB_USER` | PostgreSQL username | Default: `devops` |
| `DB_PASSWORD` | PostgreSQL password | Your database password |
| `DB_NAME` | PostgreSQL database name | Default: `devops_app` |

### 2. SSH Key Setup

```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_vm_key -N ""

# Copy public key to VM (during VM creation or manually)
cat ~/.ssh/azure_vm_key.pub

# Add private key to GitHub secrets
cat ~/.ssh/azure_vm_key | pbcopy  # macOS
cat ~/.ssh/azure_vm_key | clip    # Windows
cat ~/.ssh/azure_vm_key           # Linux (copy manually)
```

### 3. Azure VM Requirements

Your Azure VM should:
- ✅ Be running Ubuntu 20.04 or later
- ✅ Have a public IP address
- ✅ Allow SSH (port 22), HTTP (port 80), and API (port 3000) in NSG
- ✅ Have the SSH public key configured for 'azureuser'

---

## 🔄 Fixed Issues in Latest Configuration

### Port Consistency ✅
- **Fixed:** Backend now uses port 3000 consistently (was 4000 in Dockerfile)
- **Fixed:** Frontend API URL updated to point to port 3000
- **Impact:** Health checks and service communication now work correctly

### Ansible Configuration ✅
- **Created:** Complete Ansible directory structure
- **Created:** `ansible/ansible.cfg` - Ansible configuration
- **Created:** `ansible/playbooks/setup-server.yml` - Full server setup
- **Created:** `ansible/playbooks/update-app.yml` - Quick updates
- **Impact:** CD pipeline can now execute Ansible playbooks

### Docker Compose ✅
- **Dynamic Generation:** Ansible creates docker-compose.yml on the server
- **ACR Integration:** Automatic login and image pulling from Azure Container Registry
- **Environment Variables:** All secrets properly injected

---

## 🚀 Running the CD Pipeline

### Option 1: Push to Main Branch

```bash
git add .
git commit -m "fix: update CD configuration with Ansible and port fixes"
git push origin main
```

This automatically triggers the CD pipeline.

### Option 2: Manual Workflow Dispatch

1. Go to GitHub: **Actions → CD Pipeline**
2. Click **Run workflow**
3. Select branch: `main`
4. Click **Run workflow**

---

## 🔍 Debugging Workflow Run

### Step 1: View Workflow Run

1. Go to: **GitHub → Actions**
2. Click on the latest "CD Pipeline" run
3. You'll see three jobs:
   - `build-and-push` - Build Docker images
   - `deploy` - Deploy to Azure VM
   - `post-deployment` - Run smoke tests

### Step 2: Check Each Job

#### Job 1: Build and Push Docker Images

**What to check:**
- ✅ Checkout code
- ✅ Docker Buildx setup
- ✅ ACR login successful
- ✅ Backend image built and pushed
- ✅ Frontend image built and pushed
- ✅ Image tags created correctly

**Common Errors:**

| Error | Cause | Solution |
|-------|-------|----------|
| ACR login failed | Wrong credentials | Verify `ACR_USERNAME`, `ACR_PASSWORD` secrets |
| Build context not found | Wrong Dockerfile path | Check `./infra/docker/backend.Dockerfile` exists |
| Permission denied | ACR access issues | Ensure Service Principal has AcrPush role |

**How to verify:**

```bash
# Check if images were pushed to ACR
az acr repository list --name YOUR_ACR_NAME --output table
az acr repository show-tags --name YOUR_ACR_NAME --repository devops-backend --output table
az acr repository show-tags --name YOUR_ACR_NAME --repository devops-frontend --output table
```

#### Job 2: Deploy to Azure VM

**What to check:**
- ✅ Checkout code
- ✅ Python and Ansible installed
- ✅ SSH key configured
- ✅ Ansible inventory created
- ✅ Ansible playbook executed successfully
- ✅ Deployment verified

**Common Errors:**

| Error | Cause | Solution |
|-------|-------|----------|
| SSH connection failed | Wrong SSH key or VM IP | Verify `SSH_PRIVATE_KEY` and `VM_PUBLIC_IP` |
| Ansible playbook failed | Missing dependencies | Check VM has internet access |
| Docker login failed | ACR credentials wrong | Verify ARM_CLIENT_ID/SECRET |
| Health check failed | Service not starting | Check container logs on VM |

**How to debug:**

Look for the "Run Ansible deployment" step in the logs. You should see:

```
PLAY [Setup Azure VM for Task Manager Application] *************************

TASK [Gathering Facts] *****************************************************
ok: [azure-vm]

TASK [Update apt cache] ****************************************************
changed: [azure-vm]

TASK [Install Docker] ******************************************************
changed: [azure-vm]

...

PLAY RECAP *****************************************************************
azure-vm                   : ok=XX   changed=YY   unreachable=0    failed=0
```

**If deployment fails, SSH into the VM:**

```bash
ssh azureuser@YOUR_VM_IP

# Check if Docker is running
sudo systemctl status docker

# Check if containers are running
docker ps

# View container logs
docker logs taskmanager-backend
docker logs taskmanager-frontend
docker logs taskmanager-db

# Check if images were pulled
docker images | grep devops

# Test backend health manually
curl http://localhost:3000/health

# Test frontend
curl http://localhost
```

#### Job 3: Post-Deployment Tests

**What to check:**
- ✅ Frontend accessible at port 80
- ✅ Backend health check passes
- ✅ API endpoints responding

**How to test manually:**

```bash
# Replace YOUR_VM_IP with actual IP
export VM_IP=YOUR_VM_IP

# Test frontend
curl -f http://$VM_IP || echo "Frontend failed"

# Test backend health
curl -f http://$VM_IP:3000/health || echo "Health check failed"

# Test API
curl -f http://$VM_IP:3000/api/tasks || echo "API failed"

# Test from browser
# Navigate to: http://YOUR_VM_IP
```

---

## 📊 Expected Success Output

### Successful Build Job Output

```
✓ Checkout code
✓ Set up Docker Buildx
✓ Log in to Azure Container Registry
✓ Extract metadata (version: sha-abc1234)
✓ Build and push backend image
  → YOUR_ACR.azurecr.io/devops-backend:sha-abc1234
  → YOUR_ACR.azurecr.io/devops-backend:latest
✓ Build and push frontend image
  → YOUR_ACR.azurecr.io/devops-frontend:sha-abc1234
  → YOUR_ACR.azurecr.io/devops-frontend:latest
✓ Scan images (Trivy)
✓ Upload scan results
```

### Successful Deploy Job Output

```
✓ Checkout code
✓ Setup Python
✓ Install Ansible
✓ Setup SSH key
✓ Create Ansible inventory
✓ Run Ansible deployment
  PLAY RECAP:
  azure-vm: ok=25 changed=15 unreachable=0 failed=0
  
  Deployment Complete!
  ========================================
  Frontend URL: http://YOUR_VM_IP
  Backend API: http://YOUR_VM_IP:3000
  Health Check: http://YOUR_VM_IP:3000/health
  ========================================
  
✓ Verify deployment
  Health check: ✓ OK
  Frontend check: ✓ OK
```

### Successful Post-Deployment Output

```
✓ Checkout code
✓ Run smoke tests
  Frontend test: ✓ PASSED
  Backend health test: ✓ PASSED
  API test: ✓ PASSED
✓ Notify deployment success
  Deployment successful to http://YOUR_VM_IP
```

---

## 🐛 Common Issues & Solutions

### Issue 1: "Failed to download artifact"

**Cause:** CI pipeline didn't run or didn't upload artifacts

**Solution:**
```bash
# Ensure CI pipeline ran successfully first
# Check: Actions → CI Pipeline → latest run

# CI must complete before CD runs
# If using workflow_dispatch, ensure CI artifacts exist
```

### Issue 2: "SSH connection refused"

**Cause:** Wrong VM IP, SSH not allowed, or key mismatch

**Solution:**
```bash
# Test SSH connection manually
ssh -i ~/.ssh/azure_vm_key azureuser@YOUR_VM_IP

# Check Azure NSG rules
az network nsg rule list --resource-group YOUR_RG --nsg-name YOUR_NSG --output table

# Ensure SSH key is correct in GitHub secrets
cat ~/.ssh/azure_vm_key  # This should match SSH_PRIVATE_KEY secret
```

### Issue 3: "ACR authentication failed"

**Cause:** Wrong Service Principal credentials or insufficient permissions

**Solution:**
```bash
# Test ACR login manually
az login --service-principal \
  --username $ARM_CLIENT_ID \
  --password $ARM_CLIENT_SECRET \
  --tenant $ARM_TENANT_ID

az acr login --name YOUR_ACR_NAME

# Ensure Service Principal has AcrPull and AcrPush roles
az role assignment create \
  --assignee $ARM_CLIENT_ID \
  --role AcrPush \
  --scope /subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/YOUR_RG/providers/Microsoft.ContainerRegistry/registries/YOUR_ACR_NAME
```

### Issue 4: "Container fails to start"

**Cause:** Database connection, environment variables, or image issues

**Solution:**
```bash
# SSH into VM
ssh azureuser@YOUR_VM_IP

# Check container status
docker ps -a

# View logs
docker logs taskmanager-backend
docker logs taskmanager-db

# Common issues:
# 1. Database not ready
docker logs taskmanager-db | grep "database system is ready"

# 2. Environment variables
docker exec taskmanager-backend env | grep DATABASE_URL

# 3. Network connectivity
docker exec taskmanager-backend ping -c 3 postgres
```

### Issue 5: "Health check timeout"

**Cause:** Service takes too long to start or is failing

**Solution:**
```bash
# Increase wait time in cd-pipeline.yml
# Line 147: sleep 30 → sleep 60

# Check backend startup time
ssh azureuser@YOUR_VM_IP
time curl http://localhost:3000/health

# Check if database migrations ran
docker logs taskmanager-backend | grep -i migration
```

---

## 🧪 Manual Deployment Test

To test deployment without CI/CD:

```bash
# 1. Clone repo on your local machine
git clone YOUR_REPO_URL
cd pipeline-task-management-app

# 2. Set environment variables
export ACR_LOGIN_SERVER=your-acr.azurecr.io
export ARM_CLIENT_ID=your-client-id
export ARM_CLIENT_SECRET=your-secret
export ARM_TENANT_ID=your-tenant-id
export IMAGE_TAG=latest
export DB_USER=devops
export DB_PASSWORD=devops123
export DB_NAME=devops_app

# 3. Install Ansible
pip install ansible
ansible-galaxy collection install azure.azcollection
ansible-galaxy collection install community.docker

# 4. Create inventory
cat > ansible/inventory/hosts <<EOF
[app_servers]
azure-vm ansible_host=YOUR_VM_IP ansible_user=azureuser
EOF

# 5. Test connection
ansible app_servers -i ansible/inventory/hosts -m ping

# 6. Run playbook
cd ansible
ansible-playbook playbooks/setup-server.yml -i inventory/hosts -v
```

---

## 📈 Monitoring Deployment

### Real-time Logs

```bash
# SSH into VM
ssh azureuser@YOUR_VM_IP

# Follow backend logs
docker logs -f taskmanager-backend

# Follow frontend logs
docker logs -f taskmanager-frontend

# Follow all logs
docker-compose -f /home/azureuser/app/docker-compose.yml logs -f
```

### Resource Usage

```bash
# SSH into VM
ssh azureuser@YOUR_VM_IP

# Check disk usage
df -h

# Check memory usage
free -h

# Check docker stats
docker stats

# Check system load
uptime
top
```

### Application Health

```bash
# Health endpoint
curl http://YOUR_VM_IP:3000/health

# Should return:
{
  "status": "ok",
  "timestamp": "2025-11-22T05:24:47.000Z",
  "uptime": 123.456
}

# API endpoint
curl http://YOUR_VM_IP:3000/api/tasks

# Frontend
curl -I http://YOUR_VM_IP
```

---

## ✅ Success Criteria

Your deployment is successful when:

1. ✅ All three workflow jobs complete successfully
2. ✅ Docker images are in ACR with correct tags
3. ✅ All containers running on VM (`docker ps` shows 3 containers)
4. ✅ Health check returns 200 OK
5. ✅ Frontend loads in browser at `http://YOUR_VM_IP`
6. ✅ You can create, read, update, delete tasks
7. ✅ No errors in container logs

---

## 🎯 Quick Validation Steps

Run these commands to quickly validate deployment:

```bash
#!/bin/bash
VM_IP="YOUR_VM_IP"

echo "=== 1. Testing Frontend ==="
curl -f http://$VM_IP && echo "✅ Frontend OK" || echo "❌ Frontend FAILED"

echo ""
echo "=== 2. Testing Backend Health ==="
curl -f http://$VM_IP:3000/health && echo "✅ Health OK" || echo "❌ Health FAILED"

echo ""
echo "=== 3. Testing API ==="
curl -f http://$VM_IP:3000/api/tasks && echo "✅ API OK" || echo "❌ API FAILED"

echo ""
echo "=== 4. Testing Container Status (SSH required) ==="
ssh azureuser@$VM_IP "docker ps --format 'table {{.Names}}\t{{.Status}}'"

echo ""
echo "=== 5. Testing Logs for Errors (SSH required) ==="
ssh azureuser@$VM_IP "docker logs taskmanager-backend --tail 20 2>&1 | grep -i error"
```

---

## 📞 Getting Help

If you encounter issues:

1. **Check this guide** for common issues
2. **View GitHub Actions logs** for specific errors
3. **SSH into VM** and check container logs
4. **Test manually** using commands in this guide
5. **Create GitHub Issue** with:
   - Error message
   - Workflow run link
   - Container logs
   - Steps to reproduce

---

## 🔄 Quick Update Process

For subsequent deployments (after initial setup):

```bash
# 1. Make code changes
# 2. Commit and push
git add .
git commit -m "feat: add new feature"
git push origin main

# 3. CD pipeline auto-runs and:
#    - Builds new Docker images
#    - Pushes to ACR
#    - Pulls images on VM
#    - Recreates containers
#    - Verifies health

# 4. Check deployment
curl http://YOUR_VM_IP

# New changes should be live in ~5-10 minutes!
```

---

## 📚 Additional Resources

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Ansible Docs](https://docs.ansible.com/)
- [Azure Container Registry](https://learn.microsoft.com/en-us/azure/container-registry/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Project README](./README.md)

---

**Last Updated:** 2025-11-22  
**Version:** 2.0
