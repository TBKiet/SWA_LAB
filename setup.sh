#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${GREEN}[✓] $1${NC}"
}

print_error() {
    echo -e "${RED}[✗] $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    print_warning "Please don't run this script as root"
    exit 1
fi

# Check prerequisites
print_status "Checking prerequisites..."

# Check Node.js
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed"
    print_warning "Please install Node.js v14 or higher"
    exit 1
fi

# Check npm
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed"
    print_warning "Please install npm"
    exit 1
fi

# Check Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed"
    print_warning "Please install Docker"
    exit 1
fi

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed"
    print_warning "Please install Docker Compose"
    exit 1
fi

# Get Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2)
NODE_MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1)

if [ "$NODE_MAJOR_VERSION" -lt 14 ]; then
    print_error "Node.js version must be 14 or higher"
    print_warning "Current version: $NODE_VERSION"
    exit 1
fi

print_status "All prerequisites are satisfied"

# Create .env files if they don't exist
print_status "Setting up environment files..."

# Service Registry
if [ ! -f "service-registry/.env" ]; then
    cp service-registry/.env.example service-registry/.env
    print_status "Created service-registry/.env"
fi

# Gateway
if [ ! -f "gateway/.env" ]; then
    cp gateway/.env.example gateway/.env
    print_status "Created gateway/.env"
fi

# User Service
if [ ! -f "services/user/.env" ]; then
    cp services/user/.env.example services/user/.env
    print_status "Created services/user/.env"
fi

# Task Service
if [ ! -f "services/task/.env" ]; then
    cp services/task/.env.example services/task/.env
    print_status "Created services/task/.env"
fi

# Notification Service
if [ ! -f "services/notification/.env" ]; then
    cp services/notification/.env.example services/notification/.env
    print_status "Created services/notification/.env"
fi

# Reminder Service
if [ ! -f "services/reminder/.env" ]; then
    cp services/reminder/.env.example services/reminder/.env
    print_status "Created services/reminder/.env"
fi

# Install dependencies
print_status "Installing dependencies..."

# Service Registry
print_status "Installing Service Registry dependencies..."
cd service-registry
npm install
cd ..

# Gateway
print_status "Installing Gateway dependencies..."
cd gateway
npm install
cd ..

# User Service
print_status "Installing User Service dependencies..."
cd services/user
npm install
cd ../..

# Task Service
print_status "Installing Task Service dependencies..."
cd services/task
npm install
cd ../..

# Notification Service
print_status "Installing Notification Service dependencies..."
cd services/notification
npm install
cd ../..

# Reminder Service
print_status "Installing Reminder Service dependencies..."
cd services/reminder
npm install
cd ../..

print_status "All dependencies installed successfully"

# Start services using Docker Compose
print_status "Starting services with Docker Compose..."

# Check if Docker daemon is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker daemon is not running"
    print_warning "Please start Docker and try again"
    exit 1
fi

# Start services
docker-compose up -d

print_status "Setup completed successfully!"
print_status "Services are now running:"
echo -e "${GREEN}Service Registry:${NC} http://localhost:3100"
echo -e "${GREEN}API Gateway:${NC} http://localhost:8080"
echo -e "${GREEN}API Documentation:${NC} http://localhost:8080/api-docs"
echo -e "${GREEN}User Service:${NC} http://localhost:3001"
echo -e "${GREEN}Task Service:${NC} http://localhost:3002"
echo -e "${GREEN}Notification Service:${NC} http://localhost:3003"
echo -e "${GREEN}Reminder Service:${NC} http://localhost:3004"

print_warning "To stop all services, run: docker-compose down" 