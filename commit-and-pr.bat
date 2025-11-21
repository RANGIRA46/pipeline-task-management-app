@echo off
echo ========================================
echo Git Commit and PR Creation Script
echo ========================================
echo.

REM Kill any hanging git processes
taskkill /F /IM git.exe 2>nul
timeout /t 2 /nobreak >nul

REM Navigate to project directory
cd /d "c:\Users\johns\WebstormProjects\pipeline-task-management-app"

echo Step 1: Creating and checking out feature branch...
git checkout -b feature/add-complete-cicd-workflows 2>nul || git checkout feature/add-complete-cicd-workflows
if errorlevel 1 (
    echo ERROR: Failed to checkout branch
    pause
    exit /b 1
)
echo ✓ Branch created/checked out
echo.

echo Step 2: Adding all workflow files...
git add .github/workflows/security.yml
git add .github/workflows/terraform.yml
git add .github/workflows/cd-pipeline.yml
git add .github/workflows/dast.yml
git add .github/workflows/ci-complete.yml
echo ✓ Workflow files added
echo.

echo Step 3: Adding documentation files...
git add docs/DEPLOYMENT.md
git add docs/ARCHITECTURE.md
git add docs/SECURITY.md
echo ✓ Documentation files added
echo.

echo Step 4: Adding support files...
git add DEVOPS_IMPLEMENTATION_STATUS.md
git add LAB_GUIDE_ANALYSIS.md
git add START_NOW.md
git add PUSH_WORKFLOWS_GUIDE.md
git add MANUAL_UPLOAD_GUIDE.md
git add COMPREHENSIVE_STATUS.md
git add security/zap-rules.tsv
echo ✓ Support files added
echo.

echo Step 5: Checking status...
git status
echo.

echo Step 6: Committing changes...
git commit -m "feat: Add comprehensive CI/CD workflows and documentation" -m "- Enhanced CI pipeline with separate linting/testing jobs" -m "- Security scanning workflow (SAST, dependency, container scans)" -m "- Terraform infrastructure CI/CD workflow" -m "- CD deployment pipeline with Ansible" -m "- OWASP ZAP DAST scanning" -m "- Complete documentation (DEPLOYMENT, ARCHITECTURE, SECURITY)" -m "- Implementation guides and status tracking"
if errorlevel 1 (
    echo ERROR: Failed to commit
    pause
    exit /b 1
)
echo ✓ Changes committed
echo.

echo Step 7: Pushing to GitHub...
git push -u origin feature/add-complete-cicd-workflows
if errorlevel 1 (
    echo ERROR: Failed to push
    echo.
    echo Try manually: git push -u origin feature/add-complete-cicd-workflows
    pause
    exit /b 1
)
echo ✓ Pushed to GitHub
echo.

echo ========================================
echo SUCCESS! Branch pushed to GitHub
echo ========================================
echo.
echo Next steps:
echo 1. Go to: https://github.com/RANGIRA46/pipeline-task-management-app
echo 2. You should see a banner "Compare ^& pull request" - click it
echo 3. Or go to Pull Requests tab and create manually
echo.
echo Press any key to open GitHub in browser...
pause >nul
start https://github.com/RANGIRA46/pipeline-task-management-app/pulls
