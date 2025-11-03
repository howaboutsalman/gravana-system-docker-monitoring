# Docker Monitoring Stack with Grafana

Complete monitoring solution for Linux systems and Docker containers using Grafana, Prometheus, Node Exporter, and cAdvisor.

## 📊 Components

- **Grafana** (Port 3100) - Visualization and dashboards
- **Prometheus** (Port 9091) - Metrics collection and storage
- **Node Exporter** (Port 9101) - Linux system metrics (CPU, memory, disk, network)
- **cAdvisor** (Port 8081) - Docker container metrics

## 🚀 Quick Start

### Option A: With Traefik (Secure HTTPS) ⭐ Recommended

#### 1. Configure your domain

Copy the example environment file and set your domain:

```bash
cd /root/monitoring
cp .env.example .env
nano .env
```

Set your domain in `.env`:
```bash
GRAFANA_DOMAIN=grafana.yourdomain.com
```

#### 2. Ensure Traefik network exists

```bash
docker network create traefik-public
```

#### 3. Start the monitoring stack

```bash
docker compose up -d
```

#### 4. Access Grafana securely

Open your browser and navigate to: `https://grafana.yourdomain.com`

✅ **Automatic HTTPS with Let's Encrypt certificate!**

**Default credentials:**
- Username: `admin`
- Password: `admin`

⚠️ **Important:** Change the default password on first login!

---

### Option B: Standalone (Local Access Only)

If you want to run without Traefik:

1. Remove the `traefik-public` network from Grafana service in `docker-compose.yml`
2. Change `expose` to `ports: - "3100:3000"`
3. Remove all Traefik labels
4. Access at: `http://localhost:3100`

## 📈 Recommended Dashboards

Import these pre-built dashboards from the Grafana dashboard library:

### How to Import Dashboards:

1. **Log into Grafana** (https://grafana.allcloud24.com)
2. Click **"+"** in the left sidebar → **"Import dashboard"**
3. Enter one of the dashboard IDs below
4. Click **"Load"**
5. Select **"Prometheus"** as the data source
6. **Important:** Configure the variables:
   - Set `job` = `node-exporter` (for Node Exporter dashboards)
   - Set `instance` = `docker-host`
7. Click **"Import"**

### Recommended Dashboard IDs:

#### For Linux System Monitoring:
- **Node Exporter Full** - ID: `1860`
  - Complete system monitoring (CPU, memory, disk, network)
  - Most comprehensive option
  - After import, set variables: job=`node-exporter`, instance=`docker-host`

- **Node Exporter Server Metrics** - ID: `405`
  - Simpler server overview
  - Good for quick health checks

#### For Docker Container Monitoring:
- **Docker Container & Host Metrics** - ID: `179`
  - Container resource usage
  - After import, may need to adjust instance labels

- **cAdvisor Exporter** - ID: `14282`
  - Detailed container metrics
  - Advanced monitoring

### 💡 Pro Tips:

- **Start with Dashboard 1860** - It's the most reliable and comprehensive
- **Configure variables** at the top of each dashboard after import
- **Use Explore mode** (compass icon) to test queries first
- **Save dashboards** after configuring variables

### Quick Test Query:

Before importing dashboards, test your setup in **Explore** (compass icon):

```promql
100 - (avg(rate(node_cpu_seconds_total{mode="idle",instance="docker-host"}[5m])) * 100)
```

This should show your CPU usage. If it works, the dashboards will work too!

## 🔍 Access Individual Services

### With Traefik:
- **Grafana UI:** https://grafana.yourdomain.com (HTTPS with Let's Encrypt)

### Direct Access (Internal):
- **Grafana UI:** http://localhost:3100 (if ports exposed)
- **Prometheus UI:** http://localhost:9091
- **Node Exporter Metrics:** http://localhost:9101/metrics
- **cAdvisor UI:** http://localhost:8081

💡 **Note:** When using Traefik, Grafana is only accessible via the configured domain with HTTPS.

## 📊 What's Being Monitored

### Linux System Metrics (Node Exporter)
- CPU usage and load average
- Memory and swap usage
- Disk I/O and space
- Network traffic
- System uptime
- File system statistics

### Docker Container Metrics (cAdvisor)
- Container CPU usage
- Container memory usage
- Container network I/O
- Container disk I/O
- Container filesystem usage
- Per-container resource limits

## 🛠️ Management Commands

### Start the stack
```bash
docker-compose up -d
```

### Stop the stack
```bash
docker-compose down
```

### View logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f grafana
docker-compose logs -f prometheus
```

### Restart services
```bash
docker-compose restart
```

### Update images
```bash
docker-compose pull
docker-compose up -d
```

## 🔧 Configuration

### Prometheus Configuration
Edit `prometheus/prometheus.yml` to:
- Add more scrape targets
- Adjust scrape intervals
- Configure alerting rules

After changes, reload Prometheus:
```bash
docker-compose restart prometheus
```

### Grafana Configuration
- Data sources: `grafana/provisioning/datasources/datasource.yml`
- Dashboards: `grafana/provisioning/dashboards/dashboard.yml`

### Data Retention
Prometheus retains data for 30 days by default. To change this, edit the `--storage.tsdb.retention.time` parameter in `docker-compose.yml`.

## 📦 Data Persistence

All data is persisted in Docker volumes:
- `grafana-data` - Grafana dashboards and settings
- `prometheus-data` - Prometheus time-series data

To backup data:
```bash
docker run --rm -v monitoring_grafana-data:/data -v $(pwd):/backup alpine tar czf /backup/grafana-backup.tar.gz -C /data .
docker run --rm -v monitoring_prometheus-data:/data -v $(pwd):/backup alpine tar czf /backup/prometheus-backup.tar.gz -C /data .
```

## 🔒 Traefik Integration

This stack is pre-configured to work with Traefik reverse proxy for secure HTTPS access.

### Requirements:
- Traefik must be running with Let's Encrypt configured
- `traefik-public` Docker network must exist
- DNS A record pointing your domain to your server

### Features:
✅ Automatic HTTPS with Let's Encrypt certificates  
✅ HTTP to HTTPS redirect  
✅ Secure domain-based access  
✅ No exposed ports (except Traefik 80/443)

### Configuration:

1. **Set your domain** in `.env`:
   ```bash
   GRAFANA_DOMAIN=grafana.yourdomain.com
   ```

2. **Ensure Traefik network exists**:
   ```bash
   docker network create traefik-public
   ```

3. **Point your DNS** to your server's IP address

4. **Start the stack**:
   ```bash
   docker compose up -d
   ```

Traefik will automatically:
- Detect the Grafana container
- Request a Let's Encrypt certificate
- Route HTTPS traffic to Grafana
- Redirect HTTP to HTTPS

## 🔐 Security Recommendations

1. **Change default Grafana password** immediately after first login
2. **Use Traefik for HTTPS** - Automatic Let's Encrypt certificates (already configured!)
3. **Configure authentication** - Set up OAuth or LDAP for Grafana
4. **Network isolation** - The monitoring network is isolated by default
5. **Firewall rules** - Only expose Traefik ports (80/443) to the internet

## 🐛 Troubleshooting

### Services won't start
```bash
# Check logs
docker-compose logs

# Check if ports are already in use
netstat -tulpn | grep -E '3000|9090|9100|8080'
```

### No metrics showing in Grafana
1. Check Prometheus targets: http://localhost:9090/targets
2. All targets should show "UP" status
3. If down, check service logs: `docker-compose logs [service-name]`

### Permission issues with cAdvisor
cAdvisor requires privileged mode to access Docker metrics. This is already configured in the docker-compose.yml.

## 📚 Additional Resources

- [Grafana Documentation](https://grafana.com/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Node Exporter](https://github.com/prometheus/node_exporter)
- [cAdvisor](https://github.com/google/cadvisor)
- [Grafana Dashboard Library](https://grafana.com/grafana/dashboards/)

## 🎯 Next Steps

1. Import recommended dashboards
2. Set up alerting rules in Prometheus
3. Configure Grafana alert notifications (email, Slack, etc.)
4. Create custom dashboards for your specific needs
5. Set up long-term storage with remote write (optional)

## 📝 Notes

- Default scrape interval: 15 seconds
- Data retention: 30 days
- All services restart automatically unless stopped manually
- The stack uses minimal resources and is suitable for production use
