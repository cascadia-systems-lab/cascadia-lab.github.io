# Project Structure

**Complete directory layout for Cascadia Mobile Systems Lab**

---

## Overview

This document provides a visual reference for the complete project structure. Use it to understand where different types of files and work belong.

---

## Complete Directory Tree

```
cascadia-mobile-systems-lab/
│
├── .lab/                           # Lab metadata and runtime state (gitignored)
│
├── configs/                        # Configuration files
│   ├── system/                    # OS and system-level configs
│   ├── environment/               # Environment-specific configs (dev, staging, prod)
│   └── services/                  # Service-specific configurations
│
├── docs/                          # All documentation
│   ├── architecture/              # System design and principles
│   │   ├── LAB_PHILOSOPHY.md     # Lab operating principles
│   │   ├── STANDARDS.md          # Conventions and best practices
│   │   └── OVERVIEW.md           # Infrastructure architecture
│   │
│   ├── decisions/                 # Architectural Decision Records (ADRs)
│   │   └── TEMPLATE.md           # Decision log template
│   │
│   ├── experiments/               # Experiment documentation
│   │   ├── INDEX.md              # Master experiment index
│   │   └── TEMPLATE.md           # Experiment template
│   │
│   ├── hardware/                  # Hardware specifications
│   │   └── INVENTORY.md          # Hardware inventory and baselines
│   │
│   ├── runbooks/                  # Operational procedures
│   │   └── TEMPLATE.md           # Runbook template
│   │
│   ├── research-notes/            # External research summaries
│   │
│   └── README.md                  # Documentation guide
│
├── experiments/                   # All experimental work
│   ├── gpu-acceleration/         # GPU performance experiments
│   ├── model-serving/            # Inference and serving experiments
│   ├── data-pipelines/           # ETL and data processing
│   ├── storage-systems/          # Storage architecture experiments
│   ├── virtualization/           # Container and VM experiments
│   ├── networking/               # Network optimization experiments
│   │
│   └── README.md                 # Experiment directory guide
│
├── infrastructure/                # Production infrastructure code
│   ├── provisioning/             # System setup and configuration
│   ├── monitoring/               # Observability stack
│   ├── orchestration/            # Workload scheduling
│   ├── networking/               # Network configuration
│   ├── cluster-config/           # Multi-node cluster setup
│   │
│   └── README.md                 # Infrastructure guide
│
├── research/                      # External research and references
│   ├── papers/                   # Academic papers and white papers
│   ├── findings/                 # Synthesized research findings
│   ├── ideas/                    # Future research directions
│   │
│   └── README.md                 # Research directory guide
│
├── scripts/                       # Operational scripts
│   ├── setup/                    # Initial setup scripts
│   ├── maintenance/              # Maintenance and housekeeping
│   ├── deployment/               # Deployment automation
│   │
│   └── README.md                 # Scripts guide
│
├── tooling/                       # Lab utilities and tools
│   ├── automation/               # Task automation
│   ├── diagnostics/              # Debugging and profiling tools
│   ├── benchmarking/             # Performance testing
│   │
│   └── README.md                 # Tooling guide
│
├── .gitignore                     # Git ignore rules
├── CONTRIBUTING.md                # Contribution guidelines
├── PROJECT_STRUCTURE.md           # This file
├── QUICKSTART.md                  # Quick start guide
└── README.md                      # Main project README

```

---

## Directory Purpose Summary

### Top-Level Directories

| Directory | Purpose | Read | Write | Version Control |
|-----------|---------|------|-------|-----------------|
| `.lab/` | Lab metadata and runtime state | Rare | Auto | No (gitignored) |
| `configs/` | Configuration files | Often | When configuring | Yes |
| `docs/` | All documentation | Very Often | When things change | Yes |
| `experiments/` | Experimental work | Often | When experimenting | Yes (excluding data/outputs) |
| `infrastructure/` | Production infrastructure | Often | When deploying | Yes |
| `research/` | External research | Occasionally | When researching | Selective (not large PDFs) |
| `scripts/` | Operational scripts | When needed | When automating | Yes |
| `tooling/` | Lab utilities | When needed | When building tools | Yes |

---

## File Naming Conventions

### Experiments
```
experiments/<category>/YYYYMMDD-descriptive-name/
  ├── README.md              # Experiment overview
  ├── RESULTS.md             # Findings
  ├── setup.sh               # Setup script
  ├── config/                # Configs
  ├── src/                   # Code
  ├── data/                  # Input data (gitignored)
  ├── outputs/               # Results (gitignored)
  └── logs/                  # Logs (gitignored)
```

### Infrastructure Components
```
infrastructure/<category>/<component-type-purpose>/
  ├── README.md              # Component documentation
  ├── config/                # Configuration files
  ├── scripts/               # Component-specific scripts
  └── deploy.sh              # Deployment script
```

### Documentation
```
docs/
  ├── <category>/
  │   ├── UPPERCASE.md       # Primary docs
  │   ├── lowercase.md       # Supporting docs
  │   └── YYYY-MM-DD-decision.md  # Dated decisions
```

### Scripts
```
scripts/<category>/verb-object.sh
```

---

## Key Files Reference

### Entry Points
- [README.md](README.md) - Project overview
- [QUICKSTART.md](QUICKSTART.md) - Getting started guide
- [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute

### Core Documentation
- [docs/architecture/LAB_PHILOSOPHY.md](docs/architecture/LAB_PHILOSOPHY.md) - Operating principles
- [docs/architecture/STANDARDS.md](docs/architecture/STANDARDS.md) - Conventions
- [docs/architecture/OVERVIEW.md](docs/architecture/OVERVIEW.md) - System architecture

### Templates
- [docs/experiments/TEMPLATE.md](docs/experiments/TEMPLATE.md) - Experiment template
- [docs/decisions/TEMPLATE.md](docs/decisions/TEMPLATE.md) - Decision log template
- [docs/runbooks/TEMPLATE.md](docs/runbooks/TEMPLATE.md) - Runbook template

### Indexes
- [docs/experiments/INDEX.md](docs/experiments/INDEX.md) - All experiments
- [docs/hardware/INVENTORY.md](docs/hardware/INVENTORY.md) - Hardware inventory

---

## Navigation Tips

### Finding Files

**By Type**:
```bash
# All experiments
ls experiments/*/

# All decision logs
ls docs/decisions/

# All runbooks
ls docs/runbooks/

# All tools
ls tooling/*/
```

**By Date**:
```bash
# Recent experiments (date prefix sorts chronologically)
ls -lt experiments/*/

# Recent decisions
ls -lt docs/decisions/
```

**By Content**:
```bash
# Search documentation
grep -r "search term" docs/

# Search experiments
grep -r "search term" experiments/
```

### Common Locations

**When you need to...**

- Start a new experiment → `experiments/<category>/`
- Deploy infrastructure → `infrastructure/<category>/`
- Create a tool → `tooling/<category>/`
- Document a decision → `docs/decisions/`
- Write a runbook → `docs/runbooks/`
- Store research → `research/<category>/`
- Add a script → `scripts/<category>/`
- Update architecture → `docs/architecture/`

---

## Growth Patterns

### As Lab Matures

**Early Stage** (Current):
- Few experiments
- Basic infrastructure
- Essential documentation

**Growth Stage**:
- Multiple experiments per category
- Mature infrastructure components
- Comprehensive runbooks
- Rich decision log history

**Mature Stage**:
- Extensive experiment archive
- Production-grade infrastructure
- Deep knowledge base
- Established patterns and practices

### Scaling the Structure

The structure supports growth by:
- **Category-based organization**: Easy to add new experiments within categories
- **Flat hierarchies**: Avoids deeply nested structures
- **Clear separation**: Experiments vs. infrastructure vs. documentation
- **Template-driven**: Consistent structure across new work
- **Index files**: Maintain navigability as content grows

---

## Anti-Patterns to Avoid

### ❌ Random Files at Root
**Don't**: Add miscellaneous files to project root
**Do**: Use appropriate subdirectories

### ❌ Deep Nesting
**Don't**: `experiments/category/subcategory/sub-subcategory/experiment`
**Do**: `experiments/category/experiment` (flat is better)

### ❌ Undocumented Directories
**Don't**: Create directories without README explaining purpose
**Do**: Every major directory has a README.md

### ❌ Mixed Concerns
**Don't**: Put infrastructure code in experiments or vice versa
**Do**: Maintain clear separation of concerns

### ❌ Inconsistent Naming
**Don't**: Mix naming conventions within same category
**Do**: Follow established patterns in STANDARDS.md

---

## Maintenance

### Regular Review
- **Weekly**: Check if new experiments are in INDEX.md
- **Monthly**: Review if directory structure still serves needs
- **Quarterly**: Audit for compliance with conventions

### Evolution
The structure will evolve as lab grows:
- Add new categories if they don't fit existing ones
- Subdivide categories if they become too large
- Update this document when structure changes

---

## Summary

This structure provides:
- ✅ **Clarity**: Clear place for every type of work
- ✅ **Scalability**: Supports growth from single experiments to extensive labs
- ✅ **Navigability**: Easy to find things even as lab grows
- ✅ **Consistency**: Templates and conventions maintain structure
- ✅ **Separation**: Clear boundaries between experiments, infrastructure, and docs

**Remember**: Structure serves the work, not the other way around. Follow conventions when they help, adapt when they don't, and document changes.

---

**Last Updated**: 2026-02-11
**Version**: 1.0

*This structure reflects the current organization of Cascadia Mobile Systems Lab and will evolve as the lab matures.*
