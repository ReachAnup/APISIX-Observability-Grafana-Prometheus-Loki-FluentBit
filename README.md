# APISIX Observability Stack
## Complete monitoring solution with Grafana, Prometheus, Loki & Fluent Bit

This repository provides a complete observability stack for Apache APISIX API Gateway, featuring:

- 📊 **Prometheus** - Metrics collection and storage
- 📈 **Grafana** - Unified dashboard for metrics and logs  
- 📝 **Loki** - Log aggregation and storage
- 🔄 **Fluent Bit** - Log processing and forwarding
- 🚀 **APISIX** - High-performance API Gateway
- 🤖 **Mock AI Service** - Sample upstream service for testing

## ⚠️ **IMPORTANT: First Time Setup**

**Before starting services, you must configure API keys:**

### **🔐 Step 1: Create Secrets File**
```bash
# Create secrets.yaml (this file is git-ignored for security)
notepad secrets.yaml
```

Add your Google API key:
```yaml
google:
  api_key: "YOUR_ACTUAL_GOOGLE_API_KEY_HERE"
```

### **🚀 Step 2: Update Configuration**
Run the update script to inject your API key:

**Windows (PowerShell - Recommended):**
```powershell
.\update-api-key.ps1
```

**Windows (Batch):**
```cmd
update-api-key.bat
```

**Manual Method:**
1. Open `apisix_conf\master\apisix.yaml`
2. Find: `X-goog-api-key: "REPLACE_WITH_YOUR_API_KEY"`
3. Replace with your actual API key from `secrets.yaml`

### **🐳 Step 3: Start Services**
```bash
docker-compose -f docker-compose-master.yaml up -d
```

### **🔒 Security Features**
- ✅ API keys stored in `secrets.yaml` (git-ignored)
- ✅ Automated scripts for secure key injection
- ✅ No secrets committed to repository
- ✅ Template files for team collaboration

📖 **For detailed security information, see [API_KEY_MANAGEMENT.md](API_KEY_MANAGEMENT.md)**

## 🏗️ Architecture

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│   Client    │────│    APISIX    │────│ Mock Service│
└─────────────┘    └──────────────┘    └─────────────┘
                           │
                           ▼
                   ┌──────────────┐
                   │  Access Logs │
                   └──────────────┘
                           │
                           ▼
                   ┌──────────────┐    ┌─────────────┐
                   │  Fluent Bit  │────│    Loki     │
                   └──────────────┘    └─────────────┘
                           │                   │
                           ▼                   │
                   ┌──────────────┐            │
                   │ Prometheus   │            │
                   └──────────────┘            │
                           │                   │
                           ▼                   ▼
                   ┌─────────────────────────────┐
                   │        Grafana              │
                   │  (Unified Dashboard)        │
                   └─────────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Git

### 1. Clone the Repository
```bash
git clone <your-repo-url>
cd APISIX-Observability-Grafana-Prometheus-Loki-FluentBit
```

### 2. Start the Complete Stack
```bash
docker-compose -f docker-compose-master.yaml up -d
```

### 3. Access the Services
- **Grafana Dashboard**: http://localhost:3000 (admin/admin)
- **APISIX Gateway**: http://localhost:9080
- **APISIX Dashboard**: http://localhost:9000 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Loki**: http://localhost:3100

### 4. Configure APISIX Route
```bash
curl -X POST http://localhost:9180/apisix/admin/routes/1 \
  -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" \
  -d '{
    "uri": "/hello",
    "upstream": {
      "type": "roundrobin",
      "nodes": {
        "mock-ai-service:5001": 1
      }
    }
  }'
```

### 5. Test the Setup
```bash
# Generate successful requests
curl http://localhost:9080/hello

# Generate error requests  
curl http://localhost:9080/nonexistent
```

## 📊 Dashboard Features

### Metrics Panels (Prometheus)
- **Request Rate**: Real-time requests per second
- **Response Times**: P50, P95, P99 latency percentiles
- **Status Codes**: HTTP status code distribution
- **Upstream Health**: Backend service availability

### Log Panels (Loki)
- **Recent Access Logs**: Real-time log viewer
- **Log-based Request Rate**: Request rate derived from logs
- **Error Count**: 4xx/5xx error detection and counting

## 🔧 Configuration Files

### Key Components
```
├── docker-compose-master.yaml     # Main orchestration file
├── prometheus.yml                 # Prometheus configuration
├── loki-config.yaml              # Loki configuration  
├── fluent-bit/
│   ├── fluent-bit.conf           # Log processing pipeline
│   └── parsers.conf              # Log parsing rules
├── grafana/provisioning/
│   ├── datasources/              # Auto-configured data sources
│   └── dashboards/               # Pre-built dashboards
└── apisix_conf/master/
    ├── config.yaml               # APISIX configuration
    └── apisix.yaml               # Routes and services
```

### LogQL Query Examples
```logql
# All APISIX logs
{job=~".*apisix.*"}

# Error requests only
{job=~".*apisix.*"} |~ "[45][0-9][0-9] "

# Request rate from logs
sum(rate({job=~".*apisix.*"}[1m]))

# Error count in 5 minutes
sum(count_over_time({job=~".*apisix.*"} |~ "[45][0-9][0-9] " [5m]))
```

## 🛠️ Customization

### Adding New Routes
Edit `apisix_conf/master/apisix.yaml` or use the APISIX Dashboard

### Dashboard Modifications
Edit `grafana/provisioning/dashboards/apisix-grafana-dashboard.json`

### Log Processing
Modify `fluent-bit/fluent-bit.conf` for custom log parsing

## 📈 Monitoring Capabilities

- **Real-time Metrics**: Request rates, latencies, error rates
- **Log Analysis**: Full-text search, filtering, and aggregation
- **Alerting**: Set up alerts based on metrics or log patterns
- **Historical Data**: Long-term trend analysis and capacity planning

## 🔍 Troubleshooting

### Common Issues

1. **"No data" in panels**
   - Check if services are running: `docker-compose ps`
   - Verify log generation: `curl http://localhost:9080/hello`

2. **Fluent Bit not forwarding logs**
   - Check logs: `docker logs compose-fluent-bit-1`
   - Verify Loki connectivity: `curl http://localhost:3100/ready`

3. **Dashboard not loading**
   - Restart Grafana: `docker-compose restart grafana`
   - Check provisioning: `docker logs compose-grafana-1`

## 📝 Log Format

APISIX access logs follow this format:
```
IP - - [timestamp] host "method path protocol" status size time "referer" "user-agent" upstream_addr upstream_status upstream_time "upstream_url"
```

Example:
```
172.21.0.1 - - [29/Aug/2025:09:15:49 +0000] localhost:9080 "GET /hello HTTP/1.1" 200 320 0.286 "-" "curl/8.14.1" 172.21.0.8:5001 200 0.159 "http://localhost:9080"
```

## 🎯 Use Cases

- **API Gateway Monitoring**: Monitor all API traffic and performance
- **Microservices Observability**: Track requests across service boundaries  
- **Security Monitoring**: Detect suspicious patterns in access logs
- **Capacity Planning**: Analyze traffic trends and resource usage
- **Incident Response**: Correlate metrics and logs for faster debugging

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the complete stack
5. Submit a pull request

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Apache APISIX Community
- Grafana Labs
- Prometheus Community
- Fluent Bit Team
