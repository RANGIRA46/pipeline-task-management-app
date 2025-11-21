@echo off
REM =================================================
REM Push Docker Images to Azure ACR
REM =================================================

echo [INFO] Pushing Docker images to Azure Container Registry...

REM Set variables
set ACR_NAME=%1
if "%ACR_NAME%"=="" (
    echo [ERROR] Usage: push-images.bat ^<ACR_NAME^>
    echo [ERROR] Example: push-images.bat myacr
    exit /b 1
)

set ACR_LOGIN_SERVER=%ACR_NAME%.azurecr.io
set IMAGE_TAG=%2
if "%IMAGE_TAG%"=="" set IMAGE_TAG=latest

echo [INFO] ACR: %ACR_LOGIN_SERVER%
echo [INFO] Tag: %IMAGE_TAG%

REM Login to ACR
echo.
echo [INFO] Logging into Azure Container Registry...
az acr login --name %ACR_NAME%

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] ACR login failed! Make sure Azure CLI is installed and you're authenticated.
    exit /b 1
)

REM Push backend image
echo.
echo [INFO] Pushing backend image...
docker push %ACR_LOGIN_SERVER%/tm-backend:%IMAGE_TAG%

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Backend push failed!
    exit /b 1
)

REM Push frontend image
echo.
echo [INFO] Pushing frontend image...
docker push %ACR_LOGIN_SERVER%/tm-frontend:%IMAGE_TAG%

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Frontend push failed!
    exit /b 1
)

echo.
echo [SUCCESS] All images pushed successfully!
echo.
echo Images available at:
echo   - %ACR_LOGIN_SERVER%/tm-backend:%IMAGE_TAG%
echo   - %ACR_LOGIN_SERVER%/tm-frontend:%IMAGE_TAG%
