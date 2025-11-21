@echo off
echo ========================================
echo Force Push to GitHub
echo ========================================
echo.
echo This will force push your local changes
echo to the feature branch on GitHub.
echo.
echo Your commit: ce372e8
echo Files: 15 files, 3509 insertions
echo.
pause

cd /d "c:\Users\johns\WebstormProjects\pipeline-task-management-app"

echo Pushing to GitHub (force)...
git push -u origin feature/add-complete-cicd-workflows --force

if errorlevel 1 (
    echo.
    echo ERROR: Failed to push
    echo.
    echo Alternative: Try merging remote changes first
    echo Run: git pull origin feature/add-complete-cicd-workflows --rebase
    echo Then: git push -u origin feature/add-complete-cicd-workflows
    pause
    exit /b 1
)

echo.
echo ========================================
echo SUCCESS! Changes pushed to GitHub!
echo ========================================
echo.
echo Opening GitHub to create Pull Request...
timeout /t 2 >nul
start https://github.com/RANGIRA46/pipeline-task-management-app/compare/main...feature/add-complete-cicd-workflows

pause
