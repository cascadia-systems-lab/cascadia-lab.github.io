# Standards & Conventions

**Operational standards for Cascadia Mobile Systems Lab**

---

## Purpose

This document defines naming conventions, documentation standards, and organizational practices for the lab. Following these conventions ensures consistency, maintainability, and clarity as the lab scales.

---

## Directory Structure Standards

### Top-Level Organization

```
cascadia-mobile-systems-lab/
├── experiments/          # All experimental work
├── infrastructure/       # Production-grade infrastructure code
├── tooling/             # Utilities and automation
├── docs/                # All documentation
├── configs/             # Configuration files
├── scripts/             # Standalone scripts
├── research/            # External research and references
└── .lab/                # Lab metadata (git-ignored runtime state)
```

### Experiment Structure

Each experiment follows this layout:

```
experiments/<category>/<experiment-name>/
├── README.md            # Experiment overview and purpose
├── RESULTS.md           # Findings and performance data
├── setup.sh             # Reproducible setup script
├── config/              # Experiment-specific configs
├── src/                 # Source code (if applicable)
├── data/                # Input data (gitignored if large)
├── outputs/             # Results and artifacts (gitignored)
└── logs/                # Runtime logs (gitignored)
```

---

## Naming Conventions

### Experiments

Format: `<YYYYMMDD>-<descriptive-name>`

Examples:
- `20260211-vllm-inference-baseline`
- `20260215-gpu-memory-fragmentation`
- `20260220-storage-tier-performance`

**Rationale**: Date prefix enables chronological sorting. Descriptive names enable quick identification.

### Infrastructure Components

Format: `<component-type>-<purpose>`

Examples:
- `monitoring-prometheus-stack`
- `cluster-k3s-config`
- `networking-wireguard-mesh`

**Rationale**: Type prefix groups related components. Purpose suffix describes function.

### Documentation Files

- Use `UPPERCASE.md` for primary docs (README.md, RESULTS.md, ARCHITECTURE.md)
- Use `lowercase-with-hyphens.md` for supporting docs
- Prefix decision logs with ISO date: `2026-02-11-storage-backend-selection.md`

### Configuration Files

- Use descriptive names: `prometheus.yml`, `gpu-monitoring.conf`
- Group by service or system: `monitoring/`, `storage/`, `networking/`
- Include environment indicators: `dev.env`, `prod.env`, `staging.env`

### Scripts

Format: `<verb>-<object>.sh`

Examples:
- `setup-gpu-drivers.sh`
- `benchmark-storage.sh`
- `deploy-monitoring.sh`

**Rationale**: Verb-first naming makes intent immediately clear.

---

## Documentation Standards

### Experiment Documentation

Every experiment **must** have:

1. **README.md** containing:
   - **Objective**: What are you trying to learn or build?
   - **Hypothesis**: What do you expect to happen?
   - **Methodology**: How will you test it?
   - **Environment**: Hardware, software versions, configurations
   - **Setup**: Step-by-step reproduction instructions
   - **Duration**: Expected and actual runtime

2. **RESULTS.md** containing:
   - **Summary**: What did you learn? (1-2 sentences)
   - **Data**: Performance metrics, logs, screenshots
   - **Analysis**: What do the results mean?
   - **Conclusions**: What worked, what didn't, why?
   - **Next Steps**: What should be tried next?
   - **References**: Links to related experiments or external docs

### Template

Use the experiment template:
```bash
cp docs/experiments/TEMPLATE.md experiments/<category>/<experiment-name>/README.md
```

### Infrastructure Documentation

Infrastructure changes **must** be documented with:

1. **Decision Log Entry** (`docs/decisions/YYYY-MM-DD-<decision>.md`) containing:
   - **Context**: What problem are you solving?
   - **Options Considered**: What alternatives exist?
   - **Decision**: What did you choose?
   - **Rationale**: Why this option?
   - **Consequences**: What are the trade-offs?
   - **Status**: Proposed, Accepted, Deprecated, Superseded

2. **Runbook Entry** (if operational) in `docs/runbooks/<component>.md` containing:
   - **Purpose**: What does this component do?
   - **Dependencies**: What does it require?
   - **Operations**: Start, stop, restart procedures
   - **Monitoring**: What to watch, what's normal
   - **Troubleshooting**: Common issues and solutions

### Hardware Documentation

New hardware **must** be logged in `docs/hardware/INVENTORY.md` with:
- Model and specifications
- Purchase/acquisition date
- Physical location
- Current role/assignment
- Performance baseline results

---

## Code & Configuration Standards

### Version Control

- **Commit messages**: Use conventional commits format
  ```
  type(scope): description

  Examples:
  feat(monitoring): add GPU memory tracking
  fix(storage): correct mount path in config
  docs(experiments): document VLLM baseline results
  infra(cluster): update k3s to v1.28
  ```

- **Branching**:
  - `main` = stable, documented state
  - `experiment/<name>` = active experiment branches
  - `infra/<component>` = infrastructure changes

### Configuration Management

- **Secrets**: Never commit secrets. Use environment variables or secret managers
- **Defaults**: Include reasonable defaults with documentation
- **Comments**: Explain *why*, not *what*. The config itself shows what.
- **Validation**: Include schema validation where possible

### Scripting Standards

All scripts should:
- Include a header comment explaining purpose
- Use `set -euo pipefail` for bash scripts
- Accept `--help` flag with usage information
- Log important actions with timestamps
- Exit with meaningful error codes
- Be idempotent when possible

Example header:
```bash
#!/usr/bin/env bash
#
# setup-gpu-drivers.sh - Install and configure NVIDIA GPU drivers
#
# Usage: ./setup-gpu-drivers.sh [--version <driver-version>]
#
# Description:
#   Installs NVIDIA drivers, CUDA toolkit, and container runtime.
#   Configures persistence daemon and validates installation.
#

set -euo pipefail
```

---

## Logging & Observability Standards

### Logging Levels

- **DEBUG**: Detailed diagnostic information
- **INFO**: Routine operational events
- **WARN**: Unusual but handled conditions
- **ERROR**: Errors requiring attention
- **FATAL**: System cannot continue

### Log Format

Prefer structured logging (JSON) for machine parsing:
```json
{
  "timestamp": "2026-02-11T15:30:45Z",
  "level": "INFO",
  "component": "model-server",
  "message": "Request processed",
  "duration_ms": 142,
  "gpu_util": 0.87
}
```

### Metrics Naming

Format: `<namespace>_<subsystem>_<metric>_<unit>`

Examples:
- `lab_gpu_utilization_percent`
- `lab_storage_read_bytes_per_second`
- `lab_inference_latency_milliseconds`

---

## Experiment Lifecycle

### 1. Proposal
- Create experiment directory
- Write README.md with objectives and methodology
- Get reviewed (self-review for solo work)

### 2. Execution
- Follow documented methodology
- Log all configuration changes
- Capture metrics continuously
- Document deviations from plan

### 3. Analysis
- Write RESULTS.md with findings
- Include raw data or links to it
- Be honest about failures and limitations

### 4. Archival
- Mark experiment as `[ARCHIVED]` in directory name if inactive
- Ensure all documentation is complete
- Update experiment index

---

## Infrastructure Change Protocol

### For Non-Critical Changes
1. Document the change in decision log (if significant)
2. Test in isolated environment first
3. Apply change with logging
4. Update runbooks and documentation
5. Monitor for unexpected behavior

### For Critical Changes
1. Write detailed change proposal
2. Document rollback procedure
3. Schedule maintenance window
4. Create pre-change backup/snapshot
5. Execute change with monitoring
6. Validate functionality
7. Document actual vs. expected outcomes

---

## Review & Maintenance

### Weekly
- Review active experiment progress
- Check system health dashboards
- Address any operational issues

### Monthly
- Update hardware inventory
- Review and update runbooks
- Archive completed experiments
- Update lab status in root README

### Quarterly
- Review lab philosophy and standards
- Evaluate infrastructure decisions
- Plan next phase priorities
- Audit documentation completeness

---

## Exceptions

Standards are guidelines, not rigid rules. Exceptions are acceptable when:
- Clearly documented with rationale
- Time-sensitive operational needs require it
- Experimenting with better approaches
- External constraints prevent compliance

**Document all exceptions** in the relevant README or decision log.

---

## Evolution

These standards will evolve. Propose changes via:
1. Document the limitation of current standard
2. Propose alternative with rationale
3. Test new approach in limited scope
4. Update standards doc if successful

**Current Version**: 1.0 (2026-02-11)

---

*These standards ensure Cascadia Mobile Systems Lab remains organized, maintainable, and valuable over time.*
