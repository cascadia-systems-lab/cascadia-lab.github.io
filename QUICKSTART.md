# Quick Start Guide

**Getting oriented in Cascadia AI Systems Lab**

---

## Welcome

This guide helps you navigate and start working in Cascadia AI Systems Lab—an infrastructure research environment for AI systems, GPU computing, and data infrastructure.

---

## First Steps

### 1. Understand What This Is

Cascadia AI Systems Lab is NOT:
- ❌ A single application or product
- ❌ A tutorial or course project
- ❌ A collection of scripts

Cascadia AI Systems Lab IS:
- ✅ An infrastructure research laboratory
- ✅ A long-term experimental environment
- ✅ A knowledge base of AI systems engineering
- ✅ A collection of documented experiments and infrastructure

### 2. Read Core Documentation

**Essential Reading** (30 minutes):
1. [Lab Philosophy](docs/architecture/LAB_PHILOSOPHY.md) - Operating principles
2. [Architecture Overview](docs/architecture/OVERVIEW.md) - System design
3. [Standards & Conventions](docs/architecture/STANDARDS.md) - How things are organized

**Before Working** (15 minutes):
4. [Experiment Template](docs/experiments/TEMPLATE.md) - If running experiments
5. [Infrastructure README](infrastructure/README.md) - If deploying infrastructure
6. [Contributing Guide](CONTRIBUTING.md) - If collaborating

---

## Directory Overview

```
cascadia-ai-systems-lab/
├── experiments/          # Structured experiments (read/write)
├── infrastructure/       # Production infrastructure code (read/write)
├── tooling/             # Lab utilities and tools (read/write)
├── docs/                # Technical documentation (read frequently, write when things change)
├── configs/             # Configuration files (read/write)
├── scripts/             # Operational scripts (read/write)
├── research/            # External research and papers (read/reference)
└── .lab/                # Lab metadata (managed automatically)
```

**Key Principle**: Documentation lives in `docs/`, work lives in `experiments/` and `infrastructure/`.

---

## Common Tasks

### Starting a New Experiment

```bash
# 1. Create experiment directory
mkdir -p experiments/<category>/$(date +%Y%m%d)-<experiment-name>
cd experiments/<category>/$(date +%Y%m%d)-<experiment-name>

# 2. Copy experiment template
cp ../../../docs/experiments/TEMPLATE.md README.md

# 3. Edit README.md with your experiment details
# Fill in: Objective, Hypothesis, Methodology, Environment

# 4. Update experiment index
# Add entry to docs/experiments/INDEX.md

# 5. Run experiment and document findings in RESULTS.md
```

**Then**: Conduct experiment, document findings, update index when complete.

### Deploying New Infrastructure

```bash
# 1. Document the decision
# Create: docs/decisions/YYYY-MM-DD-<decision-name>.md
# Use template: docs/decisions/TEMPLATE.md

# 2. Create infrastructure component
mkdir -p infrastructure/<category>/<component-name>
cd infrastructure/<category>/<component-name>

# 3. Add configuration and deployment code
# Create: config/, deploy.sh, README.md

# 4. Test in isolated environment first

# 5. Create runbook
# Copy: docs/runbooks/TEMPLATE.md to docs/runbooks/<component>.md
# Document: Setup, operations, troubleshooting

# 6. Deploy and monitor
```

### Creating a Tool

```bash
# 1. Determine category (automation, diagnostics, benchmarking)
cd tooling/<category>

# 2. Create tool script
# Use script template from scripts/README.md
vim <tool-name>.sh

# 3. Make executable
chmod +x <tool-name>.sh

# 4. Add usage documentation
# Either in script header or separate README.md

# 5. Test thoroughly before using in production
```

### Documenting a Decision

```bash
# 1. Copy decision template
cp docs/decisions/TEMPLATE.md docs/decisions/$(date +%Y-%m-%d)-<decision-name>.md

# 2. Fill in:
# - Context: What requires a decision?
# - Options: What alternatives exist?
# - Decision: What was chosen?
# - Rationale: Why?
# - Consequences: Trade-offs and impacts

# 3. Reference in relevant documentation
# Link from: Architecture docs, runbooks, experiment results
```

---

## Navigation Map

### "I want to understand..."

- **...what this lab is about** → [README.md](README.md)
- **...how things are organized** → [Standards & Conventions](docs/architecture/STANDARDS.md)
- **...the system architecture** → [Architecture Overview](docs/architecture/OVERVIEW.md)
- **...the lab philosophy** → [Lab Philosophy](docs/architecture/LAB_PHILOSOPHY.md)

### "I want to find..."

- **...what experiments have been done** → [Experiment Index](docs/experiments/INDEX.md)
- **...what hardware we have** → [Hardware Inventory](docs/hardware/INVENTORY.md)
- **...why decisions were made** → [Decision Logs](docs/decisions/)
- **...how to operate something** → [Runbooks](docs/runbooks/)
- **...relevant research** → [Research Directory](research/)

### "I want to do..."

- **...a new experiment** → Use [Experiment Template](docs/experiments/TEMPLATE.md)
- **...deploy infrastructure** → Read [Infrastructure README](infrastructure/README.md)
- **...create a tool** → See [Tooling README](tooling/README.md)
- **...document a decision** → Use [Decision Template](docs/decisions/TEMPLATE.md)
- **...contribute** → Read [Contributing Guide](CONTRIBUTING.md)

---

## Key Principles to Remember

### 1. Document Everything
Documentation is not optional. Every experiment, decision, and infrastructure change must be documented.

### 2. Experiment ≠ Production
Code in `experiments/` is exploratory. Code in `infrastructure/` should be stable.

### 3. Failures Are Valuable
Document what doesn't work. Failed experiments teach as much as successful ones.

### 4. Reproducibility Matters
If someone else can't reproduce it, it's not complete.

### 5. Real Hardware, Real Workloads
Prefer physical systems and actual workloads over simulations and synthetic tests.

---

## Cheat Sheet

### File Naming

```bash
# Experiments
YYYYMMDD-descriptive-name/

# Decision Logs
YYYY-MM-DD-decision-name.md

# Scripts
verb-object.sh

# Infrastructure Components
component-type-purpose/
```

### Documentation Quick Reference

| Type | Location | Template |
|------|----------|----------|
| Experiment | `experiments/<category>/<name>/` | [Template](docs/experiments/TEMPLATE.md) |
| Decision | `docs/decisions/` | [Template](docs/decisions/TEMPLATE.md) |
| Runbook | `docs/runbooks/` | [Template](docs/runbooks/TEMPLATE.md) |
| Architecture | `docs/architecture/` | No template (free-form) |

### Common Commands

```bash
# List experiments
ls -lht experiments/*/

# Find recent decision logs
ls -lt docs/decisions/

# Check experiment status
cat docs/experiments/INDEX.md

# View hardware inventory
cat docs/hardware/INVENTORY.md

# Search documentation
grep -r "search term" docs/
```

---

## Getting Help

### Documentation
- Start with relevant README.md in each directory
- Check templates for structure guidance
- Review standards for conventions

### Questions
- Open an issue for questions
- Review existing experiments for patterns
- Consult decision logs for rationale

### Problems
- Check runbooks for operational issues
- Review logs for errors
- Test in isolation before production

---

## Next Steps

### For New Users

1. ✅ Read this quick start
2. ✅ Review [Lab Philosophy](docs/architecture/LAB_PHILOSOPHY.md)
3. ✅ Explore [Experiment Index](docs/experiments/INDEX.md)
4. ⏭️ Choose your first task (experiment, tool, or infrastructure)
5. ⏭️ Follow relevant template and standards
6. ⏭️ Document thoroughly as you work

### For Returning Users

1. Review [Experiment Index](docs/experiments/INDEX.md) for updates
2. Check [Decision Logs](docs/decisions/) for recent changes
3. Update [Hardware Inventory](docs/hardware/INVENTORY.md) if hardware changed
4. Continue your work, documenting as you go

### For Contributors

1. Read [Contributing Guide](CONTRIBUTING.md)
2. Coordinate with lab maintainers
3. Follow templates and standards
4. Submit pull requests with complete documentation

---

## Project Status

**Phase**: Foundation
**Focus**: Initial setup and baseline experiments
**Next Milestone**: Hardware provisioning and performance baseline

See [README.md](README.md) for current focus areas and status.

---

## Summary

Cascadia AI Systems Lab is an infrastructure research environment focused on AI systems engineering. It values:

- 📝 **Documentation** - Write everything down
- 🔬 **Experimentation** - Test hypotheses with real workloads
- 🏗️ **Infrastructure** - Build practical, self-hosted systems
- 📊 **Measurement** - Data over opinions
- 🔄 **Reproducibility** - Anyone should be able to repeat your work

**Remember**: This is a lab, not a product. Focus on learning, documenting, and building practical systems.

---

**Ready to start?** Pick a task, follow a template, and document what you learn.

**Questions?** Check the docs/ directory or open an issue.

**Good luck building!** 🚀
