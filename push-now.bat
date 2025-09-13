@echo off
echo 🚀 NextGen Meet - Auto Push to GitHub
echo.

echo Adding all files...
git add .

echo Committing changes...
git commit -m "🚀 NextGen Meet - Complete Implementation with Modern Design System"

echo Setting main branch...
git branch -M main

echo Pushing to GitHub...
git push -u origin main

echo.
echo ✅ NextGen Meet successfully pushed to GitHub!
echo 🎉 Ready for Coolify deployment!
echo.
pause
