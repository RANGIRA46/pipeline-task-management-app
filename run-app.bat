@echo off
echo ====================================
echo Starting Backend Server
echo ====================================
cd backend
start cmd /k "npm run dev"
timeout /t 3 /nobreak > nul

echo.
echo ====================================
echo Starting Frontend Server
echo ====================================
cd ..\frontend
start cmd /k "npm run dev"

echo.
echo ====================================
echo Application Starting!
echo ====================================
echo.
echo Backend will be available at: http://localhost:3000
echo Frontend will be available at: http://localhost:5173
echo.
echo Two new terminal windows have been opened.
echo.
echo Press any key to open the application in your browser...
pause > nul

start http://localhost:5173

echo.
echo Application is running!
echo Close this window when done.
echo.
pause
