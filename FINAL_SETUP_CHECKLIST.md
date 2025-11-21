cd# ✅ FINAL SETUP CHECKLIST

**Created**: 2025-11-21 17:35  
**Status**: Service Principal created ✅ | terraform.tfvars needs filling ⏳

---

## 🎯 CURRENT STATUS

### ✅ **Completed**
- [x] Created Azure Service Principal: `terraform-sp-pipeline`
- [x] Extracted Application (client) ID
- [x] Extracted Directory (tenant) ID  
- [x] Created Client Secret (VALUE visible in screenshot)
- [x] Extracted Subscription ID
- [x] Attempted to assign Contributor role (verify in Azure Portal)

### ⏳ **Pending**
- [ ] Copy values from screenshots
- [ ] Fill `terraform/terraform.tfvars`
- [ ] Generate/copy SSH public key
- [ ] Verify Contributor role assignment
- [ ] Run Terraform init/plan/apply

---

## 📸 STEP 1: View Screenshots & Copy Values

All screenshots are in:
```
C:\Users\johns\.gemini\antigravity\brain\8e1cfaee-8d9a-47b1-b57a-d99977421df8\
```

### **Screenshot 1**: Application & Tenant IDs
**File**: `app_overview_with_ids_1763739102803.png`

**Copy these 2 values**:
- [ ] **Application (client) ID**: `________-____-____-____-____________`
- [ ] **Directory (tenant) ID**: `________-____-____-____-____________`

### **Screenshot 2**: Client Secret VALUE ⚠️
**File**: `secret_value_visible_1763739182553.png`

**CRITICAL**: This value is ONLY shown ONCE!

- [ ] **Client Secret VALUE**: `________________________________________`
      (Look in the "Value" column - it's a long string)

### **Screenshot 3**: Subscription ID
**File**: `subscriptions_page_1763739251529.png`

- [ ] **Subscription ID**: `________-____-____-____-____________`

---

## 🔑 STEP 2: Generate SSH Key

Open **Command Prompt** and run:

```cmd
ssh-keygen -t rsa -b 4096 -C "azure-vm-key"
```

Press **Enter** for all prompts (accept defaults, no passphrase).

Then view the public key:

```cmd
type %USERPROFILE%\.ssh\id_rsa.pub
```

**Copy the ENTIRE output** (starts with `ssh-rsa`, ends with email):

- [ ] **SSH Public Key**: `ssh-rsa AAAA... azure-vm-key`

---

## ✏️ STEP 3: Fill terraform/terraform.tfvars

**Method 1**: Use the template file I created

1. Open: `terraform.tfvars.template`
2. Fill in the 5 values you copied above
3. Save as: `terraform/terraform.tfvars` (remove `.template`)

**Method 2**: Edit directly in WebStorm

You already have `terraform/terraform.tfvars` open. Fill it with:

```hcl
# Azure Credentials
arm_client_id       = "PASTE_FROM_SCREENSHOT_1"
arm_client_secret   = "PASTE_FROM_SCREENSHOT_2"
arm_subscription_id = "PASTE_FROM _3"
arm_tenant_id       = "PASTE_FROM_SCREENSHOT_1"

# Project Configuration
project_name   = "devopspipeline"
environment    = "dev"
location       = "East US"
vm_size        = "Standard_B2s"
admin_username = "azureuser"

# SSH Public Key
ssh_public_key = "ssh-rsa YOUR_FULL_PUBLIC_KEY"
```

**Save** (Ctrl+S)

---

## ⚙️ STEP 4: Verify Contributor Role (Optional but Recommended)

In Azure Portal:

1. Go to **Subscriptions**
2. Click your subscription
3. Click **Access control (IAM)**
4. Click **Role assignments** tab
5. Look for **terraform-sp-pipeline** under Contributor role

If not there:
1. Click **+ Add** → **Add role assignment**
2. Select **Contributor** → Next
3. Click **+ Select members**
4. Search: `terraform-sp-pipeline`
5. Select it → Select → Review + assign (twice)

---

## 🚀 STEP 5: Run Terraform Commands

After `terraform/terraform.tfvars` is filled and saved:

### **Command 1**: Initialize Terraform

```cmd
terraform-docker.bat init
```

**Expected output**:
```
Terraform has been successfully initialized!
```

### **Command 2**: Review Infrastructure Plan

```cmd
terraform-docker.bat plan
```

**Expected output**:
```
Plan: 10 to add, 0 to change, 0 to destroy.
```

### **Command 3**: Deploy to Azure

```cmd
terraform-docker.bat apply
```

Type `yes` when prompted.

**Expected output** (after 5-10 minutes):
```
Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

Outputs:
vm_public_ip = "20.xxx.xxx.xxx"
acr_name = "devopspipelinedevacr"
acr_login_server = "devopspipelinedevacr.azurecr.io"
```

---

## 📋 Quick Reference

| Screenshot | Contains | Variable |
|------------|----------|----------|
| Screenshot 1 | Application ID | `arm_client_id` |
| Screenshot 1 | Tenant ID | `arm_tenant_id` |
| Screenshot 2 | Client Secret | `arm_client_secret` |
| Screenshot 3 | Subscription ID | `arm_subscription_id` |
| SSH command output | Public Key | `ssh_public_key` |

---

## 🎯 WHAT TO DO RIGHT NOW

1. **Open Windows Explorer** → Navigate to:
   ```
   C:\Users\johns\.gemini\antigravity\brain\8e1cfaee-8d9a-47b1-b57a-d99977421df8\
   ```

2. **Open these 3 images**:
   - `app_overview_with_ids_1763739102803.png`
   - `secret_value_visible_1763739182553.png`
   - `subscriptions_page_1763739251529.png`

3. **Copy the values** from each screenshot

4. **Open** `terraform/terraform.tfvars` in WebStorm

5. **Paste** the values

6. **Generate SSH key** (if not already done)

7. **Save** the file

8. **Run** the Terraform commands

---

## ✅ Success Indicators

After `terraform apply` completes successfully:

- ✅ Azure Resource Group created
- ✅ Virtual Network created
- ✅ Virtual Machine created
- ✅ Azure Container Registry created
- ✅ Network Security Group configured
- ✅ Public IP assigned
- ✅ All outputs displayed (VM IP, ACR name, etc.)

---

**Need Help?**  
- Screenshots not clear? Check `AZURE_CREDENTIALS.md`
- Template confusing? Use `terraform.tfvars.template`
- Commands failing? Ensure file is saved as `terraform/terraform.tfvars`

**Next After Terraform**:
1. Build Docker images
2. Push to Azure Container Registry
3. Deploy containers to VM

---

**Updated**: 2025-11-21 17:36
