# 🔐 GitHub Secrets Verification Checklist

## Required Secrets for CD Pipeline

Use this checklist to ensure all required secrets are configured in GitHub.

**Location:** Settings → Secrets and variables → Actions

---

## ✅ Secrets Checklist

### Azure Container Registry (ACR)

- [ ] **ACR_LOGIN_SERVER**
  - Format: `yourregistry.azurecr.io`
  - How to get: Azure Portal → Container Registry → Properties → Login server
  
- [ ] **ACR_NAME**
  - Format: `yourregistryname` (without .azurecr.io)
  - How to get: Azure Portal → Container Registry → Overview → Name
  
- [ ] **ACR_USERNAME**
  - Option 1: Admin username from ACR Access Keys
  - Option 2: Service Principal client ID
  - How to get: Azure Portal → Container Registry → Access keys → Username
  
- [ ] **ACR_PASSWORD**
  - Option 1: Admin password from ACR Access Keys
  - Option 2: Service Principal secret
  - How to get: Azure Portal → Container Registry → Access keys → Password

### Azure Service Principal

- [ ] **ARM_CLIENT_ID**
  - Format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` (UUID)
  - How to create:
    ```bash
    az ad sp create-for-rbac --name "github-actions-sp" \
      --role contributor \
      --scopes /subscriptions/YOUR_SUBSCRIPTION_ID \
      --sdk-auth
    ```
  
- [ ] **ARM_CLIENT_SECRET**
  - Format: Random string generated during SP creation
  - ⚠️ **Important:** Save this immediately, you can't retrieve it later!
  
- [ ] **ARM_TENANT_ID**
  - Format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` (UUID)
  - How to get: Azure Portal → Azure Active Directory → Properties → Tenant ID

### Azure Virtual Machine

- [ ] **VM_PUBLIC_IP**
  - Format: `XX.XX.XX.XX` (IP address)
  - How to get: Azure Portal → Virtual Machine → Networking → Public IP address
  
- [ ] **SSH_PRIVATE_KEY**
  - Format: Full private key including header and footer
  - How to generate:
    ```bash
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_vm_key -N ""
    cat ~/.ssh/azure_vm_key  # Copy this entire output
    ```
  - Should start with: `-----BEGIN OPENSSH PRIVATE KEY-----`
  - Should end with: `-----END OPENSSH PRIVATE KEY-----`

### Database Configuration

- [ ] **DB_USER**
  - Default: `devops`
  - Can be any username you prefer
  
- [ ] **DB_PASSWORD**
  - Should be strong password
  - Example: `SecurePassword123!`
  - ⚠️ **Important:** Don't use default in production!
  
- [ ] **DB_NAME**
  - Default: `devops_app`
  - Can be any database name you prefer

---

## 🔍 Verification Commands

### Test ACR Authentication

```bash
# Login to Azure
az login

# Test ACR login with admin credentials
az acr login --name YOUR_ACR_NAME

# OR test with Service Principal
az login --service-principal \
  --username $ARM_CLIENT_ID \
  --password $ARM_CLIENT_SECRET \
  --tenant $ARM_TENANT_ID

az acr login --name YOUR_ACR_NAME
```

### Test SSH Access

```bash
# Test SSH connection to VM
ssh -i ~/.ssh/azure_vm_key azureuser@YOUR_VM_IP

# If successful, you should see Ubuntu welcome message
```

### Test Service Principal Permissions

```bash
# Login with SP
az login --service-principal \
  --username $ARM_CLIENT_ID \
  --password $ARM_CLIENT_SECRET \
  --tenant $ARM_TENANT_ID

# Test ACR access
az acr repository list --name YOUR_ACR_NAME

# Test VM access
az vm list --output table
```

---

## 📝 Step-by-Step Setup Guide

### Step 1: Create Azure Container Registry

```bash
# Create resource group (if not exists)
az group create --name taskmanager-rg --location eastus

# Create ACR
az acr create \
  --resource-group taskmanager-rg \
  --name youruniqueacrname \
  --sku Basic

# Enable admin user (for simpler auth)
az acr update --name youruniqueacrname --admin-enabled true

# Get credentials
az acr credential show --name youruniqueacrname
```

**Add to GitHub Secrets:**
- ACR_LOGIN_SERVER: From `az acr show --name youruniqueacrname --query loginServer`
- ACR_NAME: `youruniqueacrname`
- ACR_USERNAME: From `az acr credential show`
- ACR_PASSWORD: From `az acr credential show`

### Step 2: Create Service Principal

```bash
# Get your subscription ID
az account show --query id --output tsv

# Create service principal
az ad sp create-for-rbac \
  --name "github-actions-taskmanager" \
  --role contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/taskmanager-rg \
  --sdk-auth

# Save the entire JSON output!
```

**Extract from JSON and add to GitHub Secrets:**
- ARM_CLIENT_ID: `clientId` field
- ARM_CLIENT_SECRET: `clientSecret` field
- ARM_TENANT_ID: `tenantId` field

### Step 3: Grant ACR Permissions to Service Principal

```bash
# Get ACR resource ID
ACR_ID=$(az acr show --name youruniqueacrname --query id --output tsv)

# Grant AcrPush role to service principal
az role assignment create \
  --assignee $ARM_CLIENT_ID \
  --role AcrPush \
  --scope $ACR_ID

# Grant AcrPull role
az role assignment create \
  --assignee $ARM_CLIENT_ID \
  --role AcrPull \
  --scope $ACR_ID
```

### Step 4: Create Azure VM

```bash
# Generate SSH key if not exists
ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_vm_key -N ""

# Create VM
az vm create \
  --resource-group taskmanager-rg \
  --name taskmanager-vm \
  --image UbuntuLTS \
  --size Standard_B2s \
  --admin-username azureuser \
  --ssh-key-values ~/.ssh/azure_vm_key.pub \
  --public-ip-sku Standard

# Get public IP
az vm list-ip-addresses \
  --resource-group taskmanager-rg \
  --name taskmanager-vm \
  --output table

# Open required ports
az vm open-port --port 80 --resource-group taskmanager-rg --name taskmanager-vm --priority 1001
az vm open-port --port 3000 --resource-group taskmanager-rg --name taskmanager-vm --priority 1002
az vm open-port --port 22 --resource-group taskmanager-rg --name taskmanager-vm --priority 1003
```

**Add to GitHub Secrets:**
- VM_PUBLIC_IP: From `az vm list-ip-addresses` command
- SSH_PRIVATE_KEY: Content of `~/.ssh/azure_vm_key` file

### Step 5: Set Database Credentials

**Add to GitHub Secrets:**
- DB_USER: `devops`
- DB_PASSWORD: Choose a strong password
- DB_NAME: `devops_app`

---

## 🧪 Test Secrets Configuration

Create a test workflow to verify secrets are configured correctly:

```yaml
name: Test Secrets

on: workflow_dispatch

jobs:
  test-secrets:
    runs-on: ubuntu-latest
    steps:
      - name: Check ACR Secrets
        run: |
          echo "ACR_LOGIN_SERVER: ${{ secrets.ACR_LOGIN_SERVER != '' && '✅ Set' || '❌ Not Set' }}"
          echo "ACR_NAME: ${{ secrets.ACR_NAME != '' && '✅ Set' || '❌ Not Set' }}"
          echo "ACR_USERNAME: ${{ secrets.ACR_USERNAME != '' && '✅ Set' || '❌ Not Set' }}"
          echo "ACR_PASSWORD: ${{ secrets.ACR_PASSWORD != '' && '✅ Set' || '❌ Not Set' }}"
      
      - name: Check Azure Secrets
        run: |
          echo "ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID != '' && '✅ Set' || '❌ Not Set' }}"
          echo "ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET != '' && '✅ Set' || '❌ Not Set' }}"
          echo "ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID != '' && '✅ Set' || '❌ Not Set' }}"
      
      - name: Check VM Secrets
        run: |
          echo "VM_PUBLIC_IP: ${{ secrets.VM_PUBLIC_IP != '' && '✅ Set' || '❌ Not Set' }}"
          echo "SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY != '' && '✅ Set' || '❌ Not Set' }}"
      
      - name: Check DB Secrets
        run: |
          echo "DB_USER: ${{ secrets.DB_USER != '' && '✅ Set' || '❌ Not Set' }}"
          echo "DB_PASSWORD: ${{ secrets.DB_PASSWORD != '' && '✅ Set' || '❌ Not Set' }}"
          echo "DB_NAME: ${{ secrets.DB_NAME != '' && '✅ Set' || '❌ Not Set' }}"
```

Save this to `.github/workflows/test-secrets.yml` and run it manually to verify all secrets are set.

---

## 📋 Quick Reference Table

| Secret | Required | Format | Common Issues |
|--------|----------|--------|--------------|
| ACR_LOGIN_SERVER | Yes | `name.azurecr.io` | Missing `.azurecr.io` |
| ACR_NAME | Yes | `name` | Including `.azurecr.io` |
| ACR_USERNAME | Yes | String | Wrong credentials |
| ACR_PASSWORD | Yes | String | Expired password |
| ARM_CLIENT_ID | Yes | UUID | Using wrong ID |
| ARM_CLIENT_SECRET | Yes | String | Not saved during creation |
| ARM_TENANT_ID | Yes | UUID | Wrong tenant |
| VM_PUBLIC_IP | Yes | IP address | Using private IP |
| SSH_PRIVATE_KEY | Yes | Full key | Missing header/footer |
| DB_USER | Yes | String | - |
| DB_PASSWORD | Yes | String | Too weak |
| DB_NAME | Yes | String | - |

---

## ⚠️ Common Mistakes

1. **ACR_NAME includes `.azurecr.io`** - Should be just the name
2. **SSH_PRIVATE_KEY is public key** - Should be private key (starts with `-----BEGIN`)
3. **VM_PUBLIC_IP is private IP** - Must be public IP accessible from internet
4. **ARM_CLIENT_SECRET not saved** - Can't retrieve after creation, must recreate
5. **Service Principal lacks ACR permissions** - Must grant AcrPush and AcrPull roles

---

## ✅ Final Checklist

Before running CD pipeline, ensure:

- [ ] All 12 secrets are configured in GitHub
- [ ] ACR is created and accessible
- [ ] Service Principal has contributor role on resource group
- [ ] Service Principal has AcrPush/Pull roles on ACR
- [ ] VM is created and running
- [ ] VM has ports 22, 80, 3000 open in NSG
- [ ] SSH key works: `ssh azureuser@VM_IP`
- [ ] ACR login works: `az acr login --name ACR_NAME`

---

## 🎯 Next Steps

Once all secrets are configured:

1. **Commit and push** your code changes
2. **Trigger CD pipeline** via push to main or workflow_dispatch
3. **Monitor workflow** in GitHub Actions
4. **Verify deployment** at `http://YOUR_VM_IP`

---

**Need Help?**
- See: [CD_DEBUG_GUIDE.md](./CD_DEBUG_GUIDE.md)
- See: [README.md](./README.md)

---

**Last Updated:** 2025-11-22  
**Version:** 1.0
