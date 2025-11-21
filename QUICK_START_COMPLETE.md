# 🚀 Quick Start Guide - Complete Workflow

This guide walks you through testing Docker locally AND deploying to Azure in the correct order.

---

## ⚡ Quick Path to Success

### **Part 1: Test Docker Locally** (15 minutes)

This validates your application works before deploying to Azure.

#### **Option A: Automated Script** (Recommended)

```powershell
# Run the automated script
.\test-docker-local.bat
```

#### **Option B: Manual Steps**

```powershell
# 1. Navigate to docker directory
cd infra\docker

# 2. Create .env file
copy .env.example .env

# 3. Start everything
docker compose up --build
```

#### **Verify It's Working**

1. **Frontend**: Open http://localhost in your browser
   - Should see the Task Manager UI
   - Can create, view, update, delete tasks

2. **Backend API**: Open http://localhost:4000/health
   - Should return: `{"status": "healthy", "database": "connected"}`

3. **Check Logs**:
   ```powershell
   docker compose logs -f
   ```

4. **Stop When Done**:
   ```powershell
   # Press Ctrl+C, then:
   docker compose down
   ```

---

### **Part 2: Create Azure Service Principal** (10 minutes)

#### **🌐 Azure Portal Method** (No CLI needed)

**Step 1: Open Azure Portal**
- Go to: https://portal.azure.com
- Sign in

**Step 2: Create App Registration**
1. Search for: **"App registrations"**
2. Click **"+ New registration"**
3. Name: `terraform-sp`
4. Account types: **"Accounts in this organizational directory only"**
5. Click **"Register"**

**Step 3: Copy Values** ✏️

| What to Copy | Where to Find It | Save As |
|--------------|------------------|---------|
| **Application (client) ID** | Overview page | `arm_client_id` |
| **Directory (tenant) ID** | Overview page | `arm_tenant_id` |

**Step 4: Create Client Secret**
1. Left menu: **"Certificates & secrets"**
2. Click **"+ New client secret"**
3. Description: `terraform-secret`
4. Expires: **6 months**
5. Click **"Add"**
6. **⚠️ IMMEDIATELY copy the "Value"** → Save as `arm_client_secret`

**Step 5: Get Subscription ID**
1. Search for: **"Subscriptions"**
2. Click on your subscription
3. Copy **"Subscription ID"** → Save as `arm_subscription_id`

**Step 6: Assign Contributor Role**
1. Still in Subscriptions: **Access control (IAM)**
2. Click **"+ Add"** → **"Add role assignment"**
3. Role: **"Contributor"**
4. Click **"Next"**
5. Click **"+ Select members"**
6. Search: `terraform-sp`
7. Select it, click **"Select"**
8. Click **"Review + assign"** (twice)

**Step 7: Update terraform.tfvars**

Open `terraform\terraform.tfvars` in WebStorm and fill in:

```hcl
# Azure Credentials
arm_client_id       = "PASTE_APPLICATION_CLIENT_ID"
arm_client_secret   = "PASTE_CLIENT_SECRET_VALUE"
arm_subscription_id = "PASTE_SUBSCRIPTION_ID"
arm_tenant_id       = "PASTE_DIRECTORY_TENANT_ID"

# Project Config
project_name   = "devopspipeline"
environment    = "dev"
location       = "East US"
vm_size        = "Standard_B2s"
admin_username = "azureuser"
ssh_public_key = "ssh-rsa YOUR_PUBLIC_KEY"
```

**Step 8: Generate SSH Key** (if needed)

```powershell
# Generate key
ssh-keygen -t rsa -b 4096 -C "azure-vm-key"

# View public key
cat ~\.ssh\id_rsa.pub
```

Copy the output (starts with `ssh-rsa`) into `ssh_public_key` field.

Save the file (Ctrl+S).

---

### **Part 3: Deploy to Azure** (10 minutes)

#### **Initialize Terraform**

```powershell
# From project root
terraform-docker.bat init
```

Expected output: `Terraform has been successfully initialized!`

#### **Preview What Will Be Created**

```powershell
terraform-docker.bat plan
```

You should see a plan to create:
- ✅ Resource Group
- ✅ Virtual Network & Subnet
- ✅ Network Security Group
- ✅ Public IP
- ✅ Network Interface
- ✅ Ubuntu VM (Standard_B2s)
- ✅ Azure Container Registry
- ✅ Role Assignment

**No authentication errors should appear!**

#### **Create the Infrastructure**

```powershell
terraform-docker.bat apply
```

Type `yes` when prompted.

**Wait 5-10 minutes** while Terraform provisions everything.

#### **Get the Outputs**

```powershell
cd terraform
terraform output
```

You'll see:
```
resource_group_name = "devopspipeline-dev-rg"
vm_public_ip        = "20.xxx.xxx.xxx"
acr_name            = "devopspipelinedevacr"
acr_login_server    = "devopspipelinedevacr.azurecr.io"
```

**Save these values!**

---

### **Part 4: Build & Push Docker Images** (10 minutes)

#### **Get ACR Name**

```powershell
cd terraform
terraform output acr_name
```

Copy the output (e.g., `devopspipelinedevacr`).

#### **Build Images for Azure**

```powershell
cd ..\infra\scripts
build-images.bat <ACR_NAME>
```

Replace `<ACR_NAME>` with the actual name from above.

#### **Login to Azure (if using CLI)**

```powershell
az acr login --name <ACR_NAME>
```

Or get credentials from Terraform:

```powershell
cd ..\..\terraform
terraform output acr_admin_username
terraform output acr_admin_password

# Use these to login
docker login <ACR_NAME>.azurecr.io -u <USERNAME> -p <PASSWORD>
```

#### **Push Images**

```powershell
cd ..\infra\scripts
push-images.bat <ACR_NAME>
```

---

### **Part 5: Verify Deployment** (5 minutes)

#### **Check Azure Resources**

Open Azure Portal:
- ✅ Resource Group created
- ✅ VM running
- ✅ ACR has images

#### **SSH into VM**

```powershell
# Get VM IP
cd terraform
terraform output vm_public_ip

# SSH (replace with your actual IP)
ssh -i ~\.ssh\id_rsa azureuser@<VM_PUBLIC_IP>
```

#### **Check Docker Images in ACR**

```powershell
az acr repository list --name <ACR_NAME> --output table
```

Should show:
- `tm-backend`
- `tm-frontend`

---

## 📊 Complete Timeline

| Step | Time | Task |
|------|------|------|
| **1** | 15 min | Test Docker locally |
| **2** | 10 min | Create Azure Service Principal |
| **3** | 10 min | Deploy infrastructure with Terraform |
| **4** | 10 min | Build & push Docker images |
| **5** | 5 min | Verify everything works |
| **Total** | **~50 minutes** | Complete deployment |

---

## ✅ Success Checklist

### **Docker Local Testing**
- [ ] Ran `test-docker-local.bat` or `docker compose up --build`
- [ ] Frontend accessible at http://localhost
- [ ] Backend health check passes at http://localhost:4000/health
- [ ] Can create/view tasks in UI
- [ ] Stopped containers with `docker compose down`

### **Azure Service Principal**
- [ ] Created App Registration in Azure Portal
- [ ] Copied Application (client) ID
- [ ] Copied Directory (tenant) ID
- [ ] Created Client Secret and copied value
- [ ] Got Subscription ID
- [ ] Assigned Contributor role
- [ ] Filled `terraform/terraform.tfvars` with all 4 values
- [ ] Generated SSH key and added to tfvars
- [ ] Saved the file

### **Terraform Deployment**
- [ ] Ran `terraform-docker.bat init` successfully
- [ ] Ran `terraform-docker.bat plan` (no auth errors)
- [ ] Ran `terraform-docker.bat apply` and typed `yes`
- [ ] All resources created successfully
- [ ] Got outputs (VM IP, ACR name)

### **Docker Images**
- [ ] Built images with `build-images.bat`
- [ ] Logged in to ACR
- [ ] Pushed images with `push-images.bat`
- [ ] Verified images in Azure Portal

---

## 🆘 Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| **Docker not running** | Start Docker Desktop |
| **Port 80 in use** | Stop other services or change port in `docker-compose.yml` |
| **Invalid tenant** | Double-check `arm_tenant_id` in `terraform.tfvars` |
| **Terraform auth error** | Verify all 4 values in `terraform.tfvars` are correct |
| **ACR login fails** | Run `terraform output acr_admin_username` and use those credentials |
| **Can't SSH to VM** | Check NSG rules, verify SSH key matches |

---

## 📚 Detailed Guides

For more details, see:
- **DOCKER_TESTING_GUIDE.md** - Complete Docker testing instructions
- **AZURE_SP_GUIDE.md** - Detailed Service Principal creation
- **INFRASTRUCTURE_SUMMARY.md** - Overview of everything
- **infra/terraform/README.md** - Terraform troubleshooting

---

## 🎉 What You'll Have at the End

- ✅ Working local Docker environment
- ✅ Complete Azure infrastructure (VM, VNet, NSG, ACR)
- ✅ Docker images pushed to Azure Container Registry
- ✅ Ready to deploy containers to Azure VM

---

## 🚀 Ready to Start?

Run this first:

```powershell
.\test-docker-local.bat
```

Then follow the guide above! Good luck! 🎯

---

**Created**: 2025-11-21  
**Total Time Required**: ~50 minutes
