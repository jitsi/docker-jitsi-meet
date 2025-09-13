# Hướng dẫn Thay đổi Welcome Background

## Tổng quan
Hướng dẫn này sẽ giúp bạn thay đổi hình nền trang chào mừng (welcome page) của Jitsi Meet.

## Các file đã được cấu hình

### 1. Interface Config (`web/rootfs/defaults/interface_config.js`)
```javascript
// Cấu hình hình nền welcome page
WELCOME_PAGE_BACKGROUND_URL: 'https://meet.thanhnguyen.group/images/welcome-background.jpg',
WELCOME_PAGE_BACKGROUND_OPACITY: 0.3,
```

### 2. CSS Custom (`web/rootfs/defaults/custom.css`)
```css
/* Tùy chỉnh welcome page */
.welcome .welcome {
    background: linear-gradient(135deg, rgba(245, 247, 250, 0.8) 0%, rgba(195, 207, 226, 0.8) 100%), 
                url('https://meet.thanhnguyen.group/images/welcome-background.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-attachment: fixed;
    min-height: 100vh;
    position: relative;
}
```

### 3. HTML Index (`web/rootfs/defaults/index.html`)
```css
body {
    background: linear-gradient(135deg, rgba(102, 126, 234, 0.8) 0%, rgba(118, 75, 162, 0.8) 100%), 
                url('https://meet.thanhnguyen.group/images/welcome-background.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-attachment: fixed;
}
```

### 4. Environment Variables (`env.example`)
```
WELCOME_PAGE_BACKGROUND_URL=https://meet.thanhnguyen.group/images/welcome-background.jpg
```

## Cách thay đổi hình nền

### Bước 1: Chuẩn bị hình ảnh
1. **Kích thước khuyến nghị**: 1920x1080px hoặc lớn hơn
2. **Định dạng**: JPG, PNG, WebP
3. **Tên file**: `welcome-background.jpg`
4. **Chất lượng**: Tối ưu hóa để giảm kích thước file

### Bước 2: Upload hình ảnh
```bash
# Tạo thư mục images
mkdir -p web/rootfs/defaults/images

# Copy hình ảnh vào thư mục
cp your-background-image.jpg web/rootfs/defaults/images/welcome-background.jpg
```

### Bước 3: Cập nhật URL (nếu cần)
Nếu bạn muốn sử dụng URL khác, cập nhật trong các file:
- `env.example`
- `web/rootfs/defaults/interface_config.js`
- `web/rootfs/defaults/custom.css`
- `web/rootfs/defaults/index.html`

### Bước 4: Deploy
```bash
# Commit changes
git add .
git commit -m "Update welcome background"

# Push to repository
git push origin main

# Deploy trên Coolify
# Coolify sẽ tự động detect và rebuild
```

## Tùy chỉnh nâng cao

### 1. Thay đổi độ trong suốt
```css
/* Trong custom.css */
.welcome .welcome::before {
    background: rgba(255, 255, 255, 0.1); /* Thay đổi giá trị này */
}
```

### 2. Thay đổi vị trí hình nền
```css
/* Trong custom.css */
.welcome .welcome {
    background-position: center top; /* Hoặc left, right, bottom */
}
```

### 3. Thay đổi hiệu ứng overlay
```css
/* Trong custom.css */
.welcome .welcome::before {
    background: linear-gradient(45deg, rgba(0,0,0,0.3), rgba(255,255,255,0.1));
}
```

### 4. Thêm animation
```css
/* Trong custom.css */
.welcome .welcome {
    animation: backgroundMove 20s ease-in-out infinite;
}

@keyframes backgroundMove {
    0%, 100% { background-position: center center; }
    50% { background-position: center top; }
}
```

## Các hình nền gợi ý

### 1. Hình nền phòng họp (như bạn đã cung cấp)
- Phù hợp với mục đích họp trực tuyến
- Tạo cảm giác chuyên nghiệp
- Dễ đọc text trên nền

### 2. Hình nền gradient
- Đơn giản, hiện đại
- Dễ tùy chỉnh màu sắc
- Tương thích tốt với mọi thiết bị

### 3. Hình nền abstract
- Tạo điểm nhấn thú vị
- Cần cẩn thận với độ tương phản
- Phù hợp với branding

## Troubleshooting

### 1. Hình nền không hiển thị
- Kiểm tra đường dẫn file
- Kiểm tra quyền truy cập file
- Kiểm tra format hình ảnh

### 2. Hình nền bị mờ
- Tăng độ trong suốt của overlay
- Giảm opacity của background
- Kiểm tra CSS z-index

### 3. Hình nền bị méo
- Kiểm tra background-size
- Sử dụng background-position
- Đảm bảo tỷ lệ khung hình phù hợp

### 4. Performance chậm
- Tối ưu hóa kích thước file
- Sử dụng WebP format
- Thêm lazy loading

## Lưu ý quan trọng

1. **Bản quyền**: Đảm bảo có quyền sử dụng hình ảnh
2. **Performance**: Tối ưu hóa kích thước file
3. **Responsive**: Test trên nhiều thiết bị
4. **Accessibility**: Đảm bảo text dễ đọc
5. **Backup**: Lưu trữ file gốc

## Kết luận

Với cấu hình này, bạn có thể dễ dàng thay đổi hình nền welcome page của Jitsi Meet. Hình nền phòng họp hiện đại mà bạn cung cấp sẽ tạo ra trải nghiệm chuyên nghiệp và ấn tượng cho người dùng.

Chúc bạn triển khai thành công! 🚀
