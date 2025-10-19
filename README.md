# Docker Monitoring Stack with Grafana

Complete monitoring solution for Linux systems and Docker containers using Grafana, Prometheus, Node Exporter, and cAdvisor.

## 📊 Components

- **Grafana** (Port 3100) - Visualization and dashboards
- **Prometheus** (Port 9091) - Metrics collection and storage
- **Node Exporter** (Port 9101) - Linux system metrics (CPU, memory, disk, network)
- **cAdvisor** (Port 8081) - Docker container metrics

## 🚀 Quick Start

### 1. Start the monitoring stack

```bash
cd /root/monitoring
docker-compose up -d
```

### 2. Verify all services are running

```bash
docker-compose ps
```

### 3. Access Grafana

Open your browser and navigate to: `http://localhost:3100`

**Default credentials:**
- Username: `admin`
- Password: `admin`

⚠️ **Important:** Change the default password on first login!

## 📈 Pre-installed Dashboards

The following dashboards are **automatically installed** when you start the stack:

### Available in the "Monitoring" Folder:

- **Node Exporter Full** (ID: 1860)
  - Complete Linux system monitoring (CPU, memory, disk, network)
  - Comprehensive system metrics and performance graphs
  
- **Docker Container & Host Metrics** (ID: 179)
  - Docker container resource usage
  - Container CPU, memory, and network statistics
  
- **cAdvisor Exporter** (ID: 14282)
  - Detailed container metrics
  - Advanced container monitoring and analysis
  
- **Node Exporter Server Metrics** (ID: 405)
  - Server overview dashboard
  - Quick system health overview

### How to Access:

1. Log into Grafana (http://localhost:3100)
2. Navigate to **Dashboards** → **Browse**
3. Open the **"Monitoring"** folder
4. Select any dashboard to view your metrics

✨ **No manual import needed!** All dashboards are ready to use immediately.

## 🔍 Access Individual Services

- **Grafana UI:** http://localhost:3100
- **Prometheus UI:** http://localhost:9091
- **Node Exporter Metrics:** http://localhost:9101/metrics
- **cAdvisor UI:** http://localhost:8081

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

## 🔐 Security Recommendations

1. **Change default Grafana password** immediately after first login
2. **Restrict port access** - Consider using a reverse proxy (like Traefik or Nginx)
3. **Enable HTTPS** for production environments
4. **Configure authentication** - Set up OAuth or LDAP for Grafana
5. **Network isolation** - The monitoring network is isolated by default

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
