# 🚀 Hướng dẫn Push NextGen Meet lên GitHub

## Bước 1: Tạo Repository trên GitHub

1. Truy cập [GitHub.com](https://github.com)
2. Click "New repository"
3. Đặt tên: `docker-jitsi-meet` hoặc `nextgen-meet`
4. Chọn "Public" hoặc "Private"
5. **KHÔNG** check "Initialize with README"
6. Click "Create repository"

## Bước 2: Push Code lên GitHub

Mở Command Prompt hoặc PowerShell trong thư mục `D:\Documents\docker-jitsi-meet` và chạy các lệnh sau:

```bash
# 1. Khởi tạo Git repository
git init

# 2. Thêm tất cả files
git add .

# 3. Commit với message chi tiết
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

# 4. Đặt branch chính là main
git branch -M main

# 5. Thêm remote origin (thay YOUR_USERNAME và REPO_NAME)
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git

# 6. Push lên GitHub
git push -u origin main
```

## Bước 3: Verify trên GitHub

1. Truy cập repository trên GitHub
2. Kiểm tra tất cả files đã được upload
3. Xem commit message chi tiết
4. Kiểm tra các file NextGen Meet:
   - `web/rootfs/defaults/nextgen-*.css`
   - `web/rootfs/defaults/nextgen-design-tokens.js`
   - `web/rootfs/defaults/index.html` (Welcome page)
   - `NEXTGEN_MEET_DEPLOYMENT_GUIDE.md`

## Bước 4: Deploy trên Coolify

1. **Tạo Application mới trong Coolify:**
   - Chọn "Git Repository"
   - Kết nối GitHub repository vừa tạo
   - Chọn branch `main`

2. **Cấu hình Environment Variables:**
```env
# NextGen Meet Configuration
APP_NAME=NextGen Meet
DEFAULT_LANGUAGE=vi
PRIMARY_COLOR=#00F5A0
SECONDARY_COLOR=#A32EFF
BACKGROUND_COLOR=#0A0A0A

# Branding
LOGO_URL=https://meet.thanhnguyen.group/images/logo.png
WELCOME_PAGE_BACKGROUND_URL=https://meet.thanhnguyen.group/images/welcome-background.png

# Features
ENABLE_ANIMATIONS=true
ENABLE_GLOW_EFFECTS=true
ENABLE_GLASS_EFFECTS=true
ENABLE_MICRO_INTERACTIONS=true
```

3. **Deploy:**
   - Click "Deploy"
   - Chờ build hoàn tất (5-10 phút)
   - Truy cập `https://meet.thanhnguyen.group`

## 🎉 Kết quả mong đợi

Sau khi deploy thành công, bạn sẽ có:

✅ **NextGen Meet** với giao diện đẳng cấp
✅ **Welcome page** với hiệu ứng glow
✅ **Toolbar** nền tối với glass effect
✅ **Video layout** tối ưu với thumbnails bo góc
✅ **Animation system** mượt mà
✅ **Responsive design** cho mọi thiết bị
✅ **Performance** tối ưu

## 🔧 Troubleshooting

### Nếu Git push bị lỗi:

```bash
# Kiểm tra remote
git remote -v

# Nếu chưa có remote, thêm lại
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git

# Force push nếu cần
git push -u origin main --force
```

### Nếu Coolify deploy bị lỗi:

1. Kiểm tra logs trong Coolify dashboard
2. Đảm bảo domain đã trỏ đúng IP
3. Kiểm tra environment variables
4. Restart application

## 📞 Support

Nếu gặp vấn đề, hãy:
1. Kiểm tra logs trong Coolify
2. Xem hướng dẫn trong `NEXTGEN_MEET_DEPLOYMENT_GUIDE.md`
3. Liên hệ support

---

**NextGen Meet** - Kiến tạo Trải nghiệm Hội nghị Truyền hình Đẳng cấp! 🚀✨
