@echo off
echo ============================================================
echo    Task Manager - Complete Setup with Security Fixes
echo ============================================================
echo.

echo [Step 1/5] Installing Backend Dependencies...
echo ------------------------------------------------------------
cd backend
call npm install
if %errorlevel% neq 0 (
    echo ERROR: Failed to install backend dependencies!
    pause
    exit /b %errorlevel%
)
echo ✓ Backend dependencies installed
echo.

echo [Step 2/5] Fixing Backend Security Issues...
echo ------------------------------------------------------------
call npm audit fix
if %errorlevel% neq 0 (
    echo WARNING: Some vulnerabilities could not be fixed automatically
    echo You may need to run: npm audit fix --force
    echo (This will use breaking changes if needed)
)
echo ✓ Backend security audit completed
echo.

echo [Step 3/5] Installing Frontend Dependencies...
echo ------------------------------------------------------------
cd ..\frontend
call npm install
if %errorlevel% neq 0 (
    echo ERROR: Failed to install frontend dependencies!
    pause
    exit /b %errorlevel%
)
echo ✓ Frontend dependencies installed
echo.

echo [Step 4/5] Fixing Frontend Security Issues...
echo ------------------------------------------------------------
call npm audit fix
if %errorlevel% neq 0 (
    echo WARNING: Some vulnerabilities could not be fixed automatically
    echo You may need to run: npm audit fix --force
)
echo ✓ Frontend security audit completed
echo.

echo [Step 5/5] Generating Audit Reports...
echo ------------------------------------------------------------
cd ..\
echo.
echo BACKEND AUDIT REPORT:
echo ------------------------------------------------------------
cd backend
call npm audit
echo.
echo FRONTEND AUDIT REPORT:
echo ------------------------------------------------------------
cd ..\frontend
call npm audit
echo.

cd ..
echo ============================================================
echo    Setup Complete with Security Checks!
echo ============================================================
echo.
echo Summary:
echo ✓ Backend dependencies installed
echo ✓ Backend security vulnerabilities addressed
echo ✓ Frontend dependencies installed
echo ✓ Frontend security vulnerabilities addressed
echo.
echo Next Steps:
echo 1. Review any remaining vulnerabilities above
echo 2. Setup database: setup-database.bat
echo 3. Run the app: run-app.bat
echo.
echo If you see HIGH or CRITICAL vulnerabilities, you may want to:
echo - Run: npm audit fix --force (in backend/ or frontend/)
echo - Or manually update package.json versions
echo.
pause
