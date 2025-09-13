@echo off
echo 🔍 Checking Git status...
git status

echo.
echo 📝 Recent commits:
git log --oneline -3

echo.
echo 🌐 Remote repositories:
git remote -v

echo.
echo 📋 Branches:
git branch -a

echo.
echo 🚀 Pushing to GitHub...
git push origin main

echo.
echo ✅ Check complete!
pause
