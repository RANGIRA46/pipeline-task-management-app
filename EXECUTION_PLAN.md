# 🎯 EXECUTION PLAN - Docker + Azure Deployment

**Current Status**: Infrastructure files ready, awaiting execution  
**Estimated Total Time**: 50 minutes  
**Your Goal**: Test locally + Deploy to Azure

---

## 📋 **What You Need to Execute Now**

### **Terminal Commands to Run**

Open **PowerShell** or **CMD** in the project root and execute these in order:

---

## ✅ **STEP 1: Test Docker Locally** (15 min)

### **Execute This Command**:

```cmd
test-docker-local.bat
```

### **What It Does**:
1. ✓ Checks if Docker is installed
2. ✓ Checks if Docker Desktop is running
3. ✓ Creates `.env` file in `infra/docker/`
4. ✓ Starts all 3 containers (database, backend, frontend)

### **Expected Output**:
```
[1/5] Checking Docker installation...
[OK] Docker is installed

[2/5] Checking if Docker is running...
[OK] Docker is running

[3/5] Navigating to Docker directory...
[OK] Changed directory

[4/5] Setting up environment file...
[OK] Created .env from .env.example

[5/5] Starting Docker containers...
This will:
  - Download required images (first time only)
  - Build backend (TypeScript compilation)
  - Build frontend (Vite production build)
  - Start PostgreSQL database
  - Start all services

Starting in 3 seconds...
[+] Building...
[+] Running 4/4
 ✔ Container tm-db        Started
 ✔ Container tm-backend   Started
 ✔ Container tm-frontend  Started
```

### **Verify Success**:

1. **Open Browser**: http://localhost
   - ✓ Task Manager UI loads
   - ✓ Can see sample tasks
   - ✓ Can create new tasks

2. **Check API**: http://localhost:4000/health
   - ✓ Returns: `{"status": "healthy", "database": "connected"}`

3. **Check Logs** (in another terminal):
   ```cmd
   cd infra\docker
   docker compose logs -f
   ```

### **Stop Docker** (when done testing):
```cmd
# Press Ctrl+C in the running terminal, then:
cd infra\docker
docker compose down
```

---

## 🔐 **STEP 2: Create Azure Service Principal** (10 min)

### **Method: Azure Portal** (Recommended)

**IMPORTANT**: You need to do this **manually** in your browser.

#### **Execute These Actions**:

1. **Open**: https://portal.azure.com (login)

2. **Search**: Type "App registrations" → Click it

3. **Create**:
   - Click **"+ New registration"**
   - Name: `terraform-sp`
   - Account types: **"Accounts in this organizational directory only"**
   - Click **"Register"**

4. **Copy Values** (write these down):

   | Value to Copy | Where | Variable Name |
   |---------------|-------|---------------|
   | **Application (client) ID** | Overview page | `arm_client_id` |
   | **Directory (tenant) ID** | Overview page | `arm_tenant_id` |

5. **Create Secret**:
   - Left menu: **"Certificates & secrets"**
   - **"+ New client secret"**
   - Description: `terraform-secret`, Expires: 6 months
   - **IMMEDIATELY COPY THE VALUE** → `arm_client_secret`

6. **Get Subscription**:
   - Search: **"Subscriptions"**
   - Click your subscription
   - Copy **Subscription ID** → `arm_subscription_id`

7. **Assign Role**:
   - In Subscriptions: **Access control (IAM)**
   - **"+ Add"** → **"Add role assignment"**
   - Role: **"Contributor"** → Next
   - **"+ Select members"** → Search `terraform-sp` → Select → Select button
   - **"Review + assign"** (click twice)

8. **Generate SSH Key** (if needed):
   ```cmd
   ssh-keygen -t rsa -b 4096 -C "azure-vm-key"
   # Press Enter for all prompts
   
   # View public key
   type %USERPROFILE%\.ssh\id_rsa.pub
   ```

9. **Edit File**: `terraform\terraform.tfvars`

   Replace placeholders with your values:
   ```hcl
   arm_client_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
   arm_client_secret   = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   arm_subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
   arm_tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
   
   project_name   = "devopspipeline"
   environment    = "dev"
   location       = "East US"
   vm_size        = "Standard_B2s"
   admin_username = "azureuser"
   ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EA... (paste full key)"
   ```

   **SAVE THE FILE** (Ctrl+S)

---

## ☁️ **STEP 3: Deploy to Azure with Terraform** (10 min)

### **Execute These Commands** (from project root):

#### **3.1 Initialize Terraform**
```cmd
terraform-docker.bat init
```

**Expected**:
```
Terraform has been successfully initialized!
```

#### **3.2 Preview Infrastructure**
```cmd
terraform-docker.bat plan
```

**Expected**:
- No authentication errors
- Shows plan to create ~10 resources
- Lists: Resource Group, VNet, Subnet, NSG, VM, ACR, etc.

#### **3.3 Create Infrastructure**
```cmd
terraform-docker.bat apply
```

**Type**: `yes` when prompted

**Expected**:
```
Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

Outputs:
resource_group_name = "devopspipeline-dev-rg"
vm_public_ip = "20.xxx.xxx.xxx"
acr_name = "devopspipelinedevacr"
acr_login_server = "devopspipelinedevacr.azurecr.io"
```

**⏱️ Wait**: 5-10 minutes

#### **3.4 Save Outputs**
```cmd
cd terraform
terraform output > azure-outputs.txt
type azure-outputs.txt
```

**Copy the ACR name for next step!**

---

## 🐳 **STEP 4: Build & Push Docker Images** (10 min)

### **Execute These Commands**:

#### **4.1 Build Images**
```cmd
cd infra\scripts
build-images.bat devopspipelinedevacr
```

Replace `devopspipelinedevacr` with your actual ACR name from Step 3.4.

**Expected**:
```
[INFO] Building backend image...
[INFO] Building frontend image...
[SUCCESS] Images built successfully!
```

#### **4.2 Get ACR Credentials**
```cmd
cd ..\..\terraform
terraform output acr_admin_username
terraform output acr_admin_password
```

**Copy these values**

#### **4.3 Login to ACR**
```cmd
docker login devopspipelinedevacr.azurecr.io -u <USERNAME> -p <PASSWORD>
```

Replace with actual values from 4.2.

**Expected**:
```
Login Succeeded
```

#### **4.4 Push Images**
```cmd
cd ..\infra\scripts
push-images.bat devopspipelinedevacr
```

**Expected**:
```
[INFO] Pushing backend image...
[INFO] Pushing frontend image...
[SUCCESS] All images pushed successfully!
```

---

## ✅ **STEP 5: Verify Everything** (5 min)

### **Check Azure Portal**:

1. Go to: https://portal.azure.com
2. Search: **"Resource groups"**
3. Click: `devopspipeline-dev-rg`
4. Verify:
   - ✓ Virtual machine running
   - ✓ Container registry exists
   - ✓ Virtual network created
   - ✓ All resources present

### **Check Container Registry**:

1. Click: **Azure Container Registry** (`devopspipelinedevacr`)
2. Left menu: **Repositories**
3. Should see:
   - ✓ `tm-backend`
   - ✓ `tm-frontend`

### **SSH into VM**:

```cmd
cd terraform
terraform output vm_public_ip
```

Copy the IP, then:

```cmd
ssh -i %USERPROFILE%\.ssh\id_rsa azureuser@<VM_PUBLIC_IP>
```

Replace `<VM_PUBLIC_IP>` with actual IP.

**Expected**: Connected to Ubuntu VM

---

## 📊 **Execution Checklist**

Use this checklist to track your progress:

### **Docker Local Testing**
- [ ] Ran `test-docker-local.bat`
- [ ] Frontend accessible at http://localhost
- [ ] Backend health check passes
- [ ] Can create tasks in UI
- [ ] Stopped containers (`docker compose down`)

### **Azure Service Principal**
- [ ] Opened Azure Portal
- [ ] Created App Registration
- [ ] Copied Application (client) ID
- [ ] Copied Directory (tenant) ID
- [ ] Created Client Secret
- [ ] Copied Client Secret value
- [ ] Got Subscription ID
- [ ] Assigned Contributor role
- [ ] Generated SSH key
- [ ] Filled `terraform/terraform.tfvars`
- [ ] Saved the file

### **Terraform Deployment**
- [ ] Ran `terraform-docker.bat init`
- [ ] Ran `terraform-docker.bat plan` (no errors)
- [ ] Ran `terraform-docker.bat apply`
- [ ] Typed `yes` and waited
- [ ] All resources created
- [ ] Saved outputs

### **Docker Images**
- [ ] Ran `build-images.bat <ACR_NAME>`
- [ ] Got ACR credentials from Terraform
- [ ] Logged into ACR
- [ ] Ran `push-images.bat <ACR_NAME>`
- [ ] Images pushed successfully

### **Verification**
- [ ] Checked Azure Portal resources
- [ ] Verified images in ACR
- [ ] SSH'd into VM successfully

---

## 🆘 **If You Get Stuck**

| Error | Guide to Read |
|-------|---------------|
| Docker not running | `DOCKER_TESTING_GUIDE.md` |
| Azure Portal confusion | `AZURE_SP_GUIDE.md` |
| Terraform auth error | Check `terraform/terraform.tfvars` values |
| ACR login fails | Use credentials from `terraform output` |
| General questions | `QUICK_START_COMPLETE.md` |

---

## 🎯 **Quick Commands Reference**

```cmd
# Test Docker
test-docker-local.bat

# Terraform
terraform-docker.bat init
terraform-docker.bat plan
terraform-docker.bat apply
cd terraform && terraform output

# Build & Push
cd infra\scripts
build-images.bat <ACR_NAME>
push-images.bat <ACR_NAME>

# Stop Docker
cd infra\docker
docker compose down
```

---

## 🎉 **Success Criteria**

**You're done when**:
- ✅ Docker works locally (tested)
- ✅ Azure infrastructure created (10 resources)
- ✅ Docker images in Azure Container Registry
- ✅ Can SSH into Azure VM

---

## 📅 **Next Steps After This**

Once everything above is complete:

1. **Deploy containers to VM** (using Ansible or manual Docker commands)
2. **Configure DNS** (point domain to VM public IP)
3. **Set up CI/CD** (GitHub Actions auto-deploy)
4. **Add monitoring** (Azure Monitor, Application Insights)

---

**START HERE**: Run `test-docker-local.bat` now! 🚀

**Created**: 2025-11-21
