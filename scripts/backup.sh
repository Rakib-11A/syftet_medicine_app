#!/bin/bash

# Database Backup Script
set -e

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="armoiar_backup_${DATE}.sql"

echo "🗄️ Creating database backup..."

# Create backup
docker compose -f docker-compose.prod.yml exec -T db pg_dump -U armoiar armoiar_production > "${BACKUP_DIR}/${BACKUP_FILE}"

# Compress backup
gzip "${BACKUP_DIR}/${BACKUP_FILE}"

echo "✅ Backup created: ${BACKUP_FILE}.gz"

# Clean old backups (keep last 30 days)
find ${BACKUP_DIR} -name "armoiar_backup_*.sql.gz" -mtime +30 -delete

echo "🧹 Old backups cleaned"
