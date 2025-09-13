Write-Host "🚀 NextGen Meet - Auto Push to GitHub" -ForegroundColor Green

# Add all files
Write-Host "Adding all files..." -ForegroundColor Yellow
git add .

# Commit changes
Write-Host "Committing changes..." -ForegroundColor Yellow
git commit -m "🚀 NextGen Meet - Complete Implementation with Modern Design System"

# Set main branch
Write-Host "Setting main branch..." -ForegroundColor Yellow
git branch -M main

# Push to GitHub
Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
git push -u origin main

Write-Host "✅ NextGen Meet successfully pushed to GitHub!" -ForegroundColor Green
Write-Host "🎉 Ready for Coolify deployment!" -ForegroundColor Cyan
