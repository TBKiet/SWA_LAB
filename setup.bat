@echo off
setlocal enabledelayedexpansion

:: Colors for output
set "GREEN=[92m"
set "RED=[91m"
set "YELLOW=[93m"
set "NC=[0m"

:: Function to print status messages
call :print_status "Checking prerequisites..."

:: Check Node.js
where node >nul 2>nul
if %ERRORLEVEL% neq 0 (
    call :print_error "Node.js is not installed"
    call :print_warning "Please install Node.js v14 or higher"
    exit /b 1
)

:: Check npm
where npm >nul 2>nul
if %ERRORLEVEL% neq 0 (
    call :print_error "npm is not installed"
    call :print_warning "Please install npm"
    exit /b 1
)

:: Check Docker
where docker >nul 2>nul
if %ERRORLEVEL% neq 0 (
    call :print_error "Docker is not installed"
    call :print_warning "Please install Docker"
    exit /b 1
)

:: Check Docker Compose
where docker-compose >nul 2>nul
if %ERRORLEVEL% neq 0 (
    call :print_error "Docker Compose is not installed"
    call :print_warning "Please install Docker Compose"
    exit /b 1
)

:: Get Node.js version
for /f "tokens=* usebackq" %%F in (`node -v`) do (
    set NODE_VERSION=%%F
)
set NODE_VERSION=%NODE_VERSION:~1%
for /f "tokens=1 delims=." %%a in ("%NODE_VERSION%") do set NODE_MAJOR_VERSION=%%a

if %NODE_MAJOR_VERSION% LSS 14 (
    call :print_error "Node.js version must be 14 or higher"
    call :print_warning "Current version: %NODE_VERSION%"
    exit /b 1
)

call :print_status "All prerequisites are satisfied"

:: Create .env files if they don't exist
call :print_status "Setting up environment files..."

:: Service Registry
if not exist "service-registry\.env" (
    copy "service-registry\.env.example" "service-registry\.env"
    call :print_status "Created service-registry\.env"
)

:: Gateway
if not exist "gateway\.env" (
    copy "gateway\.env.example" "gateway\.env"
    call :print_status "Created gateway\.env"
)

:: User Service
if not exist "services\user\.env" (
    copy "services\user\.env.example" "services\user\.env"
    call :print_status "Created services\user\.env"
)

:: Task Service
if not exist "services\task\.env" (
    copy "services\task\.env.example" "services\task\.env"
    call :print_status "Created services\task\.env"
)

:: Notification Service
if not exist "services\notification\.env" (
    copy "services\notification\.env.example" "services\notification\.env"
    call :print_status "Created services\notification\.env"
)

:: Reminder Service
if not exist "services\reminder\.env" (
    copy "services\reminder\.env.example" "services\reminder\.env"
    call :print_status "Created services\reminder\.env"
)

:: Install dependencies
call :print_status "Installing dependencies..."

:: Service Registry
call :print_status "Installing Service Registry dependencies..."
cd service-registry
call npm install
cd ..

:: Gateway
call :print_status "Installing Gateway dependencies..."
cd gateway
call npm install
cd ..

:: User Service
call :print_status "Installing User Service dependencies..."
cd services\user
call npm install
cd ..\..

:: Task Service
call :print_status "Installing Task Service dependencies..."
cd services\task
call npm install
cd ..\..

:: Notification Service
call :print_status "Installing Notification Service dependencies..."
cd services\notification
call npm install
cd ..\..

:: Reminder Service
call :print_status "Installing Reminder Service dependencies..."
cd services\reminder
call npm install
cd ..\..

call :print_status "All dependencies installed successfully"

:: Start services using Docker Compose
call :print_status "Starting services with Docker Compose..."

:: Check if Docker daemon is running
docker info >nul 2>&1
if %ERRORLEVEL% neq 0 (
    call :print_error "Docker daemon is not running"
    call :print_warning "Please start Docker and try again"
    exit /b 1
)

:: Start services
docker-compose up -d

call :print_status "Setup completed successfully!"
call :print_status "Services are now running:"
echo %GREEN%Service Registry:%NC% http://localhost:3100
echo %GREEN%API Gateway:%NC% http://localhost:8080
echo %GREEN%API Documentation:%NC% http://localhost:8080/api-docs
echo %GREEN%User Service:%NC% http://localhost:3001
echo %GREEN%Task Service:%NC% http://localhost:3002
echo %GREEN%Notification Service:%NC% http://localhost:3003
echo %GREEN%Reminder Service:%NC% http://localhost:3004

call :print_warning "To stop all services, run: docker-compose down"

exit /b 0

:print_status
echo %GREEN%[✓] %~1%NC%
exit /b 0

:print_error
echo %RED%[✗] %~1%NC%
exit /b 0

:print_warning
echo %YELLOW%[!] %~1%NC%
exit /b 0 