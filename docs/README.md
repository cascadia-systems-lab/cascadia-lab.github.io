# Documentation

Technical documentation, architectural decisions, and operational knowledge for Cascadia AI Systems Lab.

## Purpose

This directory is the central knowledge repository for the lab. It contains architectural designs, infrastructure decisions, experiment findings, operational procedures, and research notes.

## Organization

```
docs/
├── architecture/       # System design, patterns, and lab philosophy
├── hardware/          # Hardware specifications and performance profiles
├── decisions/         # Architectural Decision Records (ADRs)
├── experiments/       # Experiment index, templates, and cross-experiment findings
├── runbooks/          # Operational procedures and troubleshooting guides
└── research-notes/    # External research, papers, and theoretical explorations
```

## Documentation Types

### Architecture
**Location**: `architecture/`

High-level system design, guiding principles, and standards.

Key documents:
- [LAB_PHILOSOPHY.md](architecture/LAB_PHILOSOPHY.md) - Operating principles
- [STANDARDS.md](architecture/STANDARDS.md) - Conventions and best practices
- [OVERVIEW.md](architecture/OVERVIEW.md) - Infrastructure architecture

**When to update**: When fundamental approaches or patterns change

### Hardware
**Location**: `hardware/`

Physical infrastructure specifications and performance characteristics.

Key documents:
- [INVENTORY.md](hardware/INVENTORY.md) - All hardware in the lab

**When to update**: When hardware is added, removed, or reconfigured

### Decisions
**Location**: `decisions/`

Architectural Decision Records documenting significant choices.

File naming: `YYYY-MM-DD-decision-name.md`

**When to create**: For any non-trivial infrastructure or architectural decision

Template: [TEMPLATE.md](decisions/TEMPLATE.md)

### Experiments
**Location**: `experiments/`

Catalog of experiments, findings, and experiment methodology.

Key documents:
- [INDEX.md](experiments/INDEX.md) - Master list of all experiments
- [TEMPLATE.md](experiments/TEMPLATE.md) - Experiment documentation template

**When to update**: When experiments start, complete, or produce notable findings

### Runbooks
**Location**: `runbooks/`

Step-by-step operational procedures for managing infrastructure.

Format: One runbook per component or operational procedure

**When to create**: When deploying new infrastructure components or establishing operational procedures

### Research Notes
**Location**: `research-notes/`

External research, academic papers, vendor documentation, and theoretical explorations relevant to lab work.

**When to create**: When exploring new domains or technologies

## Documentation Standards

### Writing Style
- **Technical and precise**: No marketing fluff, clear technical language
- **Actionable**: Include concrete steps, not just theory
- **Honest**: Document failures, limitations, and trade-offs
- **Structured**: Use consistent formatting and organization

### Markdown Conventions
- Use ATX-style headers (`#` not underlines)
- Include table of contents for long documents
- Use code blocks with language specification
- Include links to related documentation
- Use tables for structured data

### Code Examples
```bash
# Good: Explain what and why
# Install NVIDIA drivers (version 550 for CUDA 12.4 compatibility)
sudo apt install nvidia-driver-550

# Bad: Just the command with no context
sudo apt install nvidia-driver-550
```

### Diagrams
- Use ASCII art for simple diagrams
- Use Mermaid markdown for complex diagrams
- Include source for any external diagrams

## Documentation Workflow

### For New Components
1. Create decision log entry explaining why it's needed
2. Document setup in relevant runbook
3. Update architecture overview if significant
4. Link from related documents

### For Experiments
1. Use experiment template in experiment directory
2. Update experiment index when starting
3. Document findings in RESULTS.md when complete
4. Link from decision logs if findings inform decisions

### For Operational Procedures
1. Create runbook as procedures are established
2. Update based on actual operational experience
3. Include troubleshooting for known issues
4. Link from infrastructure component READMEs

## Maintenance

### Review Schedule
- **Weekly**: Update experiment index
- **Monthly**: Review and update active runbooks
- **Quarterly**: Audit documentation for accuracy and completeness

### Deprecation
When documentation becomes outdated:
1. Mark as `[DEPRECATED]` in title
2. Add deprecation notice at top explaining why
3. Link to replacement documentation
4. Do not delete—historical context is valuable

## Finding Documentation

### By Topic
- Infrastructure setup → `architecture/OVERVIEW.md`, `runbooks/`
- Hardware specs → `hardware/INVENTORY.md`
- Experiment results → `experiments/INDEX.md`
- Design rationale → `decisions/`
- Operational procedures → `runbooks/`
- External research → `research-notes/`

### By Type
- **Why something was chosen**: Decision logs
- **How to set it up**: Runbooks
- **What we learned**: Experiment results
- **How it's designed**: Architecture docs

## Contributing to Documentation

Documentation is as important as code in this lab. When working:

1. **Document as you go**: Don't wait until the end
2. **Update existing docs**: If information changes, update it
3. **Link liberally**: Help readers navigate related content
4. **Be specific**: Vague docs are worse than no docs
5. **Include context**: Explain the "why" not just the "what"

## Documentation Anti-Patterns

### ❌ "TODO: Document this later"
Later rarely comes. Document immediately or schedule it properly.

### ❌ Outdated information without warnings
Update docs when reality changes, or mark them as deprecated.

### ❌ Documentation in random places
Follow the structure. Consistency enables discovery.

### ❌ Assuming reader context
Write for your future self who will forget everything.

## Related Resources

- [Standards & Conventions](architecture/STANDARDS.md) - Full conventions guide
- [Experiment Template](experiments/TEMPLATE.md) - Experiment documentation
- [Decision Template](decisions/TEMPLATE.md) - Decision log format

---

**Note**: Documentation is a living artifact. As the lab evolves, so should these documents. Keeping documentation current is part of infrastructure work, not an optional extra.
