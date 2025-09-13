#!/bin/bash

# Script để thêm ảnh nền welcome page
# Sử dụng: ./add-background.sh path/to/your/image.png

if [ $# -eq 0 ]; then
    echo "Sử dụng: ./add-background.sh path/to/your/image.png"
    echo "Ví dụ: ./add-background.sh ~/Downloads/welcome-background.png"
    exit 1
fi

IMAGE_PATH="$1"
TARGET_DIR="web/rootfs/defaults/images"
TARGET_FILE="welcome-background.png"

# Kiểm tra file tồn tại
if [ ! -f "$IMAGE_PATH" ]; then
    echo "Lỗi: File không tồn tại: $IMAGE_PATH"
    exit 1
fi

# Tạo thư mục nếu chưa có
mkdir -p "$TARGET_DIR"

# Copy file ảnh
echo "Đang copy ảnh nền..."
cp "$IMAGE_PATH" "$TARGET_DIR/$TARGET_FILE"

# Kiểm tra kích thước file
FILE_SIZE=$(du -h "$TARGET_DIR/$TARGET_FILE" | cut -f1)
echo "File đã được copy: $TARGET_DIR/$TARGET_FILE (Kích thước: $FILE_SIZE)"

# Thêm vào git
echo "Đang thêm vào git..."
git add "$TARGET_DIR/$TARGET_FILE"

# Commit
echo "Đang commit..."
git commit -m "Add welcome background image: $TARGET_FILE"

# Push
echo "Đang push lên GitHub..."
git push origin main

echo "✅ Hoàn thành! Ảnh nền đã được upload lên GitHub."
echo "🌐 Coolify sẽ tự động detect và rebuild application."
