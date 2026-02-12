# Infrastructure

Core infrastructure configurations, provisioning code, and operational tooling for Cascadia AI Systems Lab.

## Purpose

This directory contains production-grade infrastructure code that is actively used to run and manage lab systems. Unlike experimental code, infrastructure code here is expected to be stable, documented, and maintained.

## Organization

- **provisioning/** - System setup, configuration management, infrastructure-as-code
- **monitoring/** - Observability stack (metrics, logging, alerting)
- **orchestration/** - Workload scheduling, container orchestration, job management
- **networking/** - Network configuration, VPN setup, firewall rules
- **cluster-config/** - Multi-node cluster setup and coordination

## Guidelines

### Infrastructure as Code

All infrastructure should be:
- **Declarative**: Define desired state, not imperative steps
- **Version-controlled**: All configs tracked in git
- **Idempotent**: Safe to run multiple times
- **Documented**: Purpose and dependencies clearly stated

### Configuration Management

- Use environment-specific configs: `dev.yml`, `staging.yml`, `prod.yml`
- Store secrets separately (never commit secrets to git)
- Document all non-obvious configuration options
- Include validation or dry-run modes where possible

### Testing Infrastructure Changes

Before applying infrastructure changes:
1. Test in isolated environment first
2. Document rollback procedure
3. Create backup/snapshot if change is risky
4. Apply with logging and monitoring
5. Validate functionality post-change

## Change Management

Infrastructure changes should:
1. Be documented in [Decision Log](../docs/decisions/) if significant
2. Have a corresponding runbook entry in [Runbooks](../docs/runbooks/)
3. Be reviewed (self-review for solo work is acceptable)
4. Include monitoring/alerting for new components

See [Infrastructure Change Protocol](../docs/architecture/STANDARDS.md#infrastructure-change-protocol) for details.

## Directory Structure

Each infrastructure component follows this pattern:

```
<component-name>/
├── README.md           # Purpose, setup, and usage
├── config/             # Configuration files
├── scripts/            # Component-specific automation
├── deploy.sh           # Deployment script (if applicable)
└── docs/               # Component-specific documentation
```

## Common Patterns

### Provisioning
- OS installation and base configuration
- Driver installation (GPU, network, storage)
- User and permission setup
- Base package installation

### Monitoring
- Metrics collection (Prometheus, DCGM)
- Log aggregation (Loki, structured logging)
- Visualization (Grafana dashboards)
- Alerting (Alertmanager, notification routing)

### Orchestration
- Container runtime configuration
- Kubernetes/k3s cluster setup
- GPU scheduling and allocation
- Resource limits and quotas

### Networking
- Network topology setup
- VPN configuration (WireGuard, Tailscale)
- Firewall rules and security groups
- DNS and service discovery

## Related Documentation

- [Architecture Overview](../docs/architecture/OVERVIEW.md)
- [Runbooks](../docs/runbooks/)
- [Decision Logs](../docs/decisions/)
- [Standards & Conventions](../docs/architecture/STANDARDS.md)

## Security Considerations

- **Secrets**: Use environment variables or secret managers, never commit secrets
- **Access Control**: Document who/what has access to each component
- **Network Security**: Default to deny, explicitly allow required traffic
- **Updates**: Keep security-critical components updated

## Getting Help

For operational issues:
1. Check relevant runbook in [Runbooks](../docs/runbooks/)
2. Review component README in this directory
3. Check monitoring dashboards for anomalies
4. Review logs for error messages

---

**Note**: Infrastructure code should be treated with care. Changes here affect running systems. Always test in isolation first and have rollback procedures ready.
