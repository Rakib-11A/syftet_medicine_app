#!/bin/bash

# Database Restore Script
set -e

if [ -z "$1" ]; then
    echo "❌ Usage: $0 <backup_file.sql.gz>"
    echo "Available backups:"
    ls -la ./backups/armoiar_backup_*.sql.gz 2>/dev/null || echo "No backups found"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "🔄 Restoring database from: $BACKUP_FILE"

# Stop web service to prevent connections
echo "🛑 Stopping web service..."
docker compose -f docker-compose.prod.yml stop web

# Restore database
echo "📥 Restoring database..."
if [[ "$BACKUP_FILE" == *.gz ]]; then
    gunzip -c "$BACKUP_FILE" | docker compose -f docker-compose.prod.yml exec -T db psql -U armoiar -d armoiar_production
else
    docker compose -f docker-compose.prod.yml exec -T db psql -U armoiar -d armoiar_production < "$BACKUP_FILE"
fi

# Start web service
echo "🚀 Starting web service..."
docker compose -f docker-compose.prod.yml start web

echo "✅ Database restored successfully!"
