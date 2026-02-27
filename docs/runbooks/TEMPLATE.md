# Runbook: [Component or Service Name]

**Status**: [Draft | Active | Deprecated]
**Last Updated**: YYYY-MM-DD
**Owner**: [Name or team]
**Related**: [Links to related runbooks, decision logs, or experiments]

---

## Overview

### Purpose
*What does this component do? Why does it exist?*

### Scope
*What is covered in this runbook? What is NOT covered?*

### Architecture
*Brief description of how this component fits into the broader system.*

```
[Diagram or description of component's role and dependencies]
```

---

## Prerequisites

### Access Requirements
- [ ] Access to system/server
- [ ] Sudo/admin privileges (if needed)
- [ ] API keys or credentials (specify location)
- [ ] VPN or network access (if applicable)

### Knowledge Requirements
- Familiarity with [technology/tool]
- Understanding of [concept]
- Basic [skill] knowledge

### Tools Required
- Tool 1 (version X.Y+)
- Tool 2 (version X.Y+)
- Access to monitoring dashboards

---

## Service Information

### Deployment Details
- **Environment**: [Dev | Staging | Production]
- **Hosts**: [Hostname(s) or IP(s)]
- **Ports**: [Port numbers and purposes]
- **Protocols**: [HTTP, gRPC, TCP, etc.]
- **Dependencies**: [Other services this depends on]
- **Dependents**: [Services that depend on this]

### Configuration
- **Config Location**: `/path/to/config`
- **Secrets Location**: [Where secrets are stored]
- **Logs Location**: `/path/to/logs`
- **Data Location**: `/path/to/data`

### Resource Usage
- **CPU**: Typical usage pattern
- **Memory**: Typical usage pattern
- **Storage**: Typical usage pattern
- **Network**: Typical usage pattern
- **GPU**: If applicable

---

## Standard Operations

### Starting the Service

```bash
# Command to start the service
sudo systemctl start service-name

# Verify it started
sudo systemctl status service-name

# Check logs for errors
journalctl -u service-name -f
```

**Expected Result**: [What indicates successful start]

**Time to Start**: [Typical startup time]

### Stopping the Service

```bash
# Stop gracefully
sudo systemctl stop service-name

# Verify it stopped
sudo systemctl status service-name
```

**Cleanup**: [Any cleanup tasks needed after stopping]

### Restarting the Service

```bash
# Restart the service
sudo systemctl restart service-name

# Verify restart
sudo systemctl status service-name
```

**When to Restart**:
- After configuration changes
- After dependency updates
- As part of troubleshooting
- During maintenance windows

### Checking Status

```bash
# System status
sudo systemctl status service-name

# Process status
ps aux | grep service-name

# Health check endpoint (if applicable)
curl http://localhost:PORT/health
```

**Healthy Indicators**:
- Status: active (running)
- Health endpoint returns 200 OK
- Recent log entries show normal operation

---

## Monitoring & Alerting

### Key Metrics

| Metric | Normal Range | Warning Threshold | Critical Threshold |
|--------|--------------|-------------------|-------------------|
| CPU Usage | 20-60% | > 80% | > 95% |
| Memory Usage | < 4GB | > 6GB | > 7GB |
| Request Latency | < 100ms | > 500ms | > 1000ms |
| Error Rate | < 0.1% | > 1% | > 5% |

### Dashboards
- **Primary Dashboard**: [Link to Grafana dashboard]
- **Logs Dashboard**: [Link to log viewer]
- **Alerts**: [Link to alert manager]

### Log Locations
```bash
# Application logs
tail -f /var/log/service-name/app.log

# Error logs
tail -f /var/log/service-name/error.log

# System logs
journalctl -u service-name -f
```

### Health Checks

**Automated**:
- Prometheus scrape: Every 30s
- Health endpoint: Every 60s
- Kubernetes probe: Every 10s (if applicable)

**Manual**:
```bash
# Check service health
./scripts/check-health.sh service-name

# Run diagnostic
./tools/diagnose-service.sh service-name
```

---

## Troubleshooting

### Common Issues

#### Issue 1: [Problem Description]

**Symptoms**:
- Symptom 1
- Symptom 2

**Diagnosis**:
```bash
# Commands to diagnose
command1
command2
```

**Resolution**:
1. Step 1
2. Step 2
3. Step 3

**Root Cause**: [If known]

**Prevention**: [How to avoid in future]

---

#### Issue 2: Service Won't Start

**Symptoms**:
- Service fails to start
- Error in systemd status

**Diagnosis**:
```bash
# Check service logs
journalctl -u service-name --no-pager | tail -50

# Check configuration
./scripts/validate-config.sh

# Check dependencies
./scripts/check-dependencies.sh
```

**Common Causes**:
- Configuration error → Fix config and restart
- Dependency unavailable → Start dependency first
- Port already in use → Identify and stop conflicting process
- Insufficient permissions → Check file ownership and permissions

---

#### Issue 3: High Latency

**Symptoms**:
- Response times > 500ms
- Request queue building up

**Diagnosis**:
```bash
# Check resource usage
top -p $(pgrep service-name)

# Check connection pool
./tools/check-connections.sh

# Profile slow requests
./tools/profile-requests.sh
```

**Resolution**:
- If CPU bound → Scale horizontally or optimize
- If I/O bound → Check disk or network performance
- If dependency slow → Investigate downstream service
- If memory pressure → Check for memory leaks, restart if needed

---

### Debugging Steps

1. **Check service status**
   ```bash
   systemctl status service-name
   ```

2. **Review recent logs**
   ```bash
   journalctl -u service-name --since "10 minutes ago"
   ```

3. **Check resource usage**
   ```bash
   htop -p $(pgrep service-name)
   ```

4. **Verify configuration**
   ```bash
   ./scripts/validate-config.sh
   ```

5. **Test dependencies**
   ```bash
   ./scripts/check-dependencies.sh
   ```

6. **Check network connectivity**
   ```bash
   nc -zv dependency-host port
   ```

---

## Maintenance

### Routine Maintenance

**Daily**:
- Review error logs
- Check monitoring dashboards
- Validate backups completed

**Weekly**:
- Review capacity and usage trends
- Check for security updates
- Rotate logs if needed

**Monthly**:
- Update dependencies
- Review and test backup restore
- Capacity planning review

### Updating the Service

**Preparation**:
1. Review changelog for breaking changes
2. Test update in non-production environment
3. Create backup/snapshot
4. Schedule maintenance window
5. Notify stakeholders (if applicable)

**Update Procedure**:
```bash
# 1. Backup current state
./scripts/backup-service.sh service-name

# 2. Stop service
sudo systemctl stop service-name

# 3. Update binaries/packages
sudo apt update && sudo apt upgrade service-name
# OR
./scripts/deploy-new-version.sh v1.2.3

# 4. Update configuration if needed
vim /etc/service-name/config.yml

# 5. Start service
sudo systemctl start service-name

# 6. Verify functionality
./scripts/health-check.sh service-name

# 7. Monitor for issues
journalctl -u service-name -f
```

**Rollback Procedure**:
```bash
# If update fails, rollback
./scripts/rollback-service.sh service-name
```

### Backup & Recovery

**Backup Procedure**:
```bash
# Manual backup
./scripts/backup-service.sh service-name

# Backup includes:
# - Configuration files
# - Data directories
# - State information
```

**Backup Schedule**: [Daily/Weekly/etc.]
**Backup Retention**: [How long backups are kept]
**Backup Location**: [Where backups are stored]

**Recovery Procedure**:
```bash
# 1. Stop service
sudo systemctl stop service-name

# 2. Restore from backup
./scripts/restore-service.sh service-name backup-YYYYMMDD

# 3. Start service
sudo systemctl start service-name

# 4. Verify functionality
./scripts/health-check.sh service-name
```

**Recovery Time Objective (RTO)**: [Target time to restore]
**Recovery Point Objective (RPO)**: [Acceptable data loss window]

---

## Emergency Procedures

### Service Down - Critical

**Immediate Actions**:
1. Check if service is running: `systemctl status service-name`
2. If not running, attempt restart: `systemctl restart service-name`
3. If restart fails, check logs: `journalctl -u service-name --no-pager | tail -100`
4. Notify on-call if issue persists beyond 5 minutes
5. Check for cascading failures in dependent services

**Communication**:
- Notify: [Who to notify]
- Channels: [Slack, email, etc.]
- Escalation: [Escalation path]

### Data Loss Event

**Immediate Actions**:
1. Stop the service to prevent further data loss
2. Identify extent of data loss
3. Check for available backups
4. Do NOT overwrite existing data
5. Notify on-call immediately
6. Document everything

### Security Incident

**Immediate Actions**:
1. Isolate affected service/system
2. Preserve logs and evidence
3. Notify security contact
4. Do NOT restart or modify system until investigated
5. Document timeline of events

---

## Configuration Reference

### Configuration File: `/etc/service-name/config.yml`

```yaml
# Example configuration with explanations
server:
  host: 0.0.0.0          # Bind address (0.0.0.0 = all interfaces)
  port: 8080             # Service port
  workers: 4             # Number of worker processes

database:
  host: localhost
  port: 5432
  name: service_db
  pool_size: 10          # Connection pool size

logging:
  level: INFO            # DEBUG | INFO | WARN | ERROR
  file: /var/log/service-name/app.log
```

### Environment Variables

| Variable | Purpose | Default | Required |
|----------|---------|---------|----------|
| `SERVICE_ENV` | Environment name | `dev` | No |
| `SERVICE_PORT` | Override config port | - | No |
| `DB_PASSWORD` | Database password | - | Yes |

---

## Performance Tuning

### Key Tuning Parameters

**CPU Optimization**:
- Worker processes: [Guidance on optimal number]
- Thread pool size: [Guidance]

**Memory Optimization**:
- Buffer sizes: [Guidance]
- Cache configuration: [Guidance]

**I/O Optimization**:
- Connection pool size: [Guidance]
- Batch sizes: [Guidance]

### Load Testing

```bash
# Run load test
./tools/load-test.sh service-name --rps 1000 --duration 60s

# Analyze results
./tools/analyze-performance.sh results.json
```

---

## Related Documentation

- [Architecture Overview](../architecture/OVERVIEW.md)
- [Decision Log: Why We Chose This Approach](../decisions/YYYY-MM-DD-decision.md)
- [Experiment: Performance Baseline](../../experiments/category/experiment-name/)
- [Related Runbook: Dependent Service](./related-service.md)

---

## Revision History

| Date | Change | Author |
|------|--------|--------|
| YYYY-MM-DD | Initial runbook | Name |

---

## Contact & Escalation

**Primary Contact**: [Name/Team]
**On-Call**: [On-call rotation or contact]
**Escalation**: [Escalation path]

---

*This runbook ensures consistent, reliable operation of [Component Name] in Cascadia Mobile Systems Lab.*
