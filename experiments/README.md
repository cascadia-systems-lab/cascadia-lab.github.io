# Experiments

This directory contains all experimental work conducted in Cascadia Mobile Systems Lab.

## Purpose

Experiments are structured investigations into infrastructure behavior, performance characteristics, feasibility of approaches, or validation of hypotheses. Each experiment follows a documented methodology and produces findings that inform infrastructure decisions.

## Organization

Experiments are organized by category:

- **gpu-acceleration/** - GPU performance, CUDA optimization, memory management
- **model-serving/** - Inference engines, serving architectures, API design
- **data-pipelines/** - ETL, data ingestion, preprocessing, orchestration
- **storage-systems/** - Storage architecture, filesystem performance, tiering
- **virtualization/** - Containerization, GPU passthrough, resource isolation
- **networking/** - Network topology, distributed communication, optimization

## Experiment Naming

Format: `<YYYYMMDD>-<descriptive-name>`

Examples:
- `20260211-vllm-inference-baseline`
- `20260215-nvme-sequential-read-performance`
- `20260220-k8s-gpu-scheduling-test`

## Structure

Each experiment follows this structure:

```
<experiment-name>/
├── README.md            # Experiment overview and methodology
├── RESULTS.md           # Findings and analysis
├── setup.sh             # Reproducible setup script
├── config/              # Experiment-specific configurations
├── src/                 # Source code (if applicable)
├── data/                # Input data (gitignored if large)
├── outputs/             # Results and artifacts (gitignored)
└── logs/                # Runtime logs (gitignored)
```

## Creating a New Experiment

1. Create experiment directory:
   ```bash
   mkdir -p experiments/<category>/<YYYYMMDD-experiment-name>
   cd experiments/<category>/<YYYYMMDD-experiment-name>
   ```

2. Copy experiment template:
   ```bash
   cp ../../../docs/experiments/TEMPLATE.md README.md
   ```

3. Fill in README.md with:
   - Objective and hypothesis
   - Methodology and environment
   - Setup instructions
   - Expected outcomes

4. Update experiment index:
   - Add entry to `docs/experiments/INDEX.md`

5. Conduct experiment and document findings in RESULTS.md

## Experiment Lifecycle

1. **Proposed**: Directory created, README drafted
2. **In Progress**: Actively running and collecting data
3. **Completed**: Results documented in RESULTS.md
4. **Archived**: Marked with `[ARCHIVED]` prefix if superseded

## Best Practices

- **Document as you go**: Don't wait until the end to write findings
- **Capture failures**: Failed experiments are valuable learning opportunities
- **Be specific**: Vague objectives lead to vague results
- **Include raw data**: Link to or embed actual measurements
- **Follow the template**: Consistency enables comparison across experiments

## Related Documentation

- [Experiment Template](../docs/experiments/TEMPLATE.md)
- [Experiment Index](../docs/experiments/INDEX.md)
- [Standards & Conventions](../docs/architecture/STANDARDS.md)

---

**Note**: Experiments may contain work-in-progress code that is not production-ready. Always consult the experiment README before reusing code or configurations.
