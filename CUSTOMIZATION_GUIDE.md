# Hướng dẫn Cá nhân hóa Jitsi Meet

## Tổng quan
Hướng dẫn này sẽ giúp bạn cá nhân hóa giao diện Jitsi Meet trước khi triển khai.

## Các file đã được tạo

### 1. Cấu hình môi trường (`env.example`)
- Đã thêm các biến môi trường để tùy chỉnh giao diện
- Cấu hình logo, màu sắc, ngôn ngữ
- Bật/tắt các tính năng

### 2. Cấu hình giao diện (`web/rootfs/defaults/interface_config.js`)
- Cấu hình chi tiết giao diện người dùng
- Tùy chỉnh toolbar, welcome page, video layout
- Cấu hình ngôn ngữ và tính năng

### 3. CSS tùy chỉnh (`web/rootfs/defaults/custom.css`)
- Thay đổi màu sắc, font chữ
- Tùy chỉnh layout và animation
- Responsive design

### 4. HTML trang chủ (`web/rootfs/defaults/index.html`)
- Trang chủ tùy chỉnh với branding
- Giao diện đẹp và chuyên nghiệp
- Tích hợp form tạo phòng họp

### 5. Script cấu hình (`web/rootfs/etc/cont-init.d/20-custom-ui`)
- Tự động copy file cấu hình khi container khởi động
- Cấu hình nginx để serve file tùy chỉnh

## Cách triển khai

### Bước 1: Chuẩn bị file assets
```bash
# Tạo thư mục assets
mkdir -p web/rootfs/defaults/images

# Copy logo và favicon vào thư mục
cp your-logo.png web/rootfs/defaults/images/logo.png
cp your-favicon.ico web/rootfs/defaults/images/favicon.ico
```

### Bước 2: Cấu hình biến môi trường
```bash
# Copy file env.example thành .env
cp env.example .env

# Chỉnh sửa các biến trong .env theo nhu cầu
nano .env
```

### Bước 3: Tùy chỉnh giao diện
Chỉnh sửa các file sau theo nhu cầu:
- `web/rootfs/defaults/interface_config.js` - Cấu hình giao diện
- `web/rootfs/defaults/custom.css` - CSS tùy chỉnh
- `web/rootfs/defaults/index.html` - Trang chủ

### Bước 4: Triển khai
```bash
# Build và chạy containers
docker-compose up -d

# Kiểm tra logs
docker-compose logs -f web
```

## Tùy chỉnh nâng cao

### 1. Thay đổi màu sắc
Chỉnh sửa file `custom.css`:
```css
:root {
    --primary-color: #your-color;
    --secondary-color: #your-color;
    --background-color: #your-color;
}
```

### 2. Thay đổi logo
- Thay thế file `web/rootfs/defaults/images/logo.png`
- Cập nhật URL trong `env.example`:
```
LOGO_URL=https://meet.thanhnguyen.group/images/logo.png
```

### 3. Tùy chỉnh toolbar
Chỉnh sửa `interface_config.js`:
```javascript
TOOLBAR_BUTTONS: [
    'microphone', 'camera', 'chat', 'raisehand', 
    'tileview', 'hangup'
]
```

### 4. Thêm tính năng mới
- Chỉnh sửa `interface_config.js` để bật/tắt tính năng
- Cập nhật `env.example` với biến môi trường tương ứng

## Các biến môi trường quan trọng

### Branding
- `APP_NAME`: Tên ứng dụng
- `LOGO_URL`: URL logo chính
- `LOGO_ICON_URL`: URL favicon
- `PRIMARY_COLOR`: Màu chủ đạo
- `DEFAULT_LANGUAGE`: Ngôn ngữ mặc định

### Tính năng
- `ENABLE_RECORDING`: Bật/tắt ghi âm
- `ENABLE_LIVESTREAMING`: Bật/tắt livestream
- `ENABLE_TRANSCRIPTIONS`: Bật/tắt phụ đề
- `ENABLE_BREAKOUT_ROOMS`: Bật/tắt phòng nhóm
- `ENABLE_POLLS`: Bật/tắt bình chọn
- `ENABLE_REACTIONS`: Bật/tắt biểu cảm

### Bảo mật
- `ENABLE_AUTH`: Bật/tắt xác thực
- `ENABLE_GUESTS`: Cho phép khách
- `AUTH_TYPE`: Loại xác thực
- `REQUIRE_DISPLAY_NAME`: Bắt buộc tên hiển thị

## Troubleshooting

### 1. Logo không hiển thị
- Kiểm tra đường dẫn file logo
- Đảm bảo file tồn tại trong container
- Kiểm tra quyền truy cập file

### 2. CSS không áp dụng
- Kiểm tra đường dẫn CSS trong HTML
- Đảm bảo nginx cấu hình đúng
- Xóa cache trình duyệt

### 3. Cấu hình không có hiệu lực
- Restart container web
- Kiểm tra logs: `docker-compose logs web`
- Đảm bảo file cấu hình được copy đúng

## Lưu ý quan trọng

1. **Backup**: Luôn backup file cấu hình trước khi chỉnh sửa
2. **Testing**: Test trên môi trường dev trước khi deploy production
3. **Performance**: Tối ưu hóa hình ảnh để tăng tốc độ tải
4. **Security**: Không hardcode thông tin nhạy cảm trong file cấu hình
5. **Updates**: Cập nhật cấu hình khi upgrade Jitsi Meet

## Hỗ trợ

Nếu gặp vấn đề, hãy kiểm tra:
1. Logs container: `docker-compose logs web`
2. File cấu hình có đúng format không
3. Quyền truy cập file
4. Cấu hình nginx

Chúc bạn triển khai thành công! 🚀
