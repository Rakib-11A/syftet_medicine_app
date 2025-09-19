#!/bin/bash

# Production Deployment Script
set -e

echo "🚀 Starting production deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if .env.production.local exists
if [ ! -f .env.production.local ]; then
    echo -e "${RED}❌ .env.production.local not found!${NC}"
    echo "Please copy .env.production to .env.production.local and configure it."
    exit 1
fi

# Load environment variables
export $(cat .env.production.local | grep -v '^#' | xargs)

echo -e "${YELLOW}📦 Building production images...${NC}"
docker compose -f docker-compose.prod.yml build --no-cache

echo -e "${YELLOW}🛑 Stopping existing services...${NC}"
docker compose -f docker-compose.prod.yml down

echo -e "${YELLOW}🚀 Starting production services...${NC}"
docker compose -f docker-compose.prod.yml up -d

echo -e "${YELLOW}⏳ Waiting for services to be ready...${NC}"
sleep 30

echo -e "${YELLOW}🗄️ Running database migrations...${NC}"
docker compose -f docker-compose.prod.yml exec web bundle exec rails db:migrate

echo -e "${YELLOW}🌱 Seeding database (if needed)...${NC}"
docker compose -f docker-compose.prod.yml exec web bundle exec rails db:seed

echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
echo -e "${GREEN}🌐 Application is available at: https://$HOST${NC}"
echo -e "${GREEN}📊 Monitoring: http://$HOST:3001 (Grafana)${NC}"
echo -e "${GREEN}📈 Metrics: http://$HOST:9090 (Prometheus)${NC}"

# Show running services
echo -e "${YELLOW}📋 Running services:${NC}"
docker compose -f docker-compose.prod.yml ps
