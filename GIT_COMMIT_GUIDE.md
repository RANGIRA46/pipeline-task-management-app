# 🚀 Git Commit & Pull Request - Terminal Commands Guide

## ✅ **I've Created 3 Scripts for You!**

All scripts are in your project root directory.

---

## **Option 1: Run Batch Script (Recommended for Windows)**

### **Step 1: Run the commit script**

```cmd
cd c:\Users\johns\WebstormProjects\pipeline-task-management-app
commit-and-pr.bat
```

This script will:
- Kill any hanging git processes
- Create/checkout the feature branch
- Add all new files
- Commit with proper message
- Push to GitHub
- Open GitHub in your browser

### **Step 2: Create Pull Request**

After the script completes successfully:

**Option A - Automatic (if you have GitHub CLI):**
```cmd
create-pr.bat
```

**Option B - Manual:**
1. Go to: https://github.com/RANGIRA46/pipeline-task-management-app
2. Click the banner "Compare & pull request"
3. Review and click "Create pull request"

---

## **Option 2: Run PowerShell Script**

```powershell
cd c:\Users\johns\WebstormProjects\pipeline-task-management-app
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\commit-and-pr.ps1
```

Then create PR using `create-pr.bat` or manually

---

## **Option 3: Manual Git Commands**

If scripts don't work, run these commands one by one:

### **Kill hanging git processes:**
```cmd
taskkill /F /IM git.exe
```

### **Navigate to project:**
```cmd
cd c:\Users\johns\WebstormProjects\pipeline-task-management-app
```

### **Create and checkout feature branch:**
```cmd
git checkout -b feature/add-complete-cicd-workflows
```

### **Add all workflow files:**
```cmd
git add .github/workflows/security.yml
git add .github/workflows/terraform.yml
git add .github/workflows/cd-pipeline.yml
git add .github/workflows/dast.yml
git add .github/workflows/ci-complete.yml
```

### **Add documentation:**
```cmd
git add docs/DEPLOYMENT.md
git add docs/ARCHITECTURE.md
git add docs/SECURITY.md
```

### **Add support files:**
```cmd
git add DEVOPS_IMPLEMENTATION_STATUS.md
git add LAB_GUIDE_ANALYSIS.md
git add START_NOW.md
git add PUSH_WORKFLOWS_GUIDE.md
git add MANUAL_UPLOAD_GUIDE.md
git add COMPREHENSIVE_STATUS.md
git add security/zap-rules.tsv
```

### **Check status:**
```cmd
git status
```

### **Commit changes:**
```cmd
git commit -m "feat: Add comprehensive CI/CD workflows and documentation" -m "- Enhanced CI pipeline with separate linting/testing jobs" -m "- Security scanning workflow (SAST, dependency, container scans)" -m "- Terraform infrastructure CI/CD workflow" -m "- CD deployment pipeline with Ansible" -m "- OWASP ZAP DAST scanning" -m "- Complete documentation (DEPLOYMENT, ARCHITECTURE, SECURITY)" -m "- Implementation guides and status tracking"
```

### **Push to GitHub:**
```cmd
git push -u origin feature/add-complete-cicd-workflows
```

### **Create Pull Request (GitHub CLI):**
```cmd
gh pr create --base main --head feature/add-complete-cicd-workflows --title "feat: Add comprehensive CI/CD workflows and documentation" --body "Complete DevOps CI/CD pipeline with workflows and documentation"
```

OR visit: https://github.com/RANGIRA46/pipeline-task-management-app/compare/main...feature/add-complete-cicd-workflows

---

## **Troubleshooting**

### **Issue: Git commands still hanging**

**Solution 1 - Use GitHub Desktop:**
1. Open GitHub Desktop
2. It should show all your changes
3. Commit with the message
4. Push to new branch
5. Create PR from GitHub Desktop

**Solution 2 - Restart your machine:**
Sometimes git processes get stuck and need a full restart

**Solution 3 - Use the browser upload (we already set this up):**
The GitHub upload page is already open in your browser!

---

## **What Happens After PR is Created**

1. **CI Pipeline Runs**: GitHub Actions will automatically run
   - Linting (backend & frontend)
   - Testing (backend & frontend)
   - Security scanning
   - Docker builds

2. **Review Process**:
   - Check that CI passes (green checkmarks)
   - Review the diff
   - Request reviews from team members (if applicable)

3. **Merge**:
   - Once CI passes and reviews are approved
   - Click "Merge pull request"
   - Delete the feature branch after merge

---

## **Quick Reference**

| Script | Purpose | Command |
|--------|---------|---------|
| `commit-and-pr.bat` | Commit & push all changes | `commit-and-pr.bat` |
| `commit-and-pr.ps1` | PowerShell version | `.\commit-and-pr.ps1` |
| `create-pr.bat` | Create PR using GitHub CLI | `create-pr.bat` |

---

## **Files That Will Be Committed**

### Workflows (5 files)
- `.github/workflows/ci-complete.yml`
- `.github/workflows/security.yml`
- `.github/workflows/terraform.yml`
- `.github/workflows/cd-pipeline.yml`
- `.github/workflows/dast.yml`

### Documentation (3 files)
- `docs/DEPLOYMENT.md`
- `docs/ARCHITECTURE.md`
- `docs/SECURITY.md`

### Support Files (7 files)
- `DEVOPS_IMPLEMENTATION_STATUS.md`
- `LAB_GUIDE_ANALYSIS.md`
- `START_NOW.md`
- `PUSH_WORKFLOWS_GUIDE.md`
- `MANUAL_UPLOAD_GUIDE.md`
- `COMPREHENSIVE_STATUS.md`
- `security/zap-rules.tsv`

**Total: 15 files**

---

## **Next Steps After PR is Merged**

1. **Configure GitHub Secrets**
   - See `START_NOW.md` for list of required secrets

2. **Run Terraform**
   ```bash
   cd infra/terraform
   terraform init
   terraform plan
   terraform apply
   ```

3. **Trigger Deployment**
   - Push any commit to main
   - CD pipeline will automatically deploy to Azure

---

**Choose the method that works best for you and run it!** 🚀

**Recommended**: Start with `commit-and-pr.bat` - it's the simplest!
