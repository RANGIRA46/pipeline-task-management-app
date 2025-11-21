# PowerShell Script for Git Commit and PR
Write-Host "========================================"  -ForegroundColor Cyan
Write-Host "Git Commit and PR Creation Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Kill any hanging git processes
Get-Process git -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

# Navigate to project directory
Set-Location "c:\Users\johns\WebstormProjects\pipeline-task-management-app"

Write-Host "Step 1: Creating and checking out feature branch..." -ForegroundColor Yellow
try {
    git checkout -b feature/add-complete-cicd-workflows 2>$null
    if ($LASTEXITCODE -ne 0) {
        git checkout feature/add-complete-cicd-workflows
    }
    Write-Host "✓ Branch created/checked out" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: Failed to checkout branch" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host ""

Write-Host "Step 2: Adding all workflow files..." -ForegroundColor Yellow
git add .github/workflows/security.yml
git add .github/workflows/terraform.yml
git add .github/workflows/cd-pipeline.yml
git add .github/workflows/dast.yml
git add .github/workflows/ci-complete.yml
Write-Host "✓ Workflow files added" -ForegroundColor Green
Write-Host ""

Write-Host "Step 3: Adding documentation files..." -ForegroundColor Yellow
git add docs/DEPLOYMENT.md
git add docs/ARCHITECTURE.md
git add docs/SECURITY.md
Write-Host "✓ Documentation files added" -ForegroundColor Green
Write-Host ""

Write-Host "Step 4: Adding support files..." -ForegroundColor Yellow
git add DEVOPS_IMPLEMENTATION_STATUS.md
git add LAB_GUIDE_ANALYSIS.md
git add START_NOW.md
git add PUSH_WORKFLOWS_GUIDE.md
git add MANUAL_UPLOAD_GUIDE.md
git add COMPREHENSIVE_STATUS.md
git add security/zap-rules.tsv
Write-Host "✓ Support files added" -ForegroundColor Green
Write-Host ""

Write-Host "Step 5: Checking status..." -ForegroundColor Yellow
git status
Write-Host ""

Write-Host "Step 6: Committing changes..." -ForegroundColor Yellow
$commitMessage = @"
feat: Add comprehensive CI/CD workflows and documentation

- Enhanced CI pipeline with separate linting/testing jobs
- Security scanning workflow (SAST, dependency, container scans)
- Terraform infrastructure CI/CD workflow
- CD deployment pipeline with Ansible
- OWASP ZAP DAST scanning
- Complete documentation (DEPLOYMENT, ARCHITECTURE, SECURITY)
- Implementation guides and status tracking
"@

git commit -m $commitMessage
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to commit" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "✓ Changes committed" -ForegroundColor Green
Write-Host ""

Write-Host "Step 7: Pushing to GitHub..." -ForegroundColor Yellow
git push -u origin feature/add-complete-cicd-workflows
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to push" -ForegroundColor Red
    Write-Host ""
    Write-Host "Try manually: git push -u origin feature/add-complete-cicd-workflows" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "✓ Pushed to GitHub" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SUCCESS! Branch pushed to GitHub" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Go to: https://github.com/RANGIRA46/pipeline-task-management-app"
Write-Host "2. You should see a banner 'Compare & pull request' - click it"
Write-Host "3. Or go to Pull Requests tab and create manually"
Write-Host ""
Write-Host "Press any key to open GitHub in browser..." -ForegroundColor Yellow
Read-Host
Start-Process "https://github.com/RANGIRA46/pipeline-task-management-app/pulls"
