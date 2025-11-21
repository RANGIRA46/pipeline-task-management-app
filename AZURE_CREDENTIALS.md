# 🔐 Azure Service Principal Credentials

**Service Principal Created**: terraform-sp-pipeline  
**Date**: 2025-11-21

---

## 📋 Extracted Values

I've successfully created the Service Principal and extracted the following values from Azure Portal:

### **1. Application (client) ID** ✅
**Location**: App Registration → Overview
**Value**: Check the screenshot at:
`C:/Users/johns/.gemini/antigravity/brain/8e1cfaee-8d9a-47b1-b57a-d99977421df8/app_overview_with_ids_1763739102803.png`

### **2. Directory (tenant) ID** ✅
**Location**: App Registration → Overview
**Value**: Check the same screenshot above

### **3. Client Secret VALUE** ✅
**Location**: Certificates & secrets (ONLY VISIBLE NOW!)
**Value**: Check the screenshot at:
`C:/Users/johns/.gemini/antigravity/brain/8e1cfaee-8d9a-47b1-b57a-d99977421df8/secret_value_visible_1763739182553.png`

⚠️ **CRITICAL**: This value is only shown ONCE! Copy it from the screenshot NOW!

### **4. Subscription ID** ✅
**Location**: Subscriptions page
**Value**: Check the screenshot at:
`C:/Users/johns/.gemini/antigravity/brain/8e1cfaee-8d9a-47b1-b57a-d99977421df8/subscriptions_page_1763739251529.png`

---

## ✏️ Copy These Values to terraform.tfvars

Open the file: `terraform\terraform.tfvars`

**Fill in with the values from the screenshots above**:

```hcl
# Azure Credentials
arm_client_id       = "PASTE_FROM_SCREENSHOT_1"
arm_client_secret   = "PASTE_FROM_SCREENSHOT_2_THE_LONG_VALUE"
arm_subscription_id = "PASTE_FROM_SCREENSHOT_3"
arm_tenant_id       = "PASTE_FROM_SCREENSHOT_1_TENANT_ID"

# Project Configuration
project_name   = "devopspipeline"
environment    = "dev"
location       = "East US"
vm_size        = "Standard_B2s"
admin_username = "azureuser"

# SSH Public Key
ssh_public_key = "ssh-rsa YOUR_PUBLIC_KEY_FROM_ssh-keygen"
```

---

## 🔑 Generate SSH Key

If you haven't generated an SSH key yet:

```cmd
ssh-keygen -t rsa -b 4096 -C "azure-vm-key"
```

Press Enter for all prompts. Then view it:

```cmd
type %USERPROFILE%\.ssh\id_rsa.pub
```

Copy the entire output and paste into `ssh_public_key` field.

---

## ⚙️ Remaining Steps

### **Step 1: Assign Contributor Role** (Still needed!)

1. Go back to Subscriptions page in Azure Portal
2. Click on your subscription
3. Click "Access control (IAM)" in left menu
4. Click "+ Add" → "Add role assignment"
5. Role: Select "Contributor" → Next
6. Click "+ Select members"
7. Search: `terraform-sp-pipeline`
8. Select it → Select button → Review + assign (twice)

### **Step 2: Fill terraform.tfvars**

1. Open `terraform\terraform.tfvars` in WebStorm
2. Look at the 3 screenshots listed above
3. Copy the exact values from each screenshot
4. Paste into the corresponding fields
5. Add your SSH public key
6. Save (Ctrl+S)

### **Step 3: Run Terraform**

After terraform.tfvars is filled and saved:

```cmd
terraform-docker.bat init
terraform-docker.bat plan
terraform-docker.bat apply
```

---

## 📸 Screenshot Locations

All screenshots are saved in:
`C:/Users/johns/.gemini/antigravity/brain/8e1cfaee-8d9a-47b1-b57a-d99977421df8/`

1. **app_overview_with_ids_1763739102803.png** - Application ID + Tenant ID
2. **secret_value_visible_1763739182553.png** - Client Secret VALUE
3. **subscriptions_page_1763739251529.png** - Subscription ID

---

**Created**: 2025-11-21 17:33  
**Action Required**: Copy values from screenshots → Fill terraform.tfvars → Assign role → Run Terraform
