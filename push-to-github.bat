@echo off
echo 🚀 Pushing NextGen Meet to GitHub...

REM Initialize git if not already done
git init

REM Add all files
git add .

REM Commit with message
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

REM Set main branch
git branch -M main

REM Add remote origin (you'll need to replace with your actual GitHub repo URL)
REM git remote add origin https://github.com/yourusername/docker-jitsi-meet.git

REM Push to GitHub
REM git push -u origin main

echo ✅ Git repository initialized and ready for GitHub push!
echo 📝 Next steps:
echo 1. Create a new repository on GitHub
echo 2. Copy the repository URL
echo 3. Run: git remote add origin YOUR_GITHUB_REPO_URL
echo 4. Run: git push -u origin main

pause
