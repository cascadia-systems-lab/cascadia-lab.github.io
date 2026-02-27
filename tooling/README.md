# Tooling

Custom utilities, diagnostic tools, and automation scripts developed for Cascadia Mobile Systems Lab operations.

## Purpose

This directory contains lab-specific tooling that doesn't fit into standard infrastructure or experiments. These are operational tools built to support day-to-day lab work.

## Organization

- **automation/** - Task automation, workflow helpers, integration scripts
- **diagnostics/** - Debugging tools, system profiling, health checks
- **benchmarking/** - Performance testing suites, standardized benchmarks

## Tool Categories

### Automation
Scripts and utilities that automate repetitive tasks:
- System health checks
- Backup and snapshot management
- Deployment helpers
- Bulk operations on infrastructure

### Diagnostics
Tools for troubleshooting and understanding system behavior:
- GPU memory profiling
- Network latency testing
- Storage I/O analysis
- Process and resource monitoring

### Benchmarking
Standardized performance testing:
- GPU compute benchmarks
- Storage throughput tests
- Network bandwidth measurements
- End-to-end workflow timing

## Tool Standards

Each tool should:

1. **Have a clear purpose**
   - Document what problem it solves
   - Include usage examples
   - Specify prerequisites

2. **Be self-documenting**
   - Include `--help` flag
   - Provide clear error messages
   - Log important actions

3. **Be safe**
   - Validate inputs
   - Dry-run mode for destructive operations
   - Clear warnings for risky actions

4. **Be maintainable**
   - Clear, readable code
   - Dependencies documented
   - Version compatibility noted

## Tool Structure

```
<tool-name>/
├── README.md           # Purpose, usage, examples
├── <tool-script>       # Main executable
├── config/             # Default configurations
├── lib/                # Supporting libraries
└── tests/              # Test cases (if complex)
```

Simple single-file tools can exist at the category level without a subdirectory.

## Creating a New Tool

1. Determine appropriate category
2. Create tool script with header documentation
3. Make executable: `chmod +x <tool-script>`
4. Add README if tool is complex
5. Test thoroughly before using in production

## Tool Template

```bash
#!/usr/bin/env bash
#
# tool-name.sh - Brief description of purpose
#
# Usage: ./tool-name.sh [options]
#
# Description:
#   Detailed explanation of what this tool does and why it exists.
#
# Options:
#   -h, --help     Show this help message
#   -v, --verbose  Enable verbose output
#   -d, --dry-run  Show what would be done without doing it
#

set -euo pipefail

# [Tool implementation]
```

## Best Practices

- **Start simple**: Build minimum viable tool, iterate based on usage
- **Fail fast**: Exit immediately on errors, don't continue in bad state
- **Log actions**: Record what the tool does for auditing and debugging
- **Test edge cases**: Consider what happens with bad input, missing files, etc.
- **Document learnings**: If tool reveals insights, update relevant docs

## Integration with Lab Workflows

Tools here may be:
- Called from infrastructure automation
- Used interactively during experiments
- Integrated into monitoring/alerting
- Part of setup or deployment procedures

## Reusability

Tools developed here may be:
- Extracted and published as standalone utilities
- Contributed to upstream projects
- Shared with the broader community

Document any external dependencies or lab-specific assumptions.

## Related Documentation

- [Scripts Directory](../scripts/README.md) - Operational scripts vs. tools
- [Standards & Conventions](../docs/architecture/STANDARDS.md)
- [Experiment Tools](../experiments/) - Experiment-specific scripts

---

**Note**: Tools here are operational utilities. Keep them focused, well-tested, and documented. Avoid feature creep—build specific tools for specific needs.
