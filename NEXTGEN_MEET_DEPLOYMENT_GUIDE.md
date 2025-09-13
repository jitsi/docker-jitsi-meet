# NextGen Meet - Hướng dẫn Triển khai và Bảo trì

## Tổng quan

NextGen Meet là phiên bản tùy chỉnh hoàn toàn của Jitsi Meet, được thiết kế theo phong cách thanhnguyen.group với hệ thống design tokens hiện đại, hiệu ứng glow đặc trưng và trải nghiệm người dùng cao cấp.

## Kiến trúc Hệ thống

### 1. Design System
- **Design Tokens**: Hệ thống biến CSS toàn diện
- **Color Palette**: Nền tối với accent colors Teal (#00F5A0) và Magenta (#A32EFF)
- **Typography**: Inter font family với hệ thống kích thước nhất quán
- **Spacing**: Hệ thống 8px grid với các biến spacing
- **Shadows & Effects**: Hiệu ứng glow đặc trưng

### 2. Component Library
- **Welcome Page**: Trang chào mừng với hiệu ứng glow và animation
- **Toolbar**: Thanh công cụ nền tối với glass effect
- **Video Layout**: Bố cục video tối ưu với thumbnails bo góc
- **Chat Interface**: Giao diện chat với glass effect
- **Modal System**: Hệ thống modal với animation mượt mà

### 3. Animation System
- **Micro-interactions**: Hiệu ứng hover, focus, click
- **Page Transitions**: Chuyển trang mượt mà
- **Loading States**: Animation loading tinh tế
- **Status Indicators**: Hiệu ứng trạng thái động

## Cấu trúc Files

```
web/rootfs/defaults/
├── nextgen-design-tokens.js      # Design tokens JavaScript
├── nextgen-variables.css         # CSS variables
├── nextgen-mixins.css           # CSS mixins
├── nextgen-components.css       # Component styles
├── nextgen-toolbar.css          # Toolbar styles
├── nextgen-video.css            # Video layout styles
├── nextgen-animations.css       # Animation system
├── interface_config.js          # Interface configuration
├── custom.css                   # Custom overrides
└── index.html                   # Welcome page
```

## Triển khai trên Coolify

### Bước 1: Chuẩn bị Repository

```bash
# Clone repository
git clone https://github.com/yourusername/docker-jitsi-meet.git
cd docker-jitsi-meet

# Tạo branch cho NextGen Meet
git checkout -b nextgen-meet

# Commit tất cả thay đổi
git add .
git commit -m "Implement NextGen Meet design system"
git push origin nextgen-meet
```

### Bước 2: Cấu hình Coolify

1. **Tạo Application mới**:
   - Chọn "Git Repository"
   - Kết nối GitHub repository
   - Chọn branch `nextgen-meet`

2. **Cấu hình Build Settings**:
   - Build Pack: Docker
   - Docker Compose File: `docker-compose.coolify.yml`
   - Build Context: `.`

3. **Environment Variables**:
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

# Performance
ENABLE_CSS_OPTIMIZATION=true
ENABLE_JS_OPTIMIZATION=true
ENABLE_IMAGE_OPTIMIZATION=true
```

### Bước 3: Cấu hình Domain và SSL

1. **DNS Configuration**:
```
meet.thanhnguyen.group → IP_VPS
auth.meet.thanhnguyen.group → IP_VPS
muc.meet.thanhnguyen.group → IP_VPS
```

2. **SSL Certificate**:
   - Coolify sẽ tự động cấu hình Let's Encrypt
   - Đảm bảo domain đã trỏ đúng IP trước khi deploy

### Bước 4: Deploy

1. **Trigger Build**:
   - Click "Deploy" trong Coolify dashboard
   - Chờ build hoàn tất (5-10 phút)

2. **Verify Deployment**:
   - Truy cập `https://meet.thanhnguyen.group`
   - Kiểm tra giao diện NextGen Meet
   - Test các tính năng cơ bản

## Cấu hình Nâng cao

### 1. Custom Branding

```bash
# Thay đổi logo
cp your-logo.png web/rootfs/defaults/images/logo.png

# Thay đổi welcome background
cp your-background.png web/rootfs/defaults/images/welcome-background.png

# Cập nhật colors trong nextgen-variables.css
# Thay đổi các biến CSS variables
```

### 2. Performance Optimization

```bash
# Enable CSS minification
echo "ENABLE_CSS_MINIFICATION=true" >> .env

# Enable JS minification
echo "ENABLE_JS_MINIFICATION=true" >> .env

# Enable image optimization
echo "ENABLE_IMAGE_OPTIMIZATION=true" >> .env
```

### 3. Custom Animations

```css
/* Thêm animation tùy chỉnh */
@keyframes customGlow {
    0%, 100% {
        box-shadow: 0 0 5px var(--nextgen-accent-primary);
    }
    50% {
        box-shadow: 0 0 20px var(--nextgen-accent-primary);
    }
}

.custom-element {
    animation: customGlow 2s infinite;
}
```

## Monitoring và Maintenance

### 1. Health Checks

```bash
# Kiểm tra container status
docker ps | grep nextgen

# Kiểm tra logs
docker logs nextgen-meet-web
docker logs nextgen-meet-prosody
docker logs nextgen-meet-jicofo
docker logs nextgen-meet-jvb
```

### 2. Performance Monitoring

```bash
# Kiểm tra resource usage
docker stats

# Kiểm tra disk usage
df -h

# Kiểm tra memory usage
free -h
```

### 3. Backup Strategy

```bash
# Backup configuration
tar -czf nextgen-meet-config-$(date +%Y%m%d).tar.gz web/rootfs/defaults/

# Backup volumes
docker run --rm -v jitsi-meet-cfg:/data -v $(pwd):/backup alpine tar czf /backup/jitsi-meet-cfg-$(date +%Y%m%d).tar.gz -C /data .
```

## Troubleshooting

### 1. CSS không load

**Nguyên nhân**: Nginx chưa cấu hình serve CSS files
**Giải pháp**:
```bash
# Kiểm tra nginx config
docker exec nextgen-meet-web cat /etc/nginx/conf.d/custom-ui.conf

# Restart nginx
docker exec nextgen-meet-web nginx -s reload
```

### 2. Animations không hoạt động

**Nguyên nhân**: CSS animations bị disable
**Giải pháp**:
```bash
# Kiểm tra CSS load
curl -I https://meet.thanhnguyen.group/css/nextgen-animations.css

# Enable animations trong interface_config.js
echo "ENABLE_ANIMATIONS=true" >> .env
```

### 3. Performance chậm

**Nguyên nhân**: CSS/JS chưa được optimize
**Giải pháp**:
```bash
# Enable minification
echo "ENABLE_CSS_MINIFICATION=true" >> .env
echo "ENABLE_JS_MINIFICATION=true" >> .env

# Rebuild container
docker-compose up -d --build
```

## Cập nhật và Bảo trì

### 1. Update NextGen Meet

```bash
# Pull latest changes
git pull origin nextgen-meet

# Rebuild và deploy
docker-compose up -d --build

# Verify changes
curl -I https://meet.thanhnguyen.group
```

### 2. Update Jitsi Base

```bash
# Merge từ upstream
git fetch upstream
git merge upstream/master

# Resolve conflicts nếu có
git add .
git commit -m "Merge upstream changes"

# Rebuild
docker-compose up -d --build
```

### 3. Rollback

```bash
# Rollback về version trước
git checkout previous-commit-hash

# Rebuild
docker-compose up -d --build
```

## Best Practices

### 1. Development

- Luôn test trên staging trước khi deploy production
- Sử dụng Git branches cho mỗi feature
- Commit messages rõ ràng và mô tả chi tiết
- Code review trước khi merge

### 2. Performance

- Optimize images trước khi upload
- Minify CSS/JS trong production
- Sử dụng CDN cho static assets
- Monitor resource usage thường xuyên

### 3. Security

- Cập nhật dependencies thường xuyên
- Sử dụng HTTPS cho tất cả traffic
- Backup dữ liệu định kỳ
- Monitor logs để phát hiện bất thường

## Support và Community

### 1. Documentation
- [Jitsi Meet Documentation](https://jitsi.github.io/handbook/)
- [NextGen Meet Design System](./DESIGN_SYSTEM.md)
- [API Reference](./API_REFERENCE.md)

### 2. Community
- [GitHub Issues](https://github.com/yourusername/docker-jitsi-meet/issues)
- [Discord Community](https://discord.gg/nextgen-meet)
- [Email Support](mailto:support@thanhnguyen.group)

### 3. Contributing
- Fork repository
- Tạo feature branch
- Submit pull request
- Follow coding standards

## Kết luận

NextGen Meet là một sản phẩm được thiết kế tỉ mỉ với hệ thống design system hiện đại, mang lại trải nghiệm hội nghị truyền hình đẳng cấp. Với hướng dẫn này, bạn có thể triển khai và bảo trì NextGen Meet một cách hiệu quả.

Chúc bạn triển khai thành công! 🚀

---

**NextGen Meet** - Kiến tạo Trải nghiệm Hội nghị Truyền hình Đẳng cấp
