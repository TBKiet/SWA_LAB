# Microservices và Deployment
## Bài thuyết trình về Kiến trúc Microservices và Quy trình Deployment

---

## Mục lục
1. [Giới thiệu về Microservices](#1-giới-thiệu-về-microservices)
2. [Tại sao chọn Microservices?](#2-tại-sao-chọn-microservices)
3. [Kiến trúc Microservices](#3-kiến-trúc-microservices)
4. [Docker và Containerization](#4-docker-và-containerization)
5. [Deployment Local](#5-deployment-local)
6. [Deployment Production](#6-deployment-production)
7. [Demo Thực Tế](#7-demo-thực-tế)
8. [Troubleshooting](#8-troubleshooting)
9. [Best Practices](#9-best-practices)

---

## 1. Giới thiệu về Microservices

### 1.1 Định nghĩa
- Microservices là cách chia một ứng dụng lớn thành nhiều phần nhỏ, độc lập
- Mỗi service có thể:
  - Chạy riêng biệt
  - Được phát triển bởi team khác nhau
  - Sử dụng công nghệ khác nhau
  - Scale riêng biệt

### 1.2 Ví dụ thực tế
Ứng dụng Todo của chúng ta có các service:
1. **User Service**: Quản lý người dùng
   - Đăng ký, đăng nhập
   - Quản lý profile
   - Xác thực người dùng

2. **Task Service**: Quản lý công việc
   - Tạo, sửa, xóa task
   - Phân loại task
   - Theo dõi tiến độ

3. **Reminder Service**: Nhắc nhở
   - Tạo lịch nhắc nhở
   - Gửi thông báo
   - Quản lý thời gian

4. **Notification Service**: Gửi thông báo
   - Gửi email
   - Gửi thông báo realtime
   - Quản lý template

5. **Service Registry**: Đăng ký và tìm service
   - Quản lý danh sách service
   - Health check
   - Service discovery

6. **Gateway**: Cổng vào chính của ứng dụng
   - Xử lý request
   - Phân phối traffic
   - Bảo mật

---

## 2. Tại sao chọn Microservices?

### 2.1 So sánh với các kiến trúc khác

#### Monolithic Architecture
**Ưu điểm:**
- Dễ phát triển ban đầu
- Dễ test
- Dễ deploy
- Hiệu năng tốt cho ứng dụng nhỏ

**Nhược điểm:**
- Khó scale
- Khó bảo trì khi code lớn
- Một lỗi có thể ảnh hưởng toàn bộ hệ thống
- Khó áp dụng công nghệ mới
- Team lớn khó phối hợp

#### Microservices Architecture
**Ưu điểm:**
- Dễ scale từng phần
- Dễ bảo trì và nâng cấp
- Lỗi được cô lập
- Có thể sử dụng công nghệ khác nhau
- Team nhỏ, độc lập
- Dễ mở rộng tính năng

**Nhược điểm:**
- Phức tạp hơn trong quản lý
- Cần nhiều tài nguyên hơn
- Khó test end-to-end
- Cần xử lý distributed transactions
- Cần quản lý service discovery

### 2.2 Khi nào nên dùng Microservices?

1. **Quy mô ứng dụng:**
   - Ứng dụng lớn, nhiều tính năng
   - Cần scale theo từng phần
   - Có nhiều team phát triển

2. **Yêu cầu kỹ thuật:**
   - Cần độ tin cậy cao
   - Cần khả năng mở rộng
   - Cần deploy liên tục
   - Cần sử dụng nhiều công nghệ

3. **Yêu cầu kinh doanh:**
   - Cần phát triển nhanh
   - Cần thay đổi linh hoạt
   - Cần tối ưu chi phí vận hành

### 2.3 Ví dụ thực tế

#### Netflix
- Chuyển từ monolithic sang microservices
- Xử lý 1 tỷ request/ngày
- 800+ microservices
- Deploy 1000+ lần/ngày

#### Amazon
- Mỗi team phụ trách một service
- Deploy mỗi 11.6 giây
- Xử lý hàng triệu đơn hàng/ngày

#### Uber
- Chia theo domain (rides, payments, maps)
- Scale theo từng khu vực
- Xử lý realtime data

---

## 3. Kiến trúc Microservices

### 3.1 Service Registry
- Là "bảng thông tin" của hệ thống
- Giúp các service tìm thấy nhau
- Theo dõi service nào đang hoạt động
- Quản lý health check

### 3.2 API Gateway
- Là "cổng vào" duy nhất của ứng dụng
- Xử lý authentication
- Phân phối request đến service phù hợp
- Rate limiting
- Caching

### 3.3 Các Service
- Mỗi service có database riêng
- Giao tiếp qua HTTP hoặc message queue
- Có thể scale độc lập
- Có thể sử dụng công nghệ khác nhau

---

## 4. Docker và Containerization

### 4.1 Docker là gì?
- Docker là nền tảng để đóng gói, vận chuyển và chạy ứng dụng trong môi trường cô lập (container)
- Giống như một chiếc hộp chứa tất cả những gì ứng dụng cần để chạy
- Đảm bảo ứng dụng chạy giống nhau ở mọi môi trường

### 4.2 Tại sao phải dùng Docker?

#### Vấn đề không dùng Docker:
1. **Môi trường khác nhau:**
   - "Works on my machine"
   - Khó reproduce bugs
   - Khó setup môi trường mới

2. **Phụ thuộc phức tạp:**
   - Cài đặt nhiều version
   - Xung đột dependencies
   - Khó quản lý versions

3. **Khó scale:**
   - Cài đặt thủ công
   - Không đồng nhất
   - Tốn thời gian setup

#### Lợi ích của Docker:
1. **Nhất quán:**
   - Chạy giống nhau ở mọi nơi
   - Dễ reproduce bugs
   - Dễ setup môi trường mới

2. **Cô lập:**
   - Mỗi container độc lập
   - Không ảnh hưởng lẫn nhau
   - Dễ quản lý resources

3. **Hiệu quả:**
   - Khởi động nhanh
   - Sử dụng ít tài nguyên
   - Dễ scale

### 4.3 Các file Docker quan trọng

#### 1. Dockerfile
```dockerfile
# Base image
FROM node:18-alpine

# Working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build application
RUN npm run build

# Expose port
EXPOSE 3000

# Start command
CMD ["npm", "start"]
```

**Giải thích từng lệnh:**
- `FROM`: Chọn base image
- `WORKDIR`: Thư mục làm việc trong container
- `COPY`: Copy file từ host vào container
- `RUN`: Chạy lệnh trong quá trình build
- `EXPOSE`: Khai báo port sẽ sử dụng
- `CMD`: Lệnh chạy khi container start

#### 2. docker-compose.yml
```yaml
version: '3.8'
services:
  user-service:
    build: ./services/user
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=development
    depends_on:
      - postgres
      - rabbitmq

  postgres:
    image: postgres:14-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: todo_app
    volumes:
      - postgres_data:/var/lib/postgresql/data
```

**Giải thích các thành phần:**
- `version`: Phiên bản docker-compose
- `services`: Định nghĩa các service
- `build`: Đường dẫn đến Dockerfile
- `ports`: Map port host:container
- `environment`: Biến môi trường
- `depends_on`: Service phụ thuộc
- `volumes`: Lưu trữ dữ liệu

### 4.4 Các lệnh Docker cơ bản

#### Quản lý Images:
```bash
# Tải image
docker pull node:18-alpine

# Liệt kê images
docker images

# Xóa image
docker rmi node:18-alpine
```

#### Quản lý Containers:
```bash
# Chạy container
docker run -d -p 3000:3000 my-app

# Liệt kê containers
docker ps

# Dừng container
docker stop container_id

# Xóa container
docker rm container_id

# Xem logs
docker logs container_id
```

#### Docker Compose:
```bash
# Khởi động tất cả services
docker-compose up -d

# Dừng tất cả services
docker-compose down

# Xem logs
docker-compose logs -f

# Rebuild services
docker-compose up -d --build
```

### 4.5 Best Practices

1. **Dockerfile:**
   - Sử dụng multi-stage builds
   - Tối ưu layer caching
   - Sử dụng .dockerignore
   - Chọn base image phù hợp

2. **Docker Compose:**
   - Tách biệt môi trường
   - Sử dụng volumes
   - Cấu hình networks
   - Quản lý dependencies

3. **Security:**
   - Không chạy container với root
   - Scan vulnerabilities
   - Sử dụng secrets
   - Giới hạn resources

---

## 5. Deployment Local

### 5.1 Yêu cầu
1. Docker Desktop
2. Git
3. Node.js (tùy chọn)

### 5.2 Các bước thực hiện

#### Windows
```bash
# Cài đặt Docker Desktop
# Tải từ: https://www.docker.com/products/docker-desktop

# Clone code
git clone https://github.com/your-repo/todo-microservices.git
cd todo-microservices

# Chạy ứng dụng
docker-compose up -d
```

#### macOS
```bash
# Cài đặt Docker Desktop
brew install --cask docker

# Clone code
git clone https://github.com/your-repo/todo-microservices.git
cd todo-microservices

# Chạy ứng dụng
docker-compose up -d
```

#### Linux (Ubuntu)
```bash
# Cài đặt Docker
sudo apt update
sudo apt install docker.io docker-compose

# Clone code
git clone https://github.com/your-repo/todo-microservices.git
cd todo-microservices

# Chạy ứng dụng
docker-compose up -d
```

### 5.3 Kiểm tra
- Truy cập: http://localhost:8080
- Kiểm tra health: http://localhost:8080/health

---

## 6. Deployment Production

### 6.1 Render.com
**Ưu điểm:**
- Miễn phí
- Dễ sử dụng
- Tự động deploy
- Có sẵn database

### 6.2 Các bước thực hiện

1. **Chuẩn bị code:**
   - Tạo file `render.yaml`
   - Cập nhật các file `.env.production`

2. **Deploy lên Render:**
   - Đăng ký tài khoản tại render.com
   - Kết nối với GitHub
   - Chọn repository
   - Render tự động deploy

3. **Kiểm tra:**
   - Truy cập: https://todo-gateway.onrender.com
   - Kiểm tra health: https://todo-gateway.onrender.com/health

---

## 7. Demo Thực Tế

### 7.1 Local Development
1. Mở terminal
2. Chạy `docker-compose up -d`
3. Kiểm tra các service:
   - Gateway: http://localhost:8080/health
   - User Service: http://localhost:3001/health
   - Task Service: http://localhost:3002/health

### 7.2 Production Deployment
1. Mở render.com
2. Chọn "New Blueprint"
3. Chọn repository
4. Đợi deploy
5. Kiểm tra các service:
   - Gateway: https://todo-gateway.onrender.com/health
   - User Service: https://todo-user-service.onrender.com/health

---

## 8. Troubleshooting

### 8.1 Các vấn đề thường gặp

1. **Service không start:**
```bash
# Kiểm tra logs
docker-compose logs [service-name]

# Restart service
docker-compose restart [service-name]
```

2. **Database connection error:**
- Kiểm tra DATABASE_URL trong .env
- Đảm bảo database đã start

3. **Service không giao tiếp được:**
- Kiểm tra Service Registry
- Kiểm tra network trong Docker

---

## 9. Best Practices

### 9.1 Development
- Sử dụng Docker Compose
- Có file .env.example
- Có README chi tiết

### 9.2 Production
- Sử dụng managed service (Render)
- Có monitoring
- Có backup strategy

### 9.3 Security
- Không commit .env
- Sử dụng HTTPS
- Có rate limiting

---

## Tài liệu tham khảo
1. [Docker Documentation](https://docs.docker.com/)
2. [Render Documentation](https://render.com/docs)
3. [Microservices.io](https://microservices.io/)

---

## Q&A
Cảm ơn các bạn đã lắng nghe!
Bạn có câu hỏi gì không? 