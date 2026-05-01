#!/bin/bash

# Container Management Script for OpenMRS EMR4ALL
# This script provides a menu-driven interface for managing Docker containers

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Function to detect Docker Compose command
detect_docker_compose() {
    if command -v docker-compose &> /dev/null; then
        echo "docker-compose"
    elif docker compose version &> /dev/null; then
        echo "docker compose"
    else
        echo ""
    fi
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker first."
        exit 1
    fi
    
    # Check for Docker Compose
    DOCKER_COMPOSE_CMD=$(detect_docker_compose)
    if [ -z "$DOCKER_COMPOSE_CMD" ]; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
}

# Function to show container status
show_status() {
    print_header "Container Status"
    $DOCKER_COMPOSE_CMD ps
    echo ""
}

# Function for fastfetch - quick system and container overview
fastfetch() {
    print_header "Fast System Overview"
    
    echo -e "${BLUE}System Information:${NC}"
    echo "├── Host: $(hostname)"
    echo "├── OS: $(uname -s) $(uname -r)"
    echo "├── Uptime: $(uptime -p 2>/dev/null || uptime)"
    echo "├── Disk Usage: $(df -h / | tail -1 | awk '{print $5}') ($(df -h / | tail -1 | awk '{print $4}' | sed 's/G/GB/;s/M/MB/;s/K/KB/') free)"
    echo "├── Memory Usage: $(free -h | awk 'NR==2{printf "%.1f%% (%s/%s)", $3*100/$2, $3, $2}')"
    echo "└── Docker Version: $(docker --version 2>/dev/null | cut -d' ' -f3 | sed 's/,//')"
    echo ""
    
    echo -e "${BLUE}Container Status:${NC}"
    if $DOCKER_COMPOSE_CMD ps --services --quiet | xargs $DOCKER_COMPOSE_CMD ps 2>/dev/null | grep -q "Up"; then
        $DOCKER_COMPOSE_CMD ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}" | while IFS= read -r line; do
            if [[ $line == *"Up"* ]]; then
                echo "├── $line"
            else
                echo "├── $line"
            fi
        done
    else
        echo "└── No containers running"
    fi
    echo ""
    
    echo -e "${BLUE}Resource Usage:${NC}"
    if command -v docker stats --no-stream &> /dev/null; then
        docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" 2>/dev/null | while IFS= read -r line; do
            if [[ $line == *"CONTAINER"* ]]; then
                echo "├── $line"
            else
                echo "└── $line"
            fi
        done
    else
        echo "└── Docker stats not available"
    fi
    echo ""
    
    echo -e "${BLUE}Network Ports:${NC}"
    echo "├── Gateway: http://localhost:80"
    echo "├── Frontend: http://localhost:80/openmrs/spa"
    echo "└── Backend API: http://localhost:80/openmrs"
    echo ""
    
    echo -e "${BLUE}Quick Actions:${NC}"
    echo "├── Config file: frontend/config-core_demo.json"
    echo "├── Docker Compose: docker-compose.yml"
    echo "└── Logs: docker-compose logs -f"
    echo ""
}

# Function to build and start containers
build_and_start() {
    print_header "Building and Starting Containers"
    print_status "Building all containers..."
    $DOCKER_COMPOSE_CMD build --no-cache
    print_status "Starting all containers..."
    $DOCKER_COMPOSE_CMD up -d
    print_status "Containers are now running!"
    show_status
}

# Function to rebuild containers
rebuild_containers() {
    print_header "Rebuilding Containers"
    print_warning "This will rebuild all containers from scratch..."
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Stopping containers..."
        $DOCKER_COMPOSE_CMD down
        print_status "Removing containers and images..."
        $DOCKER_COMPOSE_CMD down --rmi all
        print_status "Rebuilding containers..."
        $DOCKER_COMPOSE_CMD build --no-cache
        print_status "Starting containers..."
        $DOCKER_COMPOSE_CMD up -d
        print_status "Containers rebuilt and started!"
        show_status
    else
        print_status "Rebuild cancelled."
    fi
}

# Function to stop and remove containers
delete_containers() {
    print_header "Deleting Containers"
    print_warning "This will stop and remove all containers..."
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Stopping and removing containers..."
        $DOCKER_COMPOSE_CMD down --volumes --remove-orphans
        print_status "Containers deleted!"
        show_status
    else
        print_status "Delete cancelled."
    fi
}

# Function to prune Docker system
prune_docker() {
    print_header "Pruning Docker System"
    print_warning "This will remove all unused Docker resources (images, containers, volumes, networks)..."
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Pruning Docker system..."
        docker system prune -a --volumes -f
        print_status "Docker system pruned!"
    else
        print_status "Prune cancelled."
    fi
}

# Function to clean up dangling images and containers
cleanup_dangling() {
    print_header "Cleaning Up Dangling Images and Containers"
    print_status "Removing dangling images..."
    DANGLING_IMAGES=$(docker images -f "dangling=true" -q)
    if [ -n "$DANGLING_IMAGES" ]; then
        docker rmi $DANGLING_IMAGES
        print_status "Removed $(echo $DANGLING_IMAGES | wc -w) dangling images"
    else
        print_status "No dangling images found"
    fi
    
    print_status "Removing stopped containers..."
    STOPPED_CONTAINERS=$(docker ps -a -f "status=exited" -q)
    if [ -n "$STOPPED_CONTAINERS" ]; then
        docker rm $STOPPED_CONTAINERS
        print_status "Removed $(echo $STOPPED_CONTAINERS | wc -w) stopped containers"
    else
        print_status "No stopped containers found"
    fi
    
    print_status "Removing unused build cache..."
    docker builder prune -f
    
    print_status "Cleanup completed!"
}

# Function to update frontend without rebuild
update_frontend() {
    print_header "Updating Frontend (No Rebuild)"
    print_status "Updating frontend configuration and static assets..."
    
    # Check if frontend container is running
    if ! $DOCKER_COMPOSE_CMD ps frontend | grep -q "Up"; then
        print_error "Frontend container is not running. Please start the containers first."
        return 1
    fi
    
    # Copy updated config file
    print_status "Copying updated config file..."
    docker cp frontend/config-core_demo.json $($DOCKER_COMPOSE_CMD ps -q frontend):/usr/share/nginx/html/
    
    # Copy logo file if it exists
    if [ -f "frontend/logo.png" ]; then
        print_status "Copying logo file..."
        docker cp frontend/logo.png $($DOCKER_COMPOSE_CMD ps -q frontend):/usr/share/nginx/html/
    fi
    
    # Restart nginx in the frontend container to reload config
    print_status "Reloading nginx configuration..."
    $DOCKER_COMPOSE_CMD exec frontend nginx -s reload
    
    print_status "Frontend updated successfully!"
    print_status "Changes should be reflected immediately in your browser."
}

# Function to show logs
show_logs() {
    print_header "Showing Container Logs"
    echo "Select which service logs to view:"
    echo "1) All services"
    echo "2) Frontend"
    echo "3) Backend"
    echo "4) Gateway"
    echo "5) Database"
    echo "6) Return to main menu"
    read -p "Enter your choice (1-6): " log_choice
    
    case $log_choice in
        1)
            $DOCKER_COMPOSE_CMD logs -f --tail=50
            ;;
        2)
            $DOCKER_COMPOSE_CMD logs -f --tail=50 frontend
            ;;
        3)
            $DOCKER_COMPOSE_CMD logs -f --tail=50 backend
            ;;
        4)
            $DOCKER_COMPOSE_CMD logs -f --tail=50 gateway
            ;;
        5)
            $DOCKER_COMPOSE_CMD logs -f --tail=50 db
            ;;
        6)
            return
            ;;
        *)
            print_error "Invalid choice. Returning to main menu."
            ;;
    esac
}

# Function to access container shell
access_shell() {
    print_header "Access Container Shell"
    echo "Select which container to access:"
    echo "1) Frontend"
    echo "2) Backend"
    echo "3) Gateway"
    echo "4) Database"
    echo "5) Return to main menu"
    read -p "Enter your choice (1-5): " shell_choice
    
    case $shell_choice in
        1)
            $DOCKER_COMPOSE_CMD exec frontend /bin/sh
            ;;
        2)
            $DOCKER_COMPOSE_CMD exec backend /bin/bash
            ;;
        3)
            $DOCKER_COMPOSE_CMD exec gateway /bin/sh
            ;;
        4)
            $DOCKER_COMPOSE_CMD exec db /bin/bash
            ;;
        5)
            return
            ;;
        *)
            print_error "Invalid choice. Returning to main menu."
            ;;
    esac
}

# Main menu function
show_menu() {
    clear
    print_header "OpenMRS EMR4ALL Container Management"
    echo "Current container status:"
    $DOCKER_COMPOSE_CMD ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
    echo ""
    echo "Please select an action:"
    echo "1) Build and start all containers"
    echo "2) Rebuild all containers (from scratch)"
    echo "3) Stop and delete containers"
    echo "4) Prune Docker system (clean up unused resources)"
    echo "5) Clean up dangling images and containers"
    echo "6) Update frontend without rebuild (copy static assets)"
    echo "7) Show container logs"
    echo "8) Access container shell"
    echo "9) Show container status"
    echo "10) Fastfetch (quick system overview)"
    echo "11) Exit"
    echo ""
}

# Main program loop
main() {
    check_docker
    # Set global variable for Docker Compose command
    DOCKER_COMPOSE_CMD=$(detect_docker_compose)
    
    while true; do
        show_menu
        read -p "Enter your choice (1-11): " choice
        echo ""
        
        case $choice in
            1)
                build_and_start
                ;;
            2)
                rebuild_containers
                ;;
            3)
                delete_containers
                ;;
            4)
                prune_docker
                ;;
            5)
                cleanup_dangling
                ;;
            6)
                update_frontend
                ;;
            7)
                show_logs
                ;;
            8)
                access_shell
                ;;
            9)
                show_status
                ;;
            10)
                fastfetch
                ;;
            11)
                print_status "Goodbye!"
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please select a number between 1 and 11."
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Run main function
main "$@"
