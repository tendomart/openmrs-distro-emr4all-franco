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

    # Check if SSL is enabled and use appropriate compose files
    if [ -f ".ssl_enabled" ]; then
        print_status "SSL is enabled. Using docker-compose.ssl.yml..."
        DOCKER_COMPOSE_FILES="-f docker-compose.yml -f docker-compose.ssl.yml"
    else
        DOCKER_COMPOSE_FILES="-f docker-compose.yml"
    fi

    print_status "Building all containers..."
    $DOCKER_COMPOSE_CMD $DOCKER_COMPOSE_FILES build --no-cache
    print_status "Starting all containers..."
    $DOCKER_COMPOSE_CMD $DOCKER_COMPOSE_FILES up -d
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
        # Check if SSL is enabled
        if [ -f ".ssl_enabled" ]; then
            DOCKER_COMPOSE_FILES="-f docker-compose.yml -f docker-compose.ssl.yml"
        else
            DOCKER_COMPOSE_FILES="-f docker-compose.yml"
        fi

        print_status "Stopping containers..."
        $DOCKER_COMPOSE_CMD $DOCKER_COMPOSE_FILES down
        print_status "Removing containers and images..."
        $DOCKER_COMPOSE_CMD $DOCKER_COMPOSE_FILES down --rmi all
        print_status "Rebuilding containers..."
        $DOCKER_COMPOSE_CMD $DOCKER_COMPOSE_FILES build --no-cache
        print_status "Starting containers..."
        $DOCKER_COMPOSE_CMD $DOCKER_COMPOSE_FILES up -d
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
        # Check if SSL is enabled
        if [ -f ".ssl_enabled" ]; then
            DOCKER_COMPOSE_FILES="-f docker-compose.yml -f docker-compose.ssl.yml"
        else
            DOCKER_COMPOSE_FILES="-f docker-compose.yml"
        fi

        print_status "Stopping and removing containers..."
        $DOCKER_COMPOSE_CMD $DOCKER_COMPOSE_FILES down --volumes --remove-orphans
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

# Function to verify config and logo in container
verify_config() {
    print_header "Verifying Configuration in Container"
    
    # Check if frontend container is running
    if ! $DOCKER_COMPOSE_CMD ps frontend | grep -q "Up"; then
        print_error "Frontend container is not running. Please start the containers first."
        return 1
    fi
    
    FRONTEND_ID=$($DOCKER_COMPOSE_CMD ps -q frontend)
    
    print_status "Checking config file in container..."
    if docker exec $FRONTEND_ID test -f /usr/share/nginx/html/config-core_demo.json; then
        print_status "✓ Config file exists in container"
        
        # Check if colors are present in config
        if docker exec $FRONTEND_ID grep -q "#87CEEB" /usr/share/nginx/html/config-core_demo.json; then
            print_status "✓ Brand color #1 (#87CEEB) found in config"
        else
            print_warning "✗ Brand color #1 not found in config"
        fi
        
        if docker exec $FRONTEND_ID grep -q "#012c3d" /usr/share/nginx/html/config-core_demo.json; then
            print_status "✓ Brand color #2 (#012c3d) found in config"
        else
            print_warning "✗ Brand color #2 not found in config"
        fi
        
        if docker exec $FRONTEND_ID grep -q "MaliEMR" /usr/share/nginx/html/config-core_demo.json; then
            print_status "✓ Implementation name (MaliEMR) found in config"
        else
            print_warning "✗ Implementation name not found in config"
        fi
    else
        print_error "✗ Config file not found in container"
    fi
    
    print_status "Checking logo file in container..."
    if docker exec $FRONTEND_ID test -f /usr/share/nginx/html/logo.png; then
        print_status "✓ Logo file exists in container"
        LOGO_SIZE=$(docker exec $FRONTEND_ID stat -c%s /usr/share/nginx/html/logo.png)
        print_status "  Logo size: $LOGO_SIZE bytes"
    else
        print_error "✗ Logo file not found in container"
    fi
    
    echo ""
    print_status "To apply changes, use option 6) Update frontend without rebuild"
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
    print_status "Clear browser cache (Ctrl+F5) if changes are not visible."
}

# Function to probe every concept referenced by the O3 form JSONs against the
# live backend, reporting any UUIDs the DB cannot resolve (which is the root
# cause of "Cannot invoke Obs.getConcept()" NPEs on encounter save).
probe_form_concepts() {
    print_header "Probing O3 Form Concepts Against Backend"

    FORMS_DIR="distro/configuration/forms"
    if [ ! -d "$FORMS_DIR" ]; then
        print_error "Forms directory not found: $FORMS_DIR"
        return 1
    fi

    # Verify backend is reachable
    if ! $DOCKER_COMPOSE_CMD ps backend | grep -q "Up"; then
        print_error "Backend container is not running. Start the stack first."
        return 1
    fi

    if ! command -v python3 >/dev/null 2>&1; then
        print_error "python3 is required on the host to extract concept UUIDs."
        return 1
    fi
    if ! command -v curl >/dev/null 2>&1; then
        print_error "curl is required on the host."
        return 1
    fi

    # Credentials (override via env OMRS_ADMIN_USER / OMRS_ADMIN_PASSWORD)
    OMRS_ADMIN_USER="${OMRS_ADMIN_USER:-admin}"
    OMRS_ADMIN_PASSWORD="${OMRS_ADMIN_PASSWORD:-Admin123}"
    # Probe via the gateway (port 80) so routing matches a real user request
    BASE_URL="${OMRS_BASE_URL:-http://localhost/openmrs}"

    TMP_UUIDS=$(mktemp)
    TMP_MISSING=$(mktemp)

    # Extract every obs / answer / toggleOptions concept UUID from every form
    python3 - "$FORMS_DIR" <<'PY' > "$TMP_UUIDS"
import json, os, sys, glob
forms_dir = sys.argv[1]
uuids = {}
for path in sorted(glob.glob(os.path.join(forms_dir, "*.json"))):
    try:
        d = json.load(open(path))
    except Exception as e:
        print(f"# PARSE ERROR {path}: {e}", file=sys.stderr); continue
    for p in d.get("pages", []):
        for s in p.get("sections", []):
            for q in s.get("questions", []):
                if q.get("type") != "obs": continue
                o = q.get("questionOptions") or {}
                def add(u, where):
                    if isinstance(u, str) and len(u) == 36:
                        uuids.setdefault(u, []).append(where)
                add(o.get("concept"), f"{os.path.basename(path)}::{q.get('id')}")
                for a in (o.get("answers") or []):
                    add(a.get("concept"), f"{os.path.basename(path)}::{q.get('id')}.answer")
                t = o.get("toggleOptions") or {}
                for side in ("checked", "unchecked"):
                    v = (t.get(side) or {}).get("concept")
                    add(v, f"{os.path.basename(path)}::{q.get('id')}.toggle.{side}")
for u, refs in sorted(uuids.items()):
    print(f"{u}\t{';'.join(refs)}")
PY

    TOTAL=$(wc -l < "$TMP_UUIDS" | tr -d ' ')
    if [ "$TOTAL" = "0" ]; then
        print_warning "No obs concept UUIDs found in $FORMS_DIR/*.json"
        rm -f "$TMP_UUIDS" "$TMP_MISSING"
        return 0
    fi
    print_status "Probing $TOTAL unique concept UUIDs against $BASE_URL ..."
    echo ""

    : > "$TMP_MISSING"
    while IFS=$'\t' read -r UUID REFS; do
        [ -z "$UUID" ] && continue
        CODE=$(curl -s -o /dev/null -w "%{http_code}" \
            -u "$OMRS_ADMIN_USER:$OMRS_ADMIN_PASSWORD" \
            "$BASE_URL/ws/rest/v1/concept/$UUID")
        if [ "$CODE" = "200" ]; then
            printf "  \033[0;32mOK\033[0m    %s  %s\n" "$UUID" "$REFS"
        else
            printf "  \033[0;31mMISS\033[0m  %s  (HTTP %s)  %s\n" "$UUID" "$CODE" "$REFS"
            echo "$UUID	$CODE	$REFS" >> "$TMP_MISSING"
        fi
    done < "$TMP_UUIDS"

    echo ""
    MISSING=$(wc -l < "$TMP_MISSING" | tr -d ' ')
    if [ "$MISSING" = "0" ]; then
        print_status "All $TOTAL concepts resolved. No NPE risk from missing concepts."
    else
        print_error "$MISSING of $TOTAL concepts are NOT in the DB."
        print_warning "These will cause 'Cannot invoke Obs.getConcept()' NPEs when users answer those questions."
        print_warning "Load them via OCL (Open Concept Lab) or add them to distro/configuration/concepts/*.csv."
        echo ""
        echo "Missing (UUID / HTTP / references):"
        cat "$TMP_MISSING"
    fi

    rm -f "$TMP_UUIDS" "$TMP_MISSING"
}

# Function to toggle SSL mode
toggle_ssl() {
    print_header "SSL Configuration"

    # Check if docker-compose.ssl.yml exists
    if [ ! -f "docker-compose.ssl.yml" ]; then
        print_error "docker-compose.ssl.yml not found. SSL configuration not available."
        return 1
    fi

    # Check current SSL status
    if [ -f ".ssl_enabled" ]; then
        print_status "SSL is currently ENABLED"
        echo ""
        echo "Current configuration:"
        echo "  - HTTPS port: 443"
        echo "  - Certbot service: Active"
        echo "  - Certificate mode: $([ -f .ssl_prod ] && echo 'Production (Let'\''s Encrypt)' || echo 'Development (Self-signed)')"
        echo ""
        read -p "Do you want to DISABLE SSL? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Disabling SSL..."
            rm -f .ssl_enabled .ssl_prod
            print_status "SSL disabled. Containers must be restarted to apply changes."
            print_status "Run option 1) Build and start all containers to restart."
        else
            print_status "SSL remains enabled."
        fi
    else
        print_status "SSL is currently DISABLED"
        echo ""
        echo "SSL options:"
        echo "1) Enable SSL with self-signed certificates (development/testing)"
        echo "2) Enable SSL with Let's Encrypt (production - requires domain)"
        echo "3) Cancel"
        echo ""
        read -p "Enter your choice (1-3): " ssl_choice

        case $ssl_choice in
            1)
                print_status "Enabling SSL with self-signed certificates..."
                enable_ssl_dev
                ;;
            2)
                print_status "Enabling SSL with Let's Encrypt..."
                enable_ssl_prod
                ;;
            3)
                print_status "Cancelled."
                return
                ;;
            *)
                print_error "Invalid choice."
                return
                ;;
        esac
    fi
}

# Function to enable SSL in development mode (self-signed)
enable_ssl_dev() {
    print_header "Enable SSL (Development Mode)"

    # Set environment variables for dev mode
    export SSL_MODE="dev"
    export CERT_WEB_DOMAINS="localhost,127.0.0.1"
    export SSL_STAGING="false"
    export SSL_PORT="8443"

    # Create SSL enabled marker
    touch .ssl_enabled

    print_status "SSL enabled in development mode!"
    print_warning "Browsers will show security warnings for self-signed certificates."
    print_status "HTTPS port: 8443 (port 443 is in use by Traefik)"
    print_status "Access via: https://localhost:8443"
    print_status "Restart containers to apply changes."
    print_status "Run: docker-compose -f docker-compose.yml -f docker-compose.ssl.yml up -d"
}

# Function to enable SSL in production mode (Let's Encrypt)
enable_ssl_prod() {
    print_header "Enable SSL (Production Mode)"

    print_status "This requires a public domain name and valid DNS configuration."
    echo ""
    read -p "Enter your domain name (e.g., emr.example.com): " domain
    read -p "Enter your email for Let's Encrypt notifications: " email

    if [ -z "$domain" ] || [ -z "$email" ]; then
        print_error "Domain and email are required for Let's Encrypt."
        return 1
    fi

    # Check if port 443 is available
    if sudo lsof -i :443 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port 443 is already in use (by Traefik or another service)."
        read -p "Use alternative port 8443 instead? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            export SSL_PORT="8443"
            print_status "Will use port 8443 for HTTPS."
        else
            print_error "Port 443 must be available for standard HTTPS. Please stop the conflicting service."
            return 1
        fi
    else
        export SSL_PORT="443"
    fi

    # Set environment variables for prod mode
    export SSL_MODE="prod"
    export CERT_WEB_DOMAINS="$domain"
    export CERT_CONTACT_EMAIL="$email"
    export SSL_STAGING="false"

    # Create markers
    touch .ssl_enabled
    touch .ssl_prod

    print_status "SSL enabled in production mode!"
    print_status "Domain: $domain"
    print_status "Email: $email"
    print_status "HTTPS port: $SSL_PORT"
    if [ "$SSL_PORT" = "8443" ]; then
        print_status "Access via: https://$domain:8443"
    else
        print_status "Access via: https://$domain"
    fi
    print_warning "Ensure your domain DNS points to this server before starting containers."
    print_status "Restart containers to apply changes."
    print_status "Run: docker-compose -f docker-compose.yml -f docker-compose.ssl.yml up -d"
}

# Function to set production mode
set_production_mode() {
    print_header "Production Mode Configuration"

    if [ -f ".production" ]; then
        print_status "Production mode is currently ENABLED"
        echo ""
        echo "Current production settings:"
        echo "  - SSL: $([ -f .ssl_enabled ] && echo 'Enabled' || echo 'Disabled')"
        echo "  - Environment: Production"
        echo ""
        read -p "Do you want to DISABLE production mode? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Disabling production mode..."
            rm -f .production
            print_status "Production mode disabled."
        else
            print_status "Production mode remains enabled."
        fi
    else
        print_status "Production mode is currently DISABLED"
        echo ""
        print_warning "Production mode enables:"
        echo "  - SSL/TLS encryption (recommended)"
        echo "  - Security headers"
        echo "  - Stronger cipher suites"
        echo "  - HSTS (HTTP Strict Transport Security)"
        echo ""
        read -p "Do you want to ENABLE production mode? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Enabling production mode..."
            touch .production

            # Prompt for SSL
            if [ ! -f ".ssl_enabled" ]; then
                print_warning "SSL is not enabled. SSL is highly recommended for production."
                read -p "Do you want to enable SSL now? (y/N): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    toggle_ssl
                fi
            fi

            print_status "Production mode enabled!"
            print_status "Restart containers to apply changes."
        else
            print_status "Production mode remains disabled."
        fi
    fi
}

# Function to compare every local O3 form JSON against what is actually
# deployed in the backend DB. Reports whether each form is missing, stale
# (different version or schema), or in sync.
check_form_versions() {
    print_header "Form Version Checker"

    FORMS_DIR="distro/configuration/forms"
    if [ ! -d "$FORMS_DIR" ]; then
        print_error "Forms directory not found: $FORMS_DIR"
        return 1
    fi

    if ! $DOCKER_COMPOSE_CMD ps backend | grep -q "Up"; then
        print_error "Backend container is not running. Start the stack first."
        return 1
    fi

    if ! command -v python3 >/dev/null 2>&1; then
        print_error "python3 is required on the host."
        return 1
    fi

    OMRS_ADMIN_USER="${OMRS_ADMIN_USER:-admin}"
    OMRS_ADMIN_PASSWORD="${OMRS_ADMIN_PASSWORD:-Admin123}"
    BASE_URL="${OMRS_BASE_URL:-http://localhost/openmrs}"

    print_status "Comparing local files in $FORMS_DIR against $BASE_URL ..."
    echo ""

    OMRS_ADMIN_USER="$OMRS_ADMIN_USER" \
    OMRS_ADMIN_PASSWORD="$OMRS_ADMIN_PASSWORD" \
    BASE_URL="$BASE_URL" \
    FORMS_DIR="$FORMS_DIR" \
    python3 - <<'PY'
import os, sys, json, glob, hashlib, base64
from urllib import request, error

base = os.environ["BASE_URL"].rstrip("/")
user = os.environ["OMRS_ADMIN_USER"]
pwd  = os.environ["OMRS_ADMIN_PASSWORD"]
forms_dir = os.environ["FORMS_DIR"]

GREEN = "\033[0;32m"; RED = "\033[0;31m"; YELLOW = "\033[1;33m"; RESET = "\033[0m"

def http_get(path):
    url = f"{base}{path}"
    req = request.Request(url)
    creds = base64.b64encode(f"{user}:{pwd}".encode()).decode()
    req.add_header("Authorization", f"Basic {creds}")
    req.add_header("Accept", "application/json")
    try:
        with request.urlopen(req, timeout=10) as r:
            return r.status, r.read().decode("utf-8", errors="replace")
    except error.HTTPError as e:
        return e.code, e.read().decode("utf-8", errors="replace")
    except Exception as e:
        return 0, str(e)

def canonical_hash(obj):
    return hashlib.sha256(
        json.dumps(obj, sort_keys=True, separators=(",", ":")).encode()
    ).hexdigest()[:12]

files = sorted(glob.glob(os.path.join(forms_dir, "*.json")))
if not files:
    print(f"{YELLOW}No form files found in {forms_dir}{RESET}")
    sys.exit(0)

summary = []
for path in files:
    name = os.path.basename(path)
    try:
        local = json.load(open(path))
    except Exception as e:
        print(f"{RED}PARSE ERROR{RESET}  {name}: {e}")
        summary.append((name, "PARSE_ERROR"))
        continue

    l_uuid    = local.get("uuid")
    # OpenMRS normalises whitespace on Form.name, so compare trimmed values
    l_name    = (local.get("name") or "").strip()
    l_version = str(local.get("version", ""))
    l_pub     = bool(local.get("published"))
    l_hash    = canonical_hash(local)

    print(f"--- {name} ---")
    print(f"  local : uuid={l_uuid} name={l_name!r} version={l_version} published={l_pub}")

    if not l_uuid:
        print(f"  {RED}MISSING uuid in local file{RESET}")
        summary.append((name, "NO_LOCAL_UUID"))
        print()
        continue

    code, body = http_get(f"/ws/rest/v1/form/{l_uuid}?v=full")
    if code == 404:
        print(f"  {RED}NOT DEPLOYED{RESET} (HTTP 404). Backend has no form with uuid {l_uuid}.")
        summary.append((name, "NOT_DEPLOYED"))
        print()
        continue
    if code != 200:
        print(f"  {RED}LOOKUP FAILED{RESET} HTTP {code}: {body[:200]}")
        summary.append((name, f"HTTP_{code}"))
        print()
        continue

    try:
        form = json.loads(body)
    except Exception:
        print(f"  {RED}Invalid JSON from backend{RESET}")
        summary.append((name, "BAD_BACKEND_RESPONSE"))
        print()
        continue

    s_name    = (form.get("name") or "").strip()
    s_version = str(form.get("version", ""))
    s_pub     = bool(form.get("published"))
    s_retired = bool(form.get("retired"))

    # Try to fetch the schema clob via the o3forms module to do a content diff.
    # If the endpoint isn't available in this distro, schema check is skipped
    # (not treated as a diff) -- only a metadata comparison is performed.
    s_hash = None
    schema_status = "skipped (endpoint unavailable)"
    code2, body2 = http_get(f"/ws/rest/v1/o3forms/{l_uuid}")
    if code2 == 200:
        try:
            s_hash = canonical_hash(json.loads(body2))
            schema_status = f"sha={s_hash}"
        except Exception:
            schema_status = "unparseable schema response"

    server_line = f"  server: uuid={l_uuid} name={s_name!r} version={s_version} published={s_pub} retired={s_retired}"
    if s_hash is not None:
        server_line += f" sha={s_hash}"
    print(server_line)
    print(f"  schema: local sha={l_hash}  server schema: {schema_status}")

    if s_retired:
        print(f"  {YELLOW}WARNING server form is retired{RESET}")

    flags = []
    if l_name != s_name:       flags.append(f"name differs ({l_name!r} vs {s_name!r})")
    if l_version != s_version: flags.append(f"version differs ({l_version} vs {s_version})")
    if l_pub != s_pub:         flags.append(f"published differs ({l_pub} vs {s_pub})")
    schema_diff = (s_hash is not None and s_hash != l_hash)
    if schema_diff:            flags.append("schema content differs")

    if not flags:
        print(f"  {GREEN}IN SYNC{RESET} (local file matches deployed form)")
        summary.append((name, "IN_SYNC"))
    else:
        print(f"  {YELLOW}STALE / OUT OF SYNC{RESET}: " + "; ".join(flags))
        if schema_diff:
            print(f"  -> bump 'version' in {name} and rebuild the backend image, OR")
            print(f"     edit the form via /openmrs/spa/form-builder and re-export.")
        summary.append((name, "STALE"))
    print()

# overall
counts = {}
for _, s in summary:
    counts[s] = counts.get(s, 0) + 1
print("Summary:")
for s, c in sorted(counts.items()):
    color = GREEN if s == "IN_SYNC" else (RED if s in ("NOT_DEPLOYED","NO_LOCAL_UUID","PARSE_ERROR","BAD_BACKEND_RESPONSE") else YELLOW)
    print(f"  {color}{s}{RESET}: {c}")

PY
}

# Function to manage an individual service (start / stop / restart / rebuild)
manage_service() {
    print_header "Manage Individual Container"
    echo "Select a service:"
    echo "1) gateway"
    echo "2) frontend"
    echo "3) backend"
    echo "4) db"
    echo "5) Return to main menu"
    read -p "Enter your choice (1-5): " svc_choice

    case $svc_choice in
        1) SERVICE="gateway" ;;
        2) SERVICE="frontend" ;;
        3) SERVICE="backend" ;;
        4) SERVICE="db" ;;
        5) return ;;
        *)
            print_error "Invalid choice. Returning to main menu."
            return
            ;;
    esac

    echo ""
    echo "Select an action for '$SERVICE':"
    echo "1) Start"
    echo "2) Stop"
    echo "3) Restart"
    echo "4) Rebuild (no-cache) and recreate"
    echo "5) Return to main menu"
    read -p "Enter your choice (1-5): " act_choice

    case $act_choice in
        1)
            print_status "Starting $SERVICE..."
            $DOCKER_COMPOSE_CMD up -d "$SERVICE"
            ;;
        2)
            print_status "Stopping $SERVICE..."
            $DOCKER_COMPOSE_CMD stop "$SERVICE"
            ;;
        3)
            print_status "Restarting $SERVICE..."
            $DOCKER_COMPOSE_CMD restart "$SERVICE"
            ;;
        4)
            # 'db' has no build context, warn early
            if [ "$SERVICE" = "db" ]; then
                print_warning "'db' uses an upstream image and has no build context; nothing to rebuild."
                return
            fi
            print_warning "Rebuilding '$SERVICE' from scratch (no cache)..."
            read -p "Are you sure? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                print_status "Building $SERVICE..."
                $DOCKER_COMPOSE_CMD build --no-cache "$SERVICE"
                print_status "Recreating $SERVICE..."
                $DOCKER_COMPOSE_CMD up -d --force-recreate --no-deps "$SERVICE"
                print_status "$SERVICE rebuilt and started."
            else
                print_status "Rebuild cancelled."
            fi
            ;;
        5)
            return
            ;;
        *)
            print_error "Invalid choice. Returning to main menu."
            return
            ;;
    esac

    echo ""
    show_status
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
    echo "Mode: $([ -f .production ] && echo 'PRODUCTION' || echo 'DEVELOPMENT')"
    echo "SSL: $([ -f .ssl_enabled ] && echo 'ENABLED' || echo 'DISABLED')"
    echo ""
    echo "Please select an action:"
    echo "1) Build and start all containers"
    echo "2) Rebuild all containers (from scratch)"
    echo "3) Stop and delete containers"
    echo "4) Prune Docker system (clean up unused resources)"
    echo "5) Clean up dangling images and containers"
    echo "6) Update frontend without rebuild (copy static assets)"
    echo "7) Verify config and logo in container"
    echo "8) Show container logs"
    echo "9) Access container shell"
    echo "10) Show container status"
    echo "11) Fastfetch (quick system overview)"
    echo "12) Manage individual container (start / stop / restart / rebuild)"
    echo "13) Probe form concepts against backend (diagnose save NPEs)"
    echo "14) Check form versions (local file vs deployed form)"
    echo "15) Toggle SSL configuration (HTTP/HTTPS)"
    echo "16) Set production mode"
    echo "17) Exit"
    echo ""
}

# Main program loop
main() {
    check_docker
    # Set global variable for Docker Compose command
    DOCKER_COMPOSE_CMD=$(detect_docker_compose)
    
    while true; do
        show_menu
        read -p "Enter your choice (1-17): " choice
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
                verify_config
                ;;
            8)
                show_logs
                ;;
            9)
                access_shell
                ;;
            10)
                show_status
                ;;
            11)
                fastfetch
                ;;
            12)
                manage_service
                ;;
            13)
                probe_form_concepts
                ;;
            14)
                check_form_versions
                ;;
            15)
                toggle_ssl
                ;;
            16)
                set_production_mode
                ;;
            17)
                print_status "Goodbye!"
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please select a number between 1 and 17."
                ;;
        esac

        echo ""
        read -p "Press Enter to continue..."
    done
}

# Run main function
main "$@"
