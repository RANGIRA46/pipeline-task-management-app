@echo off
REM =================================================
REM Infrastructure Health Check
REM =================================================

echo ========================================
echo   Infrastructure Health Check
echo ========================================

set BACKEND_URL=%1
set FRONTEND_URL=%2

if "%BACKEND_URL%"=="" set BACKEND_URL=http://localhost:4000
if "%FRONTEND_URL%"=="" set FRONTEND_URL=http://localhost

echo [INFO] Backend URL: %BACKEND_URL%
echo [INFO] Frontend URL: %FRONTEND_URL%

REM Check Docker services
echo.
echo [CHECKING] Docker Services...
docker compose -f infra/docker/docker-compose.yml ps

REM Check backend health
echo.
echo [CHECKING] Backend API Health...
curl -f -s -o nul %BACKEND_URL%/health
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Backend is healthy!
) else (
    echo [ERROR] Backend health check failed!
)

REM Check frontend
echo.
echo [CHECKING] Frontend UI...
curl -f -s -o nul %FRONTEND_URL%
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Frontend is accessible!
) else (
    echo [ERROR] Frontend health check failed!
)

REM Check database connection
echo.
echo [CHECKING] Database Connection...
docker compose -f infra/docker/docker-compose.yml exec -T db pg_isready -U tm_user
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Database is healthy!
) else (
    echo [ERROR] Database health check failed!
)

echo.
echo ========================================
echo   Health Check Complete
echo ========================================
