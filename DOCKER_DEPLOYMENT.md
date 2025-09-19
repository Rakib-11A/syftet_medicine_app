# Docker Deployment Guide for Syftet Medicine App

This guide will help you deploy the Rails application using Docker and Docker Compose.

## Prerequisites

- Docker (version 20.10 or higher)
- Docker Compose (version 2.0 or higher)
- Git

## Quick Start

### 1. Clone and Setup

```bash
git clone <your-repo-url>
cd syftet_medicine_app
```

### 2. Environment Configuration

```bash
# Copy the example environment file
cp .env.example .env

# Edit the environment file with your settings
nano .env
```

Update the following variables in `.env`:
- `ARMOIAR_DATABASE_PASSWORD`: Set a secure password for your database
- `SECRET_KEY_BASE`: Generate a new secret key base for Rails

### 3. Generate Secret Key Base

```bash
# Generate a new secret key base
docker run --rm ruby:3.3.5-slim ruby -e "require 'securerandom'; puts SecureRandom.hex(64)"
```

Add the generated key to your `.env` file.

### 4. Build and Deploy

```bash
# Build the Docker image
docker-compose build

# Start all services
docker-compose up -d

# Check the status
docker-compose ps
```

### 5. Database Setup

```bash
# Run database migrations
docker-compose exec web bundle exec rails db:migrate

# Seed the database (optional)
docker-compose exec web bundle exec rails db:seed
```

## Services

The Docker Compose setup includes:

- **web**: Rails application server
- **db**: PostgreSQL database
- **nginx**: Reverse proxy and static file server

## Accessing the Application

- **Application**: http://localhost
- **Database**: localhost:5432
  - Database: `armoiar_production`
  - Username: `armoiar`
  - Password: (from your `.env` file)

## Useful Commands

### View Logs
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs web
docker-compose logs db
```

### Stop Services
```bash
docker-compose down
```

### Rebuild and Restart
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Database Operations
```bash
# Access Rails console
docker-compose exec web bundle exec rails console

# Run database migrations
docker-compose exec web bundle exec rails db:migrate

# Reset database (WARNING: This will delete all data)
docker-compose exec web bundle exec rails db:reset
```

### Backup Database
```bash
# Create backup
docker-compose exec db pg_dump -U armoiar armoiar_production > backup.sql

# Restore backup
docker-compose exec -T db psql -U armoiar armoiar_production < backup.sql
```

## Production Considerations

### 1. Security
- Change default passwords
- Use environment variables for sensitive data
- Consider using Docker secrets for production
- Enable SSL/TLS certificates

### 2. Performance
- Configure proper resource limits
- Use a production-ready database
- Consider using Redis for caching
- Optimize Docker images

### 3. Monitoring
- Set up log aggregation
- Monitor container health
- Configure alerts

### 4. Backup Strategy
- Regular database backups
- Volume backups
- Application code backups

## Troubleshooting

### Common Issues

1. **Port already in use**
   ```bash
   # Check what's using the port
   sudo netstat -tulpn | grep :3000
   # Or change the port in docker-compose.yml
   ```

2. **Database connection issues**
   ```bash
   # Check database logs
   docker-compose logs db
   
   # Test database connection
   docker-compose exec web bundle exec rails runner "puts ActiveRecord::Base.connection.execute('SELECT 1').first"
   ```

3. **Asset compilation issues**
   ```bash
   # Rebuild without cache
   docker-compose build --no-cache web
   ```

4. **Permission issues**
   ```bash
   # Fix storage permissions
   docker-compose exec web chown -R app:app /app/storage
   ```

### Health Checks

```bash
# Check if all services are running
docker-compose ps

# Check service health
docker-compose exec web curl -f http://localhost:3000/ || echo "Web service is down"
docker-compose exec db pg_isready -U armoiar
```

## Scaling

To scale the web service:

```bash
# Scale web service to 3 instances
docker-compose up -d --scale web=3
```

Note: You'll need to configure a load balancer (like nginx) to distribute traffic across multiple web instances.

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `ARMOIAR_DATABASE_PASSWORD` | Database password | `secure_password` |
| `RAILS_ENV` | Rails environment | `production` |
| `SECRET_KEY_BASE` | Rails secret key | Required |

## Support

For issues related to:
- Docker: Check Docker documentation
- Rails: Check Rails guides
- Application: Check application logs and documentation
