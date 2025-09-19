# 🚀 Production Deployment Guide

This guide will help you deploy your Rails application to production using Docker.

## 📋 Prerequisites

### Server Requirements
- **OS**: Ubuntu 20.04+ or CentOS 8+
- **RAM**: Minimum 4GB (8GB+ recommended)
- **CPU**: 2+ cores
- **Storage**: 50GB+ SSD
- **Network**: Static IP address

### Software Requirements
- Docker 20.10+
- Docker Compose 2.0+
- Git
- Domain name with DNS configured

## 🔧 Initial Server Setup

### 1. Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Install Docker
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 3. Configure Firewall
```bash
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw allow 3001  # Grafana (optional)
sudo ufw enable
```

## 🚀 Deployment Steps

### 1. Clone Repository
```bash
git clone <your-repo-url>
cd syftet_medicine_app
```

### 2. Configure Environment
```bash
# Copy production environment template
cp .env.production .env.production.local

# Edit with your values
nano .env.production.local
```

**Required Environment Variables:**
```bash
# Database
PRODUCTION_DATABASE_PASSWORD=your_secure_password_here
SECRET_KEY_BASE=your_secret_key_here

# Domain
HOST=yourdomain.com

# SSL (if using Let's Encrypt)
SSL_CERT_PATH=/etc/nginx/ssl/cert.pem
SSL_KEY_PATH=/etc/nginx/ssl/key.pem
```

### 3. Generate Secret Key
```bash
# Generate Rails secret key
ruby -e "require 'securerandom'; puts SecureRandom.hex(64)"
```

### 4. SSL Certificate Setup

#### Option A: Let's Encrypt (Recommended)
```bash
# Install Certbot
sudo apt install certbot

# Get certificate
sudo certbot certonly --standalone -d yourdomain.com -d www.yourdomain.com

# Copy certificates
sudo cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem ssl/cert.pem
sudo cp /etc/letsencrypt/live/yourdomain.com/privkey.pem ssl/key.pem
sudo chown $USER:$USER ssl/*.pem
```

#### Option B: Self-Signed (Development Only)
```bash
# Generate self-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ssl/key.pem \
  -out ssl/cert.pem \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=yourdomain.com"
```

### 5. Deploy Application
```bash
# Run deployment script
./deploy.sh
```

## 📊 Monitoring & Management

### Access Points
- **Application**: https://yourdomain.com
- **Grafana Dashboard**: http://yourdomain.com:3001
- **Prometheus Metrics**: http://yourdomain.com:9090

### Useful Commands

#### Service Management
```bash
# View all services
docker compose -f docker-compose.prod.yml ps

# View logs
docker compose -f docker-compose.prod.yml logs -f web
docker compose -f docker-compose.prod.yml logs -f db

# Restart services
docker compose -f docker-compose.prod.yml restart web
docker compose -f docker-compose.prod.yml restart nginx

# Stop all services
docker compose -f docker-compose.prod.yml down
```

#### Database Operations
```bash
# Access Rails console
docker compose -f docker-compose.prod.yml exec web bundle exec rails console

# Run migrations
docker compose -f docker-compose.prod.yml exec web bundle exec rails db:migrate

# Create backup
./scripts/backup.sh

# Restore backup
./scripts/restore.sh backups/armoiar_backup_20241218_143022.sql.gz
```

#### Application Updates
```bash
# Pull latest code
git pull origin main

# Rebuild and deploy
./deploy.sh
```

## 🔒 Security Best Practices

### 1. Environment Security
- Never commit `.env.production.local` to version control
- Use strong, unique passwords
- Rotate secrets regularly
- Enable 2FA for server access

### 2. SSL/TLS Configuration
- Use Let's Encrypt for free SSL certificates
- Enable HSTS headers
- Use strong cipher suites
- Regular certificate renewal

### 3. Database Security
- Use strong database passwords
- Enable SSL for database connections
- Regular backups
- Monitor database access

### 4. Application Security
- Keep dependencies updated
- Use environment variables for secrets
- Enable security headers
- Implement rate limiting

## 📈 Performance Optimization

### 1. Database Optimization
```bash
# Monitor database performance
docker compose -f docker-compose.prod.yml exec db psql -U armoiar -d armoiar_production -c "SELECT * FROM pg_stat_activity;"
```

### 2. Application Optimization
- Enable Redis caching
- Optimize database queries
- Use CDN for static assets
- Implement database indexing

### 3. Server Optimization
- Monitor resource usage
- Scale services as needed
- Use SSD storage
- Configure swap if needed

## 🗄️ Backup Strategy

### Automated Backups
```bash
# Add to crontab for daily backups
crontab -e

# Add this line for daily backups at 2 AM
0 2 * * * /path/to/your/app/scripts/backup.sh
```

### Backup Verification
```bash
# Test backup restoration
./scripts/restore.sh backups/armoiar_backup_YYYYMMDD_HHMMSS.sql.gz
```

## 🚨 Troubleshooting

### Common Issues

#### 1. SSL Certificate Issues
```bash
# Check certificate validity
openssl x509 -in ssl/cert.pem -text -noout

# Renew Let's Encrypt certificate
sudo certbot renew
```

#### 2. Database Connection Issues
```bash
# Check database logs
docker compose -f docker-compose.prod.yml logs db

# Test database connection
docker compose -f docker-compose.prod.yml exec web bundle exec rails runner "puts ActiveRecord::Base.connection.execute('SELECT 1').first"
```

#### 3. Application Not Starting
```bash
# Check application logs
docker compose -f docker-compose.prod.yml logs web

# Check environment variables
docker compose -f docker-compose.prod.yml exec web env | grep -E "(DATABASE|RAILS)"
```

#### 4. High Memory Usage
```bash
# Monitor resource usage
docker stats

# Restart services if needed
docker compose -f docker-compose.prod.yml restart
```

### Health Checks
```bash
# Application health
curl -f https://yourdomain.com/health

# Database health
docker compose -f docker-compose.prod.yml exec db pg_isready -U armoiar

# All services status
docker compose -f docker-compose.prod.yml ps
```

## 📞 Support

For issues related to:
- **Docker**: Check Docker documentation
- **Rails**: Check Rails guides
- **Nginx**: Check Nginx documentation
- **Application**: Check application logs and documentation

## 🔄 Maintenance

### Regular Tasks
- [ ] Monitor disk space
- [ ] Check SSL certificate expiration
- [ ] Review application logs
- [ ] Update dependencies
- [ ] Test backups
- [ ] Monitor performance metrics

### Weekly Tasks
- [ ] Review security logs
- [ ] Check resource usage
- [ ] Update system packages
- [ ] Test disaster recovery

### Monthly Tasks
- [ ] Security audit
- [ ] Performance review
- [ ] Backup verification
- [ ] Dependency updates
