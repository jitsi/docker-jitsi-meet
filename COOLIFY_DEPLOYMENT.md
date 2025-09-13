# Hướng dẫn Triển khai Jitsi Meet trên Coolify

## Yêu cầu hệ thống

### VPS/Server
- **RAM**: Tối thiểu 4GB (khuyến nghị 8GB+)
- **CPU**: 2 cores (khuyến nghị 4 cores+)
- **Storage**: 20GB+ SSD
- **OS**: Ubuntu 20.04+ hoặc Debian 11+
- **Docker**: Đã cài đặt
- **Coolify**: Đã cài đặt và cấu hình

### Domain
- Domain chính: `meet.thanhnguyen.group`
- Subdomain: `auth.meet.thanhnguyen.group`, `muc.meet.thanhnguyen.group`

## Bước 1: Chuẩn bị Repository

### 1.1 Push code lên GitHub
```bash
# Tạo repository mới trên GitHub
# Sau đó push code
git remote add origin https://github.com/yourusername/docker-jitsi-meet.git
git branch -M main
git push -u origin main
```

### 1.2 Cấu hình GitHub Actions (tùy chọn)
Tạo file `.github/workflows/deploy.yml`:
```yaml
name: Deploy to Coolify
on:
  push:
    branches: [ main ]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Deploy to Coolify
        run: |
          curl -X POST "${{ secrets.COOLIFY_WEBHOOK_URL }}"
```

## Bước 2: Cấu hình Coolify

### 2.1 Tạo Application mới
1. Đăng nhập vào Coolify dashboard
2. Click "New Application"
3. Chọn "Git Repository"
4. Kết nối GitHub repository

### 2.2 Cấu hình Build Settings
- **Build Pack**: Docker
- **Dockerfile Path**: `./web/Dockerfile`
- **Docker Compose File**: `docker-compose.coolify.yml`
- **Build Context**: `.`

### 2.3 Cấu hình Environment Variables
Thêm các biến môi trường sau trong Coolify:

#### Cấu hình cơ bản
```
TZ=Asia/Ho_Chi_Minh
JITSI_IMAGE_VERSION=unstable
PUBLIC_URL=https://meet.thanhnguyen.group
```

#### Cấu hình XMPP
```
XMPP_DOMAIN=meet.thanhnguyen.group
XMPP_AUTH_DOMAIN=auth.meet.thanhnguyen.group
XMPP_MUC_DOMAIN=muc.meet.thanhnguyen.group
XMPP_BOSH_URL_BASE=http://prosody:5280
XMPP_SERVER=prosody
```

#### Cấu hình mạng
```
JVB_ADVERTISE_IPS=194.233.84.253
DOCKER_HOST_ADDRESS=194.233.84.253
JVB_PORT=10000
JVB_COLIBRI_PORT=28080
JVB_DISABLE_STUN=true
```

#### Cấu hình bảo mật
```
JVB_AUTH_PASSWORD=DucHieu@19911990
JICOFO_AUTH_PASSWORD=DucHieu@19911990
JICOFO_COMPONENT_SECRET=DucHieu@19911990
JICOFO_AUTH_USER=focus
JVB_AUTH_USER=jvb
```

#### Cấu hình Let's Encrypt
```
ENABLE_LETSENCRYPT=1
LETSENCRYPT_DOMAIN=meet.thanhnguyen.group
LETSENCRYPT_EMAIL=nguyennhanduc@gmail.com
```

#### Cấu hình giao diện
```
APP_NAME=Thanh Nguyen Meet
DEFAULT_LANGUAGE=vi
PRIMARY_COLOR=#1976d2
LOGO_URL=https://meet.thanhnguyen.group/images/logo.png
ENABLE_GUESTS=true
AUTH_TYPE=internal
```

## Bước 3: Cấu hình Domain và SSL

### 3.1 Cấu hình DNS
Thêm các A records:
```
meet.thanhnguyen.group -> IP_VPS
auth.meet.thanhnguyen.group -> IP_VPS
muc.meet.thanhnguyen.group -> IP_VPS
```

### 3.2 Cấu hình SSL
- Coolify sẽ tự động cấu hình SSL với Let's Encrypt
- Đảm bảo domain đã trỏ đúng IP trước khi deploy

## Bước 4: Cấu hình Firewall

### 4.1 Mở ports cần thiết
```bash
# HTTP/HTTPS
sudo ufw allow 80
sudo ufw allow 443

# JVB ports
sudo ufw allow 10000:10010/udp

# SSH
sudo ufw allow 22
```

### 4.2 Cấu hình iptables (nếu cần)
```bash
# Cho phép traffic từ Coolify
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 10000:10010 -j ACCEPT
```

## Bước 5: Deploy Application

### 5.1 Deploy từ Coolify
1. Click "Deploy" trong Coolify dashboard
2. Chờ build và deploy hoàn tất
3. Kiểm tra logs nếu có lỗi

### 5.2 Kiểm tra deployment
```bash
# Kiểm tra containers
docker ps

# Kiểm tra logs
docker logs jitsi-meet-web
docker logs jitsi-meet-prosody
docker logs jitsi-meet-jicofo
docker logs jitsi-meet-jvb
```

## Bước 6: Cấu hình Nginx (nếu cần)

### 6.1 Tạo reverse proxy
```nginx
server {
    listen 80;
    server_name meet.thanhnguyen.group;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name meet.thanhnguyen.group;
    
    ssl_certificate /etc/letsencrypt/live/meet.thanhnguyen.group/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/meet.thanhnguyen.group/privkey.pem;
    
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Bước 7: Cấu hình Monitoring

### 7.1 Cấu hình Health Check
Thêm vào Coolify environment:
```
HEALTH_CHECK_URL=https://meet.thanhnguyen.group/health
HEALTH_CHECK_INTERVAL=30
```

### 7.2 Cấu hình Logging
```bash
# Cấu hình log rotation
sudo nano /etc/logrotate.d/jitsi-meet
```

## Bước 8: Backup và Maintenance

### 8.1 Backup cấu hình
```bash
# Backup volumes
docker run --rm -v jitsi-meet-cfg:/data -v $(pwd):/backup alpine tar czf /backup/jitsi-meet-cfg.tar.gz -C /data .
```

### 8.2 Update application
1. Push code mới lên GitHub
2. Coolify sẽ tự động detect và rebuild
3. Hoặc manual trigger từ dashboard

## Troubleshooting

### Lỗi thường gặp

#### 1. Container không start
```bash
# Kiểm tra logs
docker logs container_name

# Kiểm tra environment variables
docker exec container_name env
```

#### 2. SSL không hoạt động
- Kiểm tra domain đã trỏ đúng IP
- Kiểm tra Let's Encrypt logs
- Restart nginx nếu cần

#### 3. Video không hoạt động
- Kiểm tra firewall ports
- Kiểm tra JVB container logs
- Kiểm tra network configuration

#### 4. Performance issues
- Tăng RAM/CPU cho VPS
- Tối ưu hóa Docker images
- Cấu hình resource limits

### Commands hữu ích

```bash
# Restart tất cả containers
docker-compose restart

# Rebuild và restart
docker-compose up -d --build

# Xem logs real-time
docker-compose logs -f

# Kiểm tra resource usage
docker stats

# Clean up unused images
docker system prune -a
```

## Monitoring và Maintenance

### 1. Cấu hình monitoring
- Sử dụng Coolify built-in monitoring
- Hoặc tích hợp với Prometheus/Grafana
- Cấu hình alerts cho CPU/RAM/Disk

### 2. Backup strategy
- Backup volumes định kỳ
- Backup cấu hình nginx
- Backup SSL certificates

### 3. Update strategy
- Test trên staging trước
- Backup trước khi update
- Rollback plan nếu cần

## Kết luận

Với cấu hình này, bạn sẽ có một Jitsi Meet instance hoàn chỉnh trên Coolify với:
- ✅ Giao diện tùy chỉnh
- ✅ SSL tự động
- ✅ Auto-deploy từ GitHub
- ✅ Monitoring và logging
- ✅ Backup và maintenance

Chúc bạn triển khai thành công! 🚀
