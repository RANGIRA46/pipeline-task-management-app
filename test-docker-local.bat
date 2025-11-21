@echo off
REM =================================================
REM Quick Start - Test Docker Locally
REM =================================================

echo ========================================
echo    Docker Local Testing
echo ========================================
echo.

REM Check Docker
echo [1/5] Checking Docker installation...
docker --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker not found! Please install Docker Desktop first.
    echo Download: https://www.docker.com/products/docker-desktop
    exit /b 1
)
echo [OK] Docker is installed

echo.

REM Check Docker is running
echo [2/5] Checking if Docker is running...
docker ps >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker is not running! Please start Docker Desktop.
    exit /b 1
)
echo [OK] Docker is running

echo.

REM Navigate to docker directory
echo [3/5] Navigating to Docker directory...
cd infra\docker
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Cannot find infra\docker directory
    exit /b 1
)
echo [OK] Changed directory

echo.

REM Create .env file if it doesn't exist
echo [4/5] Setting up environment file...
if not exist .env (
    if exist .env.example (
        copy .env.example .env >nul
        echo [OK] Created .env from .env.example
    ) else (
        echo # Database Configuration > .env
        echo POSTGRES_USER=tm_user >> .env
        echo POSTGRES_PASSWORD=tm_password >> .env
        echo POSTGRES_DB=tm_db >> .env
        echo. >> .env
        echo # Backend Configuration >> .env
        echo DATABASE_URL=postgresql://tm_user:tm_password@db:5432/tm_db >> .env
        echo BACKEND_PORT=4000 >> .env
        echo NODE_ENV=production >> .env
        echo. >> .env
        echo # Frontend Configuration >> .env
        echo VITE_API_URL=http://localhost:4000 >> .env
        echo [OK] Created default .env file
    )
) else (
    echo [OK] .env file already exists
)

echo.

REM Start Docker Compose
echo [5/5] Starting Docker containers...
echo.
echo This will:
echo   - Download required images (first time only)
echo   - Build backend (TypeScript compilation)
echo   - Build frontend (Vite production build)
echo   - Start PostgreSQL database
echo   - Start all services
echo.
echo Press Ctrl+C to stop the containers
echo.
echo Starting in 3 seconds...
timeout /t 3 /nobreak >nul

docker compose up --build
