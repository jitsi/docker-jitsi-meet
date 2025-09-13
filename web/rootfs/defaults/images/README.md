# Thư mục Images cho Jitsi Meet

## Cách thêm ảnh nền Welcome Page

### 1. Chuẩn bị file ảnh
- **Tên file**: `welcome-background.png` hoặc `welcome-background.jpg`
- **Kích thước khuyến nghị**: 1920x1080px hoặc lớn hơn
- **Định dạng**: PNG, JPG, hoặc WebP
- **Chất lượng**: Tối ưu hóa để giảm kích thước file

### 2. Copy file vào thư mục này
```bash
# Copy file ảnh nền vào thư mục
cp your-welcome-background.png web/rootfs/defaults/images/welcome-background.png
```

### 3. Cập nhật cấu hình (nếu cần)
Nếu tên file khác `welcome-background.png`, cập nhật trong:
- `env.example`
- `web/rootfs/defaults/interface_config.js`
- `web/rootfs/defaults/custom.css`
- `web/rootfs/defaults/index.html`

### 4. Commit và push
```bash
git add web/rootfs/defaults/images/welcome-background.png
git commit -m "Add welcome background image"
git push origin main
```

## Các file ảnh khác cần thiết

### Logo chính
- **File**: `logo.png`
- **Kích thước**: 200x200px hoặc 400x400px
- **Nền**: Trong suốt (PNG)

### Favicon
- **File**: `favicon.ico`
- **Kích thước**: 16x16px, 32x32px, 48x48px
- **Định dạng**: ICO

### Open Graph Image
- **File**: `og-image.png`
- **Kích thước**: 1200x630px
- **Định dạng**: PNG

## Lưu ý
- Tất cả file ảnh sẽ được tự động copy vào container khi deploy
- Đảm bảo có quyền sử dụng hình ảnh
- Tối ưu hóa kích thước file để tăng tốc độ tải
