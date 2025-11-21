@echo off
echo ====================================
echo Installing Backend Dependencies
echo ====================================
cd backend
call npm install
if %errorlevel% neq 0 (
    echo Error installing backend dependencies!
    pause
    exit /b %errorlevel%
)

echo.
echo ====================================
echo Installing Frontend Dependencies
echo ====================================
cd ..\frontend
call npm install
if %errorlevel% neq 0 (
    echo Error installing frontend dependencies!
    pause
    exit /b %errorlevel%
)

echo.
echo ====================================
echo Installation Complete!
echo ====================================
echo.
echo Next steps:
echo 1. Setup database: setup-database.bat
echo 2. Run the app: run-app.bat
echo.
pause
