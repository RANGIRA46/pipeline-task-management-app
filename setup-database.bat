@echo off
echo ====================================
echo Setting up Database
echo ====================================
echo.
echo This requires PostgreSQL to be installed and running.
echo.
echo If you don't have PostgreSQL, you can:
echo 1. Install it from: https://www.postgresql.org/download/windows/
echo 2. Or use Docker: docker run --name taskmanager-db -e POSTGRES_USER=devops -e POSTGRES_PASSWORD=devops123 -e POSTGRES_DB=devops_app -p 5432:5432 -d postgres:15-alpine
echo.
pause

cd backend
call npm run db:setup
if %errorlevel% neq 0 (
    echo.
    echo Error setting up database!
    echo Make sure PostgreSQL is running and .env file is configured correctly.
    echo.
    pause
    exit /b %errorlevel%
)

echo.
echo ====================================
echo Database Setup Complete!
echo ====================================
echo Sample tasks have been created.
echo.
echo Next step: Run the application with run-app.bat
echo.
pause
