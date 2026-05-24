#!/bin/bash

# SSL Certificate Generation Script for OpenMRS EMR4ALL
# This script generates self-signed SSL certificates for development/testing
# For production, use Let's Encrypt or purchase from a trusted CA

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Default values
DOMAIN="${1:-localhost}"
COUNTRY="${SSL_COUNTRY:-US}"
STATE="${SSL_STATE:-California}"
CITY="${SSL_CITY:-San Francisco}"
ORG="${SSL_ORG:-OpenMRS}"
ORG_UNIT="${SSL_ORG_UNIT:-IT}"
DAYS="${SSL_DAYS:-365}"

print_header "SSL Certificate Generation"

print_status "Generating self-signed certificate for: $DOMAIN"
print_warning "This is for DEVELOPMENT/TESTING only!"
print_warning "For production, use Let's Encrypt or a trusted CA"
echo ""

# Check if openssl is installed
if ! command -v openssl &> /dev/null; then
    print_error "openssl is not installed. Please install it first."
    exit 1
fi

# Generate private key
print_status "Generating private key..."
openssl genrsa -out key.pem 2048

# Generate certificate signing request
print_status "Generating certificate signing request..."
openssl req -new -key key.pem -out csr.pem \
    -subj "/C=$COUNTRY/ST=$STATE/L=$CITY/O=$ORG/OU=$ORG_UNIT/CN=$DOMAIN"

# Generate self-signed certificate
print_status "Generating self-signed certificate (valid for $DAYS days)..."
openssl x509 -req -days $DAYS -in csr.pem -signkey key.pem -out cert.pem

# Clean up CSR
rm csr.pem

print_status "Certificate generated successfully!"
echo ""
print_status "Files created:"
echo "  - key.pem (private key)"
echo "  - cert.pem (certificate)"
echo ""
print_warning "IMPORTANT: Keep key.pem secure and never share it!"
print_warning "Browser will show security warning for self-signed certificates."
print_status "To use these certificates, restart the containers with SSL enabled."
