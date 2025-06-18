#!/bin/bash

# Stop all running containers
docker-compose -f docker-compose.production.yml down

# Remove all unused containers, networks, images
docker system prune -f

# Build and start all services
docker-compose -f docker-compose.production.yml up -d --build

# Wait for services to start
echo "Waiting for services to start..."
sleep 30

# Check service status
echo "Checking service status..."
docker-compose -f docker-compose.production.yml ps

# Check service logs
echo "Checking service logs..."
docker-compose -f docker-compose.production.yml logs --tail=50 