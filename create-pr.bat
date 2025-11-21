@echo off
echo ========================================
echo Create Pull Request using GitHub CLI
echo ========================================
echo.

REM Check if GitHub CLI is installed
where gh >nul 2>nul
if errorlevel 1 (
    echo GitHub CLI (gh) is not installed.
    echo.
    echo Please install it from: https://cli.github.com/
    echo Or create the PR manually on GitHub website
    echo.
    pause
    exit /b 1
)

echo GitHub CLI found!
echo.

REM Navigate to project directory
cd /d "c:\Users\johns\WebstormProjects\pipeline-task-management-app"

echo Creating Pull Request...
echo.

gh pr create ^
  --base main ^
  --head feature/add-complete-cicd-workflows ^
  --title "feat: Add comprehensive CI/CD workflows and documentation" ^
  --body "## Summary%0AThis PR adds a complete DevOps CI/CD pipeline implementation with comprehensive workflows and documentation.%0A%0A## Changes%0A### Workflows Added%0A- ✅ `ci-complete.yml` - Enhanced CI with linting, testing, security scanning%0A- ✅ `security.yml` - Comprehensive security scanning suite%0A- ✅ `terraform.yml` - Infrastructure as Code CI/CD%0A- ✅ `cd-pipeline.yml` - Automated deployment pipeline%0A- ✅ `dast.yml` - OWASP ZAP dynamic security testing%0A%0A### Documentation Added%0A- ✅ `docs/DEPLOYMENT.md` - Complete deployment guide%0A- ✅ `docs/ARCHITECTURE.md` - System architecture documentation%0A- ✅ `docs/SECURITY.md` - Security practices and procedures%0A%0A### Supporting Files%0A- Implementation status tracking%0A- Lab guide analysis%0A- Quick start guides%0A- Manual upload instructions%0A%0A## Testing%0A- All workflows validated locally%0A- Documentation reviewed%0A- Files structured according to lab requirements%0A%0A## Checklist%0A- [x] Code follows project guidelines%0A- [x] Documentation updated%0A- [x] All files added%0A- [ ] CI checks passing (will run on PR)"

if errorlevel 1 (
    echo.
    echo ERROR: Failed to create PR
    echo.
    echo Please create it manually:
    echo 1. Go to https://github.com/RANGIRA46/pipeline-task-management-app
    echo 2. Click "Pull requests" tab
    echo 3. Click "New pull request"
    echo 4. Select: base: main compare: feature/add-complete-cicd-workflows
    pause
    exit /b 1
)

echo.
echo ========================================
echo SUCCESS! Pull Request created!
echo ========================================
echo.

REM Open the PR in browser
echo Opening PR in browser...
gh pr view --web

pause
