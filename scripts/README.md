# Scripts

Operational scripts for setup, maintenance, and deployment of Cascadia AI Systems Lab infrastructure.

## Purpose

This directory contains standalone scripts that perform specific operational tasks. These are distinct from tools in that they are typically one-off operations or scheduled maintenance tasks rather than interactive utilities.

## Organization

- **setup/** - Initial system setup and bootstrapping scripts
- **maintenance/** - Regular maintenance and housekeeping tasks
- **deployment/** - Deployment and update automation

## Script Categories

### Setup Scripts
Run once or infrequently to bootstrap systems:
- OS configuration and hardening
- Driver installation (GPU, network, storage)
- Base package installation
- Initial user and permission setup
- Network configuration

### Maintenance Scripts
Run regularly to keep systems healthy:
- Log rotation and cleanup
- Backup and snapshot creation
- Health checks and validation
- Dependency updates
- Performance monitoring

### Deployment Scripts
Used to deploy or update infrastructure:
- Service deployment
- Configuration rollout
- Rolling updates
- Rollback procedures

## Script Standards

All scripts must follow these standards:

### 1. Header Documentation
```bash
#!/usr/bin/env bash
#
# script-name.sh - One-line description
#
# Usage: ./script-name.sh [options]
#
# Description:
#   Detailed explanation of what this script does,
#   when it should be run, and any prerequisites.
#
# Options:
#   -h, --help     Show help
#   -v, --verbose  Verbose output
#   -d, --dry-run  Show actions without executing
#
# Examples:
#   ./script-name.sh --dry-run
#   ./script-name.sh --verbose
#
# Prerequisites:
#   - Requirement 1
#   - Requirement 2
#

set -euo pipefail
```

### 2. Safety Features
- `set -euo pipefail` for bash scripts
- Input validation
- Dry-run mode for destructive operations
- Confirmation prompts for critical actions
- Rollback capability where applicable

### 3. Logging
```bash
# Use consistent logging format
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

log "INFO: Starting operation"
log "ERROR: Operation failed"
```

### 4. Exit Codes
```bash
# 0   = Success
# 1   = General error
# 2   = Misuse (bad arguments)
# 130 = Script terminated by Ctrl+C
# Custom codes for specific failures (document them)
```

### 5. Idempotency
Scripts should be safe to run multiple times:
- Check if work is already done before doing it
- Don't fail if desired state already exists
- Clean up partial work on failure

## Script Template

```bash
#!/usr/bin/env bash
#
# template-script.sh - Template for new scripts
#
# Usage: ./template-script.sh [options]
#
# Description:
#   Description goes here.
#

set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_LEVEL="${LOG_LEVEL:-INFO}"

# Logging
log() {
    local level="$1"
    shift
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$level] $*" >&2
}

info() { log "INFO" "$@"; }
warn() { log "WARN" "$@"; }
error() { log "ERROR" "$@"; }

# Error handling
cleanup() {
    # Cleanup code here
    :
}
trap cleanup EXIT

die() {
    error "$@"
    exit 1
}

# Help
usage() {
    grep '^#' "$0" | cut -c4-
    exit 0
}

# Main function
main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help) usage ;;
            -v|--verbose) set -x; shift ;;
            *) die "Unknown option: $1" ;;
        esac
    done

    info "Starting script"

    # Script logic here

    info "Script completed successfully"
}

# Run main function
main "$@"
```

## Script Naming

Format: `<verb>-<object>.sh`

Examples:
- `setup-gpu-drivers.sh`
- `backup-prometheus-data.sh`
- `deploy-monitoring-stack.sh`
- `cleanup-old-logs.sh`

**Rationale**: Verb-first makes action clear; `.sh` extension indicates shell script.

## Testing Scripts

Before deploying scripts:
1. Test in isolated environment (VM or separate system)
2. Test dry-run mode if applicable
3. Test with invalid inputs
4. Test interruption handling (Ctrl+C)
5. Verify cleanup and rollback work

## Automation & Scheduling

Scripts may be:
- Run manually by operators
- Scheduled via cron or systemd timers
- Triggered by infrastructure events
- Called from other scripts or tools

Document automation in runbooks if scripts are scheduled.

## Script vs. Tool

**Scripts** (in this directory):
- Operational tasks: setup, maintenance, deployment
- Typically run non-interactively
- May be scheduled or automated
- State-changing operations

**Tools** (in `../tooling/`):
- Interactive utilities
- Diagnostic and debugging tools
- Benchmarking and profiling
- Query and reporting

If unsure, ask: "Is this a one-time operation or regular maintenance?" → Script
"Is this an interactive utility or diagnostic tool?" → Tool

## Dependencies

Document all dependencies in script header:
- Required packages
- Minimum versions
- Expected environment
- Permissions needed

Example:
```bash
# Prerequisites:
#   - sudo access
#   - nvidia-smi installed
#   - Python 3.8+
#   - jq for JSON parsing
```

## Security Considerations

- **Secrets**: Never hardcode secrets; use environment variables or secret managers
- **Privileges**: Run with minimum required privileges; escalate only when necessary
- **Validation**: Validate all inputs; don't trust user input
- **Logging**: Don't log secrets or sensitive information

## Related Documentation

- [Tooling Directory](../tooling/README.md) - For interactive tools
- [Infrastructure](../infrastructure/README.md) - For infrastructure-as-code
- [Runbooks](../docs/runbooks/) - For operational procedures

---

**Note**: Scripts in this directory affect real systems. Test thoroughly, document clearly, and include safety checks. A well-written script prevents operational mistakes and enables confident automation.
