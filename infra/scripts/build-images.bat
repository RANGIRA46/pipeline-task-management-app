@echo off
REM =================================================
REM Build Docker Images and Push to Azure ACR
REM =================================================

echo [INFO] Building Docker images for Azure deployment...

REM Set variables
set ACR_NAME=%1
if "%ACR_NAME%"=="" (
    echo [ERROR] Usage: build-images.bat ^<ACR_NAME^>
    echo [ERROR] Example: build-images.bat myacr
    exit /b 1
)

set ACR_LOGIN_SERVER=%ACR_NAME%.azurecr.io
set IMAGE_TAG=%2
if "%IMAGE_TAG%"=="" set IMAGE_TAG=latest

echo [INFO] ACR: %ACR_LOGIN_SERVER%
echo [INFO] Tag: %IMAGE_TAG%

REM Navigate to project root
cd /d "%~dp0..\.."

REM Build backend image
echo.
echo [INFO] Building backend image...
docker build ^
    -f infra/docker/backend.Dockerfile ^
    -t %ACR_LOGIN_SERVER%/tm-backend:%IMAGE_TAG% ^
    .

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Backend build failed!
    exit /b 1
)

REM Build frontend image
echo.
echo [INFO] Building frontend image...
docker build ^
    -f infra/docker/frontend.Dockerfile ^
    -t %ACR_LOGIN_SERVER%/tm-frontend:%IMAGE_TAG% ^
    --build-arg VITE_API_URL=https://your-api-domain.com ^
    .

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Frontend build failed!
    exit /b 1
)

echo.
echo [SUCCESS] Images built successfully!
echo.
echo Next steps:
echo   1. Login to ACR: az acr login --name %ACR_NAME%
echo   2. Push backend: docker push %ACR_LOGIN_SERVER%/tm-backend:%IMAGE_TAG%
echo   3. Push frontend: docker push %ACR_LOGIN_SERVER%/tm-frontend:%IMAGE_TAG%
