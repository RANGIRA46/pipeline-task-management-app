@echo off
REM ============================================
REM Pre-Deployment Checklist Script
REM ============================================

echo.
echo ╔═══════════════════════════════════════════════════════╗
echo ║   CD Pipeline Pre-Deployment Checklist               ║
echo ╚═══════════════════════════════════════════════════════╝
echo.

REM Check if we're in the right directory
if not exist ".git" (
    echo ❌ Error: Not in project root directory
    echo Please run this script from the project root
    exit /b 1
)

echo ✅ Project directory verified
echo.

REM Check if Ansible files exist
echo Checking Ansible configuration...
if exist "ansible\ansible.cfg" (
    echo   ✅ ansible.cfg exists
) else (
    echo   ❌ ansible.cfg missing
)

if exist "ansible\playbooks\setup-server.yml" (
    echo   ✅ setup-server.yml exists
) else (
    echo   ❌ setup-server.yml missing
)

if exist "ansible\playbooks\update-app.yml" (
    echo   ✅ update-app.yml exists
) else (
    echo   ❌ update-app.yml missing
)
echo.

REM Check if Dockerfiles have correct ports
echo Checking Docker configuration...
findstr /C:"EXPOSE 3000" "infra\docker\backend.Dockerfile" >nul 2>&1
if %ERRORLEVEL% == 0 (
    echo   ✅ Backend Dockerfile uses port 3000
) else (
    echo   ❌ Backend Dockerfile port issue
)

findstr /C:"localhost:3000" "infra\docker\frontend.Dockerfile" >nul 2>&1
if %ERRORLEVEL% == 0 (
    echo   ✅ Frontend Dockerfile references correct API port
) else (
    echo   ❌ Frontend Dockerfile API URL issue
)
echo.

REM Check if workflows exist
echo Checking GitHub Actions workflows...
if exist ".github\workflows\ci-pipeline.yml" (
    echo   ✅ CI pipeline exists
) else (
    echo   ❌ CI pipeline missing
)

if exist ".github\workflows\cd-pipeline.yml" (
    echo   ✅ CD pipeline exists
) else (
    echo   ❌ CD pipeline missing
)

if exist ".github\workflows\test-secrets.yml" (
    echo   ✅ Test secrets workflow exists
) else (
    echo   ❌ Test secrets workflow missing
)
echo.

REM Check if documentation exists
echo Checking documentation...
if exist "CD_DEBUG_GUIDE.md" (
    echo   ✅ Debug guide exists
) else (
    echo   ❌ Debug guide missing
)

if exist "SECRETS_SETUP.md" (
    echo   ✅ Secrets setup guide exists
) else (
    echo   ❌ Secrets setup guide missing
)

if exist "CD_FIXES_SUMMARY.md" (
    echo   ✅ Fixes summary exists
) else (
    echo   ❌ Fixes summary missing
)
echo.

REM Check git status
echo Checking Git status...
git status --porcelain >nul 2>&1
if %ERRORLEVEL% == 0 (
    echo   ✅ Git repository accessible
    
    REM Check for uncommitted changes
    for /f %%i in ('git status --porcelain 2^>nul ^| find /c /v ""') do set CHANGES=%%i
    if "%CHANGES%"=="0" (
        echo   ✅ No uncommitted changes
    ) else (
        echo   ⚠️  You have uncommitted changes
        echo   📝 Remember to commit and push before running CD pipeline
    )
    
    REM Check current branch
    for /f "tokens=*" %%i in ('git branch --show-current') do set BRANCH=%%i
    echo   📍 Current branch: %BRANCH%
    if "%BRANCH%"=="main" (
        echo   ✅ On main branch
    ) else (
        echo   ⚠️  Not on main branch (CD runs on main)
    )
) else (
    echo   ❌ Git not available or not a git repository
)
echo.

REM Summary
echo ═══════════════════════════════════════════════════════
echo 📋 Next Steps:
echo ═══════════════════════════════════════════════════════
echo.
echo 1. 🔐 Configure GitHub Secrets
echo    → See: SECRETS_SETUP.md
echo    → Go to: Settings → Secrets and variables → Actions
echo.
echo 2. ✅ Verify Secrets Configuration
echo    → Run workflow: "Test Secrets Configuration"
echo    → All 12 secrets should show ✅
echo.
echo 3. 📤 Commit and Push Changes
echo    → git add .
echo    → git commit -m "fix: configure CD pipeline"
echo    → git push origin main
echo.
echo 4. 🚀 Run CD Pipeline
echo    → Automatically runs on push to main
echo    → Or manually: Actions → CD Pipeline → Run workflow
echo.
echo 5. 🔍 Monitor Deployment
echo    → Check GitHub Actions for progress
echo    → See: CD_DEBUG_GUIDE.md for troubleshooting
echo.
echo 6. 🎉 Access Application
echo    → http://YOUR_VM_IP
echo    → http://YOUR_VM_IP:3000/health
echo.
echo ═══════════════════════════════════════════════════════
echo.

pause
