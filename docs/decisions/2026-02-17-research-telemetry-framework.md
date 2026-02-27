# Decision: Adopt Reproducible Research + Systems Telemetry Framework

**Date**: 2026-02-17
**Status**: Accepted
**Deciders**: Cascadia Mobile Systems Lab
**Related**: [RESEARCH_TELEMETRY_FRAMEWORK.md](../architecture/RESEARCH_TELEMETRY_FRAMEWORK.md)

---

## Context

Cascadia Mobile Systems Lab operates on heterogeneous, older hardware. Without structured instrumentation, research tasks executed on the cluster produce outputs that:

1. Cannot be attributed to specific hardware conditions at time of generation
2. Cannot be reproduced because inference parameters and prompt versions are not recorded
3. Cannot be correlated with performance data because telemetry and outputs are in separate systems
4. Cannot be used for meta-analysis because there is no unified data model

Additionally, the lab has an opportunity to study a research question that existing inference benchmarks ignore: **how do hardware constraints (CPU generation, RAM, thermal throttling, quantization level) affect the quality and coherence of model-generated research outputs?**

This question can only be answered with a framework that treats compute conditions as first-class experimental variables, permanently bonded to the outputs they produce.

---

## Decision

Adopt the Reproducible Research + Systems Telemetry Framework (RRSTF) as a core lab subsystem. The framework bonds model-generated methodological outputs with hardware telemetry under a shared `run_id`, stores unified Research Records in PostgreSQL, and exposes meta-analysis capabilities through SQL and Grafana.

**Specifically:**
- Every systems research task generates a Research Record containing both methodological and hardware fields
- A `run_id` UUID is the binding primitive across all telemetry systems (Prometheus, OTEL, Loki, PostgreSQL)
- The Celery + Redis task queue routes tasks to workers by hardware capability tier
- No cross-node tensor sharding; all inference is local to the assigned worker
- Reproducibility is enforced through pinned model tags, versioned prompts, fixed seeds, and environment hashing

---

## Options Considered

### Option 1: Ad-hoc logging with manual correlation (rejected)

**Description**: Run research tasks manually, capture outputs in files, correlate with system monitoring dashboards manually.

**Pros**: Zero infrastructure cost; immediate start

**Cons**: Not reproducible at scale; correlation is manual and error-prone; no unified schema; impossible to query across runs; produces no publishable data

**Risk**: High — produces no durable research value

---

### Option 2: Existing MLflow or W&B experiment tracking (rejected)

**Description**: Use MLflow or Weights & Biases to track research run parameters and outputs.

**Pros**: Mature tooling; good UI; established experiment tracking conventions

**Cons**: Designed for training runs, not research pipelines; no schema for methodological fields (hypotheses, evidence, self-critique); hardware telemetry integration is not native; W&B is cloud-hosted (violates self-hosting principle); neither provides the unified schema needed for meta-analysis of hardware vs quality

**Risk**: Medium — would work partially but require significant workarounds

---

### Option 3: Adopt RRSTF as designed (selected)

**Description**: Build a purpose-designed framework with a Research Record schema, telemetry stack, research harness, and task queue purpose-built for the lab's requirements.

**Pros**:
- Schema covers both methodological and hardware fields in a unified document
- `run_id` binding enables cross-system correlation without manual work
- SQL meta-analysis queries enable novel hardware vs quality research
- Self-hosted, reproducible, and auditable
- Grows with the lab across all four implementation phases
- Enables publishable experimental results

**Cons**:
- Higher initial implementation effort than ad-hoc approach
- Requires Controller Node infrastructure (Prometheus, PostgreSQL, Redis, Grafana)
- Custom harness code must be maintained

**Risk**: Medium — implementation complexity is real but manageable across phases

---

## Rationale

Option 3 is the only approach that produces durable research value aligned with the lab's core mission. The lab's distinguishing contribution is its treatment of hardware constraints as experimental variables—this is only possible with a framework that explicitly captures and preserves those variables alongside outputs.

The ad-hoc approach (Option 1) produces ephemeral outputs. The existing tooling approach (Option 2) produces outputs that are structurally incompatible with the lab's research questions. Option 3 is the only path to the lab's stated goals.

The phased implementation plan (Phase 1: single-node prototype) significantly reduces initial risk by deferring multi-node complexity until the core Research Record pipeline is validated.

---

## Consequences

### Positive
- Every research run produces a permanently auditable, reproducible artifact
- Meta-analysis of hardware vs output quality becomes possible
- Lab outputs are citable and reproducible by external parties given hardware disclosure
- Telemetry infrastructure serves double duty: operational monitoring AND research data collection
- The framework grows with the lab; Phase 1 can start on a single machine today

### Negative / Trade-offs
- Controller Node must be provisioned before multi-node operation
- The research harness is lab-specific code that must be maintained
- Celery + Redis adds operational complexity vs. simple cron scripts
- PostgreSQL must be backed up; it becomes a critical data store

### Dependencies Introduced
- Redis (task queue broker)
- Celery (distributed task queue)
- PostgreSQL (research record store)
- Prometheus + Grafana + Loki (observability)
- OpenTelemetry (tracing)
- Ollama (inference backend)

### What This Decision Does NOT Decide
- Which specific Ollama models to run on each tier (separate decision per node provisioning)
- Whether to use k3s or Nomad in Phase 3 (deferred)
- Physical network topology design (separate decision)
- Storage architecture for model weights and datasets (separate decision)

---

## Implementation Plan

1. **Phase 1** (Single-node): Research harness + SQLite + TelemetryCollector + node_exporter. Target: first Research Record with hardware fields populated.

2. **Phase 2** (Multi-node): Controller Node provisioned, PostgreSQL, Redis, Prometheus, Grafana, Loki. Workers containerized. Target: run_id visible in Grafana dashboard.

3. **Phase 3** (Automation): Evaluator pass, meta-analysis queries, batch execution. Target: statistically significant hardware vs quality correlation.

4. **Phase 4** (Continuous): Scheduled campaigns, drift detection, publication exports.

---

## Validation Criteria

- [ ] Research Record JSON Schema (`research_record_v1.json`) validates a real output
- [ ] `run_id` appears as a label in Prometheus metrics for a completed run
- [ ] SQL query returns tokens_per_second grouped by CPU model with > 1 row
- [ ] Grafana Run Inspector shows hardware metrics for a specific `run_id`
- [ ] Same question + same config produces structurally identical record on repeated execution

---

## Review Date

**First review**: After Phase 1 complete (first Research Record written with full schema)
**Second review**: After Phase 2 complete (multi-node runs visible in Grafana)

---

## References

- [RESEARCH_TELEMETRY_FRAMEWORK.md](../architecture/RESEARCH_TELEMETRY_FRAMEWORK.md) — Full design document
- [Research Record Schema v1](../../infrastructure/research-harness/schemas/research_record_v1.json)
- [Experiment Index](../experiments/INDEX.md) — Planned experiments enabled by this framework

---

*This decision establishes the RRSTF as a core Cascadia Mobile Systems Lab subsystem.*
*Decision made: 2026-02-17*
