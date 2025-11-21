# 🔐 Azure Service Principal Creation Guide

Complete guide for creating an Azure Service Principal for Terraform authentication.

---

## 📋 What You Need

At the end of this process, you'll have **4 values** to put in `terraform/terraform.tfvars`:

| Variable | What it is |
|----------|------------|
| `arm_client_id` | Application (client) ID |
| `arm_client_secret` | Client secret value |
| `arm_subscription_id` | Azure subscription ID |
| `arm_tenant_id` | Directory (tenant) ID |

---

## 🌐 Method 1: Azure Portal (Recommended - No CLI Needed)

### **Step 1: Open Azure Portal**
1. Go to: **https://portal.azure.com**
2. Sign in with your Azure account (must have Owner/Contributor rights)

---

### **Step 2: Create App Registration (Service Principal)**

1. In the **search bar** at the top, type: **"App registrations"**
2. Click **"App registrations"** from the results
3. Click **"+ New registration"** button

**Fill in the form**:
- **Name**: `terraform-sp` (or any name you prefer)
- **Supported account types**: Select **"Accounts in this organizational directory only"**
- **Redirect URI**: Leave blank
- Click **"Register"**

---

### **Step 3: Copy Application (Client) ID** ✏️

After registration completes, you'll see the **Overview** page.

1. Find **"Application (client) ID"**
2. **Copy this value** (format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`)
3. Save it in Notepad as: **`arm_client_id`**

**Screenshot location**: Application > Overview > Application (client) ID

---

### **Step 4: Copy Directory (Tenant) ID** ✏️

1. On the same **Overview** page, find **"Directory (tenant) ID"**
2. **Copy this value**
3. Save it in Notepad as: **`arm_tenant_id`**

---

### **Step 5: Create Client Secret** ✏️

1. In the left menu, click **"Certificates & secrets"**
2. Click **"+ New client secret"**
3. **Description**: `terraform-secret`
4. **Expires**: Choose **6 months** or **1 year**
5. Click **"Add"**

**⚠️ IMPORTANT - COPY IMMEDIATELY**:
- You'll see a **"Value"** column
- **Copy the entire secret value** (long string starting with letters/numbers)
- **You can ONLY see this ONCE** - if you navigate away, you'll need to create a new secret
- Save it in Notepad as: **`arm_client_secret`**

---

### **Step 6: Get Subscription ID** ✏️

1. In the **search bar**, type: **"Subscriptions"**
2. Click **"Subscriptions"**
3. You'll see a list of subscriptions
4. Click on the subscription you want to use for the project
5. **Copy the "Subscription ID"**
6. Save it in Notepad as: **`arm_subscription_id`**

---

### **Step 7: Assign Contributor Role**

Now we give the Service Principal permission to create resources.

1. Still in **Subscriptions**, make sure your subscription is selected
2. In the left menu, click **"Access control (IAM)"**
3. Click **"+ Add"** → **"Add role assignment"**

**On the "Role" tab**:
4. Search for and select **"Contributor"**
5. Click **"Next"**

**On the "Members" tab**:
6. Click **"+ Select members"**
7. In the search box, type: **`terraform-sp`** (the name you chose in Step 2)
8. Click on it to select it
9. Click **"Select"**
10. Click **"Review + assign"**
11. Click **"Review + assign"** again to confirm

**✅ Done!** The Service Principal now has Contributor access to your subscription.

---

### **Step 8: Update terraform.tfvars**

Now edit your `terraform/terraform.tfvars` file in WebStorm (it should already be open).

**Replace the placeholders**:

```hcl
# Azure Credentials
arm_client_id       = "PASTE_YOUR_APPLICATION_CLIENT_ID_HERE"
arm_client_secret   = "PASTE_YOUR_CLIENT_SECRET_VALUE_HERE"
arm_subscription_id = "PASTE_YOUR_SUBSCRIPTION_ID_HERE"
arm_tenant_id       = "PASTE_YOUR_DIRECTORY_TENANT_ID_HERE"

# Project Config (keep as-is for now)
project_name   = "devopspipeline"
environment    = "dev"
location       = "East US"
vm_size        = "Standard_B2s"
admin_username = "azureuser"
ssh_public_key = "ssh-rsa YOUR_PUBLIC_KEY"  # See Step 9
```

**Save the file** (Ctrl+S).

---

### **Step 9: Generate SSH Key (Optional)**

If you don't have an SSH key yet, generate one:

#### **Windows (PowerShell)**:
```powershell
# Generate key
ssh-keygen -t rsa -b 4096 -C "azure-vm-key"

# When prompted for file location, press Enter (use default)
# When prompted for passphrase, press Enter (no passphrase) or set one

# View the public key
cat ~\.ssh\id_rsa.pub
```

**Copy the entire output** (starts with `ssh-rsa`) and paste it into `ssh_public_key` in `terraform.tfvars`.

---

## 🖥️ Method 2: Azure CLI (Alternative - Requires CLI Installation)

### **Prerequisites**
- Install Azure CLI: https://aka.ms/installazurecliwindows
- Restart terminal after installation

### **Commands**

```powershell
# 1. Login to Azure
az login

# 2. List subscriptions (copy the ID you want to use)
az account list --output table

# 3. Set the subscription
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# 4. Create Service Principal
az ad sp create-for-rbac `
    --name "terraform-sp" `
    --role Contributor `
    --scopes /subscriptions/YOUR_SUBSCRIPTION_ID
```

**Output** (JSON):
```json
{
  "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "displayName": "terraform-sp",
  "password": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

**Map to variables**:
- `appId` → `arm_client_id`
- `password` → `arm_client_secret`
- `tenant` → `arm_tenant_id`
- Subscription ID (you selected) → `arm_subscription_id`

---

## ✅ Verification Checklist

Before proceeding to Terraform, verify you have:

- [ ] **Application (client) ID** - `arm_client_id` (GUID format)
- [ ] **Client secret** - `arm_client_secret` (long random string)
- [ ] **Subscription ID** - `arm_subscription_id` (GUID format)
- [ ] **Tenant ID** - `arm_tenant_id` (GUID format)
- [ ] All values pasted into `terraform/terraform.tfvars`
- [ ] File saved (Ctrl+S)
- [ ] Service Principal has "Contributor" role on subscription

---

## 🧪 Test the Credentials

Run Terraform plan to verify credentials work:

```powershell
cd terraform
terraform init
terraform plan
```

**Expected result**:
- ✅ No authentication errors
- ✅ Terraform shows a plan with resources to create
- ✅ No "invalid tenant" or "invalid client" errors

**If you see errors**, check:
1. Make sure all four values are correct (no extra spaces, quotes, etc.)
2. Service Principal has "Contributor" role assigned
3. Subscription ID matches the subscription where you assigned the role

---

## 🔐 Security Best Practices

### **DO**:
- ✅ Store credentials in `terraform.tfvars` (it's gitignored)
- ✅ Use Terraform Cloud for team collaboration (credentials stored securely)
- ✅ Rotate client secrets annually
- ✅ Use least privilege (Contributor only on specific subscription)

### **DON'T**:
- ❌ Commit `terraform.tfvars` to Git
- ❌ Share client secret in chat/email
- ❌ Use Owner role unless absolutely necessary
- ❌ Store credentials in plain text files outside the project

---

## 📊 Understanding the Service Principal

| What | Explanation |
|------|-------------|
| **Service Principal** | An identity for applications to authenticate to Azure (like a "robot user") |
| **App Registration** | The definition of your application in Azure AD |
| **Client ID** | The unique identifier for your application |
| **Client Secret** | The password for your application |
| **Contributor Role** | Permission to create/modify/delete resources (not manage IAM) |

---

## 🆘 Troubleshooting

### **Issue 1: Can't Find "App registrations"**

**Solution**:
- Make sure you're logged in to the correct Azure account
- Use the search bar at the top: type "App registrations"
- If still not visible, you may not have permission - contact your Azure admin

---

### **Issue 2: "Insufficient privileges" Error**

**Error**:
```
You do not have sufficient privileges to complete this operation
```

**Solution**:
- You need "Application Administrator" or "Global Administrator" role in Azure AD
- Or ask your Azure admin to create the Service Principal for you

---

### **Issue 3: Client Secret Not Visible**

**Problem**: Navigated away without copying the secret

**Solution**:
1. Go back to **App registrations** → **Your app** → **Certificates & secrets**
2. Delete the old secret
3. Create a new one (**+ New client secret**)
4. **IMMEDIATELY copy** the value this time

---

### **Issue 4: Terraform Says "Invalid Tenant"**

**Error**:
```
AADSTS900023: Specified tenant identifier 'xxx' is neither a valid DNS name...
```

**Solution**:
- Verify you copied the **Directory (tenant) ID**, not something else
- No extra spaces or quotes in `terraform.tfvars`
- Must be a GUID format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`

---

## 📚 Next Steps After Setup

Once you have valid credentials in `terraform.tfvars`:

1. ✅ **Initialize Terraform**:
   ```powershell
   cd terraform
   terraform init
   ```

2. ✅ **Review the plan**:
   ```powershell
   terraform plan
   ```

3. ✅ **Apply the infrastructure**:
   ```powershell
   terraform apply
   ```

4. ✅ **Get outputs** (VM IP, ACR name):
   ```powershell
   terraform output
   ```

5. ✅ **Push Docker images to ACR**:
   ```powershell
   cd ..\infra\scripts
   build-images.bat <ACR_NAME>
   push-images.bat <ACR_NAME>
   ```

---

## 📖 Additional Resources

- [Official Azure SP Documentation](https://learn.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli)
- [Terraform Azure Provider Auth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)
- [Azure RBAC Roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles)

---

**Created**: 2025-11-21  
**Questions?** Check `infra/terraform/README.md` for more details.
