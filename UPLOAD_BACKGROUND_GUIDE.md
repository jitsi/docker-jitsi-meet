# Hướng dẫn Upload Ảnh Nền Welcome Page

## Cách 1: Sử dụng Script Tự động (Khuyến nghị)

### Bước 1: Chuẩn bị file ảnh
- **Tên file**: `welcome-background.png` (hoặc bất kỳ tên nào)
- **Kích thước**: 1920x1080px hoặc lớn hơn
- **Định dạng**: PNG, JPG, WebP
- **Chất lượng**: Tối ưu hóa để giảm kích thước

### Bước 2: Chạy script
```bash
# Cấp quyền thực thi cho script
chmod +x add-background.sh

# Chạy script với đường dẫn đến file ảnh
./add-background.sh /path/to/your/welcome-background.png

# Ví dụ:
./add-background.sh ~/Downloads/welcome-background.png
./add-background.sh C:\Users\YourName\Pictures\welcome-background.png
```

Script sẽ tự động:
- ✅ Copy file vào thư mục đúng
- ✅ Thêm vào git
- ✅ Commit với message phù hợp
- ✅ Push lên GitHub
- ✅ Coolify sẽ tự động rebuild

## Cách 2: Thủ công

### Bước 1: Copy file ảnh
```bash
# Copy file ảnh vào thư mục images
cp your-welcome-background.png web/rootfs/defaults/images/welcome-background.png
```

### Bước 2: Thêm vào git
```bash
git add web/rootfs/defaults/images/welcome-background.png
```

### Bước 3: Commit
```bash
git commit -m "Add welcome background image"
```

### Bước 4: Push lên GitHub
```bash
git push origin main
```

## Cách 3: Sử dụng GitHub Web Interface

### Bước 1: Truy cập GitHub
1. Đăng nhập vào GitHub với tài khoản `nguyennhanduc1991@gmail.com`
2. Truy cập repository: `https://github.com/yourusername/docker-jitsi-meet`

### Bước 2: Upload file
1. Click vào thư mục `web/rootfs/defaults/images/`
2. Click "Add file" → "Upload files"
3. Kéo thả file `welcome-background.png` vào
4. Đặt tên file: `welcome-background.png`
5. Thêm commit message: "Add welcome background image"
6. Click "Commit changes"

## Cấu hình đã sẵn sàng

### Files đã được cấu hình:
- ✅ `env.example` - Biến môi trường
- ✅ `interface_config.js` - Cấu hình giao diện
- ✅ `custom.css` - CSS tùy chỉnh
- ✅ `index.html` - Trang chủ
- ✅ `add-background.sh` - Script tự động

### Đường dẫn ảnh nền:
```
https://meet.thanhnguyen.group/images/welcome-background.png
```

## Kiểm tra sau khi upload

### 1. Kiểm tra GitHub
- File đã được upload vào `web/rootfs/defaults/images/`
- Commit đã được tạo với message phù hợp

### 2. Kiểm tra Coolify
- Application đã được rebuild tự động
- Logs không có lỗi

### 3. Kiểm tra Website
- Truy cập `https://meet.thanhnguyen.group`
- Hình nền hiển thị đúng
- Giao diện responsive

## Troubleshooting

### Lỗi: File quá lớn
```bash
# Tối ưu hóa ảnh trước khi upload
# Sử dụng online tools hoặc:
# - TinyPNG
# - ImageOptim
# - GIMP
```

### Lỗi: Git push failed
```bash
# Kiểm tra authentication
git config --list

# Nếu cần, cấu hình lại
git config user.email "nguyennhanduc1991@gmail.com"
git config user.name "Thanh Nguyen"
```

### Lỗi: Ảnh không hiển thị
1. Kiểm tra đường dẫn file
2. Kiểm tra tên file (phải là `welcome-background.png`)
3. Kiểm tra quyền truy cập file
4. Clear cache trình duyệt

## Lưu ý quan trọng

1. **Bản quyền**: Đảm bảo có quyền sử dụng hình ảnh
2. **Kích thước**: Tối ưu hóa để tăng tốc độ tải
3. **Format**: PNG hỗ trợ trong suốt tốt hơn JPG
4. **Backup**: Lưu trữ file gốc
5. **Testing**: Test trên nhiều thiết bị

## Kết quả mong đợi

Sau khi upload thành công:
- ✅ Welcome page có hình nền phòng họp hiện đại
- ✅ Trang chủ có hình nền đẹp mắt
- ✅ Giao diện chuyên nghiệp và ấn tượng
- ✅ Tương thích với mọi thiết bị

Chúc bạn upload thành công! 🚀
