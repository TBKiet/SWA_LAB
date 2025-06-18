#!/bin/bash

# Cấp quyền thực thi cho script
chmod +x init-multiple-dbs.sh

# Build và start các containers
echo "Building and starting containers..."
docker-compose up --build -d

# Kiểm tra trạng thái các containers
echo "Checking container status..."
docker-compose ps

# Kiểm tra logs
echo "Checking logs..."
docker-compose logs --tail=50 