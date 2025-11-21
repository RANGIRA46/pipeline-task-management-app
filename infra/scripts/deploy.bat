@echo off
REM =================================================
REM Full Deployment Script
REM =================================================

echo ========================================
echo   Task Manager - Full Deployment
echo ========================================

set ENVIRONMENT=%1
if "%ENVIRONMENT%"=="" set ENVIRONMENT=dev

echo [INFO] Environment: %ENVIRONMENT%

REM Check prerequisites
echo.
echo [INFO] Checking prerequisites...

where terraform >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Terraform not found! Please install Terraform.
    exit /b 1
)

where docker >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker not found! Please install Docker Desktop.
    exit /b 1
)

echo [SUCCESS] Prerequisites check passed!

REM Step 1: Build Docker images
echo.
echo ========================================
echo   STEP 1: Building Docker Images
echo ========================================

cd /d "%~dp0..\.."
docker compose -f infra/docker/docker-compose.yml build

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker build failed!
    exit /b 1
)

echo [SUCCESS] Docker images built!

REM Step 2: Run Terraform
echo.
echo ========================================
echo   STEP 2: Provisioning Infrastructure
echo ========================================

cd terraform
terraform init

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Terraform init failed!
    exit /b 1
)

terraform plan

choice /M "Do you want to apply these changes"
if %ERRORLEVEL% EQU 2 (
    echo [INFO] Deployment cancelled by user.
    exit /b 0
)

terraform apply -auto-approve

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Terraform apply failed!
    exit /b 1
)

echo [SUCCESS] Infrastructure provisioned!

REM Step 3: Get ACR name from Terraform output
echo.
echo ========================================
echo   STEP 3: Pushing Images to ACR
echo ========================================

for /f "delims=" %%i in ('terraform output -raw acr_name') do set ACR_NAME=%%i

if "%ACR_NAME%"=="" (
    echo [WARNING] Could not retrieve ACR name from Terraform output
    set /p ACR_NAME="Enter ACR name manually: "
)

cd ..
call infra\scripts\build-images.bat %ACR_NAME% latest
call infra\scripts\push-images.bat %ACR_NAME% latest

echo.
echo ========================================
echo   DEPLOYMENT COMPLETE!
echo ========================================
echo.
echo Next steps:
echo   1. Verify infrastructure in Azure Portal
echo   2. Configure DNS (if applicable)
echo   3. Run Ansible playbooks to deploy app to VMs
echo   4. Test application endpoints
echo.
