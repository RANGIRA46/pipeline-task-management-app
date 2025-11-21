# =================================================
# Quick Start Script - Test Docker Locally
# =================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Docker Local Testing" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Docker
Write-Host "[1/5] Checking Docker installation..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "✓ Docker found: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker not found! Please install Docker Desktop first." -ForegroundColor Red
    Write-Host "Download: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Check Docker is running
Write-Host "[2/5] Checking if Docker is running..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker is not running! Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

Write-Host ""

# Navigate to docker directory
Write-Host "[3/5] Navigating to Docker directory..." -ForegroundColor Yellow
Set-Location -Path "infra\docker"
Write-Host "✓ Changed directory to: $(Get-Location)" -ForegroundColor Green

Write-Host ""

# Create .env file if it doesn't exist
Write-Host "[4/5] Setting up environment file..." -ForegroundColor Yellow
if (-not (Test-Path ".env")) {
    if (Test-Path ".env.example") {
        Copy-Item ".env.example" ".env"
        Write-Host "✓ Created .env from .env.example" -ForegroundColor Green
    } else {
        Write-Host "Creating default .env file..." -ForegroundColor Yellow
        @"
# Database Configuration
POSTGRES_USER=tm_user
POSTGRES_PASSWORD=tm_password
POSTGRES_DB=tm_db

# Backend Configuration
DATABASE_URL=postgresql://tm_user:tm_password@db:5432/tm_db
BACKEND_PORT=4000
NODE_ENV=production

# Frontend Configuration
VITE_API_URL=http://localhost:4000
"@ | Out-File -FilePath ".env" -Encoding UTF8
        Write-Host "✓ Created default .env file" -ForegroundColor Green
    }
} else {
    Write-Host "✓ .env file already exists" -ForegroundColor Green
}

Write-Host ""

# Start Docker Compose
Write-Host "[5/5] Starting Docker containers..." -ForegroundColor Yellow
Write-Host ""
Write-Host "This will:" -ForegroundColor Cyan
Write-Host "  • Download required images (first time only)" -ForegroundColor White
Write-Host "  • Build backend (TypeScript compilation)" -ForegroundColor White
Write-Host "  • Build frontend (Vite production build)" -ForegroundColor White
Write-Host "  • Start PostgreSQL database" -ForegroundColor White
Write-Host "  • Start all services" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C to stop the containers" -ForegroundColor Yellow
Write-Host ""
Write-Host "Starting in 3 seconds..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

docker compose up --build
