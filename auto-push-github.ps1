# NextGen Meet - Auto Push to GitHub
Write-Host "🚀 NextGen Meet - Auto Push to GitHub" -ForegroundColor Green

# Check if git is initialized
if (-not (Test-Path ".git")) {
    Write-Host "Initializing Git repository..." -ForegroundColor Yellow
    git init
}

# Configure Git user
Write-Host "Configuring Git user..." -ForegroundColor Yellow
git config user.name "nguyennhanduc1991"
git config user.email "nguyennhanduc1991@gmail.com"

# Add all files
Write-Host "Adding all files..." -ForegroundColor Yellow
git add .

# Commit changes
Write-Host "Committing changes..." -ForegroundColor Yellow
git commit -m "🚀 NextGen Meet - Complete Implementation

✨ Features:
- Complete design system with CSS variables and tokens
- Modern dark theme with Teal (#00F5A0) and Magenta (#A32EFF) accents
- Glass morphism effects and glow animations
- Responsive welcome page with custom branding
- Advanced toolbar with micro-interactions
- Optimized video layout with rounded thumbnails
- Comprehensive animation system
- NextGen Meet branding and styling

🎨 Design System:
- nextgen-design-tokens.js - Complete design token system
- nextgen-variables.css - 50+ CSS variables
- nextgen-mixins.css - Reusable CSS mixins
- nextgen-components.css - Component library
- nextgen-toolbar.css - Modern toolbar styling
- nextgen-video.css - Video layout optimization
- nextgen-animations.css - Animation system

📱 Components:
- Welcome page with glow effects
- Glass effect toolbar
- Rounded video thumbnails
- Smooth transitions and micro-interactions
- Responsive design for all devices

🚀 Ready for deployment on Coolify!"

# Set main branch
Write-Host "Setting main branch..." -ForegroundColor Yellow
git branch -M main

# Check if remote exists
$remoteExists = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "No remote repository found. Please create one on GitHub first." -ForegroundColor Red
    Write-Host ""
    Write-Host "📋 Next steps:" -ForegroundColor Cyan
    Write-Host "1. Go to https://github.com/new" -ForegroundColor White
    Write-Host "2. Create repository named 'nextgen-meet'" -ForegroundColor White
    Write-Host "3. Copy the repository URL" -ForegroundColor White
    Write-Host "4. Run: git remote add origin YOUR_REPO_URL" -ForegroundColor White
    Write-Host "5. Run: git push -u origin main" -ForegroundColor White
    Write-Host ""
    Write-Host "Or run this script again after adding remote!" -ForegroundColor Green
} else {
    Write-Host "Found remote repository: $remoteExists" -ForegroundColor Green
    Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Successfully pushed to GitHub!" -ForegroundColor Green
        Write-Host "🎉 NextGen Meet is now live on GitHub!" -ForegroundColor Cyan
    } else {
        Write-Host "❌ Push failed. Please check your authentication." -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🎯 Next steps for deployment:" -ForegroundColor Cyan
Write-Host "1. Go to Coolify dashboard" -ForegroundColor White
Write-Host "2. Create new application" -ForegroundColor White
Write-Host "3. Connect GitHub repository" -ForegroundColor White
Write-Host "4. Deploy NextGen Meet!" -ForegroundColor White
Write-Host ""
Write-Host "NextGen Meet - Kiến tạo Trải nghiệm Hội nghị Truyền hình Đẳng cấp! 🚀✨" -ForegroundColor Magenta
