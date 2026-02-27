# Reproducible Research + Systems Telemetry Framework

**Cascadia Mobile Systems Lab — Formal Systems Design Proposal**

**Document Version**: 1.0
**Status**: Accepted
**Date**: 2026-02-17
**Supersedes**: N/A
**Related Decisions**: [2026-02-17-research-telemetry-framework.md](../decisions/2026-02-17-research-telemetry-framework.md)

---

## Abstract

This document specifies the architecture for a Reproducible Research and Systems Telemetry Framework (RRSTF) for Cascadia Mobile Systems Lab. The framework transforms a heterogeneous cluster of older hardware into a research instrument that produces auditable, reproducible systems research artifacts while simultaneously treating hardware behavior as first-class experimental metadata. Every model-generated research output is permanently bonded to the hardware telemetry recorded during its generation. The result is a system capable of meta-analysis at the intersection of compute conditions and epistemic output quality.

---

## Table of Contents

1. [Conceptual Architecture](#1-conceptual-architecture)
2. [Research Record Schema](#2-research-record-schema)
3. [Telemetry Stack Design](#3-telemetry-stack-design)
4. [Research Harness Design](#4-research-harness-design)
5. [Scheduling and Orchestration](#5-scheduling-and-orchestration)
6. [Meta-Analysis Capabilities](#6-meta-analysis-capabilities)
7. [Implementation Phases](#7-implementation-phases)
8. [Philosophical Framing](#8-philosophical-framing)
9. [Appendix: File Inventory](#appendix-file-inventory)

---

## 1. Conceptual Architecture

### 1.1 System Overview

The RRSTF is structured as a three-tier distributed system: a **Controller Node** that orchestrates research tasks and aggregates persistent records, **Worker Nodes** that execute inference and capture telemetry, and a **Storage + Observability Layer** that makes all collected data queryable and cross-correlated.

The binding primitive that unifies all layers is the `run_id`: a UUID generated at task inception that is injected into every telemetry span, every Prometheus label, every log line, and every field of the Research Record. This single identifier is the thread that allows reconstruction of the full experimental context for any given model output.

```
┌─────────────────────────────────────────────────────────────────────┐
│                        CONTROLLER NODE                               │
│                                                                       │
│  ┌─────────────┐  ┌──────────────┐  ┌───────────┐  ┌─────────────┐ │
│  │  Task Queue │  │  Prometheus  │  │  Grafana  │  │ PostgreSQL  │ │
│  │  (Redis +   │  │   Server     │  │           │  │             │ │
│  │   Celery)   │  │   :9090      │  │   :3000   │  │   :5432     │ │
│  └──────┬──────┘  └──────┬───────┘  └─────┬─────┘  └──────┬──────┘ │
│         │                │                │               │         │
│  ┌──────┴──────────────────────────────────────────────────┴──────┐ │
│  │                   OTEL Collector  :4317                        │ │
│  └─────────────────────────────────────────────────────────────────┘ │
└───────────────────────────────┬─────────────────────────────────────┘
                                │  Gigabit Ethernet
        ┌───────────────────────┼──────────────────────┐
        │                       │                      │
┌───────┴────────┐    ┌─────────┴──────┐    ┌──────────┴─────┐
│   WORKER A     │    │   WORKER B     │    │   WORKER C     │
│                │    │                │    │                │
│ ┌────────────┐ │    │ ┌────────────┐ │    │ ┌────────────┐ │
│ │   Ollama   │ │    │ │   Ollama   │ │    │ │   Ollama   │ │
│ │  :11434    │ │    │ │  :11434    │ │    │ │  :11434    │ │
│ └────────────┘ │    │ └────────────┘ │    │ └────────────┘ │
│ ┌────────────┐ │    │ ┌────────────┐ │    │ ┌────────────┐ │
│ │  Research  │ │    │ │  Research  │ │    │ │  Research  │ │
│ │  Harness   │ │    │ │  Harness   │ │    │ │  Harness   │ │
│ └────────────┘ │    │ └────────────┘ │    │ └────────────┘ │
│ ┌────────────┐ │    │ ┌────────────┐ │    │ ┌────────────┐ │
│ │node_export │ │    │ │node_export │ │    │ │node_export │ │
│ │  er :9100  │ │    │ │  er :9100  │ │    │ │  er :9100  │ │
│ └────────────┘ │    │ └────────────┘ │    │ └────────────┘ │
│ ┌────────────┐ │    │ ┌────────────┐ │    │ ┌────────────┐ │
│ │OTEL Agent  │ │    │ │OTEL Agent  │ │    │ │OTEL Agent  │ │
│ │  :4317     │ │    │ │  :4317     │ │    │ │  :4317     │ │
│ └────────────┘ │    │ └────────────┘ │    │ └────────────┘ │
└────────────────┘    └────────────────┘    └────────────────┘
```

### 1.2 Controller Node Responsibilities

The Controller Node is designated as a stable, always-on machine (even if modest). It is the cluster's administrative brain and data center.

**Primary functions:**
- Maintain the task queue (Redis) and broker Celery workers
- Host Prometheus server and scrape all `node_exporter` endpoints cluster-wide
- Host Grafana for cluster-wide observability and run-level dashboards
- Host the OpenTelemetry Collector that receives spans from all worker agents
- Maintain PostgreSQL as the permanent Research Record store
- Host the Loki log aggregation server
- Expose a research submission API (FastAPI) for manual or automated task ingestion
- Manage node capability registry (hardware profiles for dispatch routing)

**The Controller does NOT:**
- Run model inference (reserved for Workers)
- Perform research synthesis (reserved for Workers)
- Store large model weights (stored locally on Workers)

### 1.3 Worker Node Responsibilities

Worker Nodes are the inference and research execution layer. They are heterogeneous: different CPUs, RAM, and optional GPU presence. This heterogeneity is a feature, not a defect—it is the experimental parameter space being studied.

**Primary functions:**
- Register hardware capability profile at startup with the Controller
- Receive and execute research tasks from the Celery queue
- Host Ollama for local model inference (no cross-node model sharding)
- Execute the Research Harness pipeline on assigned tasks
- Export `node_exporter` metrics continuously
- Emit OpenTelemetry spans tagged with `run_id`
- Forward logs to Loki via Promtail
- Write completed Research Records back to the Controller's PostgreSQL
- Report task completion and performance summary to Controller

**Worker capability classes** (declared at registration):

| Tier | RAM | Capable Models | Label |
|------|-----|----------------|-------|
| micro | < 8 GB | 1B–3B models | `tier=micro` |
| small | 8–16 GB | 3B–7B models | `tier=small` |
| medium | 16–32 GB | 7B–13B models | `tier=medium` |
| large | 32+ GB | 13B–70B models | `tier=large` |
| gpu | any + GPU | Accelerated inference | `gpu=true` |

### 1.4 Research Task Flow

```
[User / Scheduler]
    │
    ▼
[Controller: Research Submission API]
    │ generate run_id (UUID)
    │ record task_created timestamp
    │ select target worker tier from capability registry
    ▼
[Redis Task Queue]
    │ task: {run_id, question, config}
    │ routed to worker tier matching model requirements
    ▼
[Worker: Celery Consumer]
    │
    ├── [1] Telemetry START marker (OTEL span open, Prometheus label set)
    │
    ├── [2] Decompose: LLM generates research plan
    │
    ├── [3] Retrieve: fetch external sources (web, local corpus)
    │       │
    │       └── record source URLs, hashes, timestamps
    │
    ├── [4] Analyze: LLM extracts evidence from retrieved sources
    │
    ├── [5] Synthesize: LLM produces structured synthesis
    │
    ├── [6] Self-Critique: LLM evaluates its own output
    │
    ├── [7] Telemetry STOP marker (OTEL span close, runtime metrics snapshot)
    │
    └── [8] Write Research Record:
            │ Merge methodological output + hardware telemetry
            │ Hash all content fields
            │ Store to PostgreSQL via Controller API
            ▼
[Controller: PostgreSQL Research Record]
    │
    └── [9] Prometheus: retroactively link run_id to hardware metrics
               Grafana: record available for dashboard queries
```

### 1.5 Telemetry Flow

Telemetry flows continuously at two granularities:

**Infrastructure-level (always-on):**
```
node_exporter (9100) → Prometheus scrape (every 15s) → Time-series DB
```

**Run-level (during active research tasks):**
```
Research Harness → OTEL Span {run_id, node_id, phase}
    → OTEL Agent → OTEL Collector (Controller) → Jaeger/Tempo

Research Harness → Python metrics snapshot {peak_mem, cpu_curve, tokens}
    → pushed to PostgreSQL as part of Research Record

Prometheus → run_id label injected via relabeling rules during active tasks
    → allows retroactive query: "give me CPU metrics for run_id X"
```

**Log flow:**
```
All components → structured JSON logs
    → Promtail (per node) → Loki (Controller)
    → Grafana log explorer (filter by run_id field)
```

---

## 2. Research Record Schema

### 2.1 Design Principles

- All fields are stored as a single JSONB document in PostgreSQL for queryability
- Top-level scalar fields are also materialized as indexed columns for performance
- `run_id` is the primary key and foreign key for all related tables
- Content-bearing fields (question, prompt, synthesis) are SHA-256 hashed for integrity
- The schema is versioned to support backward-compatible evolution

### 2.2 PostgreSQL Table Definitions

```sql
-- Core record table
CREATE TABLE research_records (
    run_id          UUID PRIMARY KEY,
    schema_version  TEXT NOT NULL DEFAULT '1.0',
    created_at      TIMESTAMPTZ NOT NULL,
    completed_at    TIMESTAMPTZ,
    node_id         TEXT NOT NULL,
    model_name      TEXT NOT NULL,
    question_hash   TEXT NOT NULL,  -- SHA-256
    status          TEXT NOT NULL DEFAULT 'pending',
    -- status: pending, running, completed, failed, cancelled

    -- Materialized scalars for indexed queries
    tokens_per_second   FLOAT,
    memory_peak_mb      BIGINT,
    duration_seconds    FLOAT,
    cpu_model           TEXT,
    ram_gb              INTEGER,
    has_gpu             BOOLEAN DEFAULT FALSE,
    quantization        TEXT,

    -- Full record as JSONB
    record              JSONB NOT NULL,

    -- Evaluation (populated post-hoc by evaluator pass)
    evaluation          JSONB
);

CREATE INDEX idx_rr_node_id       ON research_records (node_id);
CREATE INDEX idx_rr_model_name    ON research_records (model_name);
CREATE INDEX idx_rr_created_at    ON research_records (created_at);
CREATE INDEX idx_rr_tps           ON research_records (tokens_per_second);
CREATE INDEX idx_rr_status        ON research_records (status);
CREATE INDEX idx_rr_record_gin    ON research_records USING gin (record);

-- Node registry
CREATE TABLE nodes (
    node_id         TEXT PRIMARY KEY,
    hostname        TEXT NOT NULL,
    registered_at   TIMESTAMPTZ NOT NULL,
    last_seen_at    TIMESTAMPTZ,
    hardware_profile JSONB NOT NULL,
    tier            TEXT NOT NULL,
    active          BOOLEAN DEFAULT TRUE
);

-- Task queue mirror (for audit trail independent of Redis)
CREATE TABLE research_tasks (
    run_id          UUID PRIMARY KEY REFERENCES research_records(run_id),
    submitted_at    TIMESTAMPTZ NOT NULL,
    assigned_at     TIMESTAMPTZ,
    node_id         TEXT,
    priority        INTEGER DEFAULT 0,
    retry_count     INTEGER DEFAULT 0,
    error_detail    TEXT
);
```

### 2.3 Full Research Record Schema (JSON)

The following is the canonical JSON schema for a Research Record. All fields are expected in completed records; partial records are valid for in-progress or failed runs.

```json
{
  "run_id": "550e8400-e29b-41d4-a716-446655440000",
  "schema_version": "1.0",
  "created_at": "2026-02-17T14:30:00.000Z",
  "completed_at": "2026-02-17T14:31:45.312Z",
  "status": "completed",

  "research": {
    "question": "What are the energy efficiency tradeoffs of running quantized LLMs on CPU-only hardware compared to GPU inference?",
    "question_hash": "sha256:a3f1c7d2...",

    "hypotheses": [
      "CPU inference with Q4 quantization will achieve acceptable throughput for sub-7B models on 16GB RAM",
      "Energy-per-token on CPU will exceed GPU by a factor of 3-5x for equivalent model sizes",
      "Thermal throttling on older hardware will reduce throughput by >20% on sustained runs"
    ],

    "plan": [
      {
        "step": 1,
        "phase": "retrieval",
        "description": "Find recent benchmarks comparing CPU vs GPU inference efficiency",
        "search_query": "LLM CPU GPU inference efficiency energy benchmark 2024 2025"
      },
      {
        "step": 2,
        "phase": "retrieval",
        "description": "Locate GGUF/llama.cpp CPU benchmarking data for Q4 quantized models"
      },
      {
        "step": 3,
        "phase": "analysis",
        "description": "Extract and tabulate throughput and energy metrics by hardware class"
      },
      {
        "step": 4,
        "phase": "synthesis",
        "description": "Synthesize tradeoff analysis and situate within lab constraints"
      }
    ],

    "retrieval": {
      "strategy": "web_search_plus_local_corpus",
      "queries_issued": 4,
      "sources": [
        {
          "source_id": "src-001",
          "type": "web",
          "url": "https://example.com/llm-cpu-benchmark-2025",
          "title": "LLM CPU Inference Benchmark Study 2025",
          "retrieved_at": "2026-02-17T14:30:12.000Z",
          "content_hash": "sha256:b7e2a9c1...",
          "relevance_score": 0.92
        },
        {
          "source_id": "src-002",
          "type": "local_corpus",
          "path": "research/papers/2025-cpu-llm-energy.pdf",
          "title": "Energy Consumption in CPU-Based LLM Inference",
          "retrieved_at": "2026-02-17T14:30:18.000Z",
          "content_hash": "sha256:f3c8d7e1...",
          "relevance_score": 0.88
        }
      ]
    },

    "evidence": [
      {
        "source_id": "src-001",
        "claim": "Q4 quantized Mistral-7B achieves 8-12 tokens/s on modern 8-core CPU",
        "confidence": "high",
        "quote": "Our benchmarks show 10.4 tok/s mean throughput on AMD Ryzen 5 7600..."
      },
      {
        "source_id": "src-002",
        "claim": "CPU inference consumes approximately 45W vs 120W for equivalent GPU inference",
        "confidence": "medium",
        "quote": "Power measurements at the socket level indicate..."
      }
    ],

    "synthesis": "Based on retrieved evidence, CPU inference with Q4 quantization represents a viable approach for Cascadia Mobile Systems Lab workloads under 7B parameters. While per-token latency is higher than GPU (approximately 5x), the total energy consumption per session is within 20% of GPU inference when idle power draw is included. Thermal throttling remains a significant concern on older hardware with inadequate cooling...",

    "limitations": [
      "Retrieved benchmarks use newer CPU generations than lab hardware; results may not directly apply",
      "Energy measurements in sources used professional power monitoring equipment not available in current lab setup",
      "No direct measurements available for the specific hardware combinations present in the Cascadia Mobile Systems Lab"
    ],

    "self_critique": {
      "assessment": "The synthesis is grounded but extrapolates from hardware that differs from lab inventory. The claim about energy efficiency is appropriately hedged but the 20% figure needs direct validation. The plan was followed as designed; the retrieval strategy successfully found relevant sources. Confidence: medium-high for qualitative conclusions, low for specific numeric claims until lab validation.",
      "confidence_overall": 0.72,
      "gaps_identified": [
        "No direct measurement of lab hardware energy consumption",
        "Thermal throttling effect on older hardware not quantified"
      ]
    }
  },

  "model": {
    "name": "mistral",
    "version": "0.3",
    "tag": "mistral:7b-instruct-q4_K_M",
    "backend": "ollama",
    "quantization": "Q4_K_M",
    "parameter_count_b": 7.2,
    "context_length": 32768,

    "parameters": {
      "temperature": 0.0,
      "top_p": 0.9,
      "top_k": 40,
      "seed": 42,
      "max_tokens": 4096,
      "num_ctx": 4096,
      "repeat_penalty": 1.1
    },

    "prompts": {
      "system_prompt_hash": "sha256:d9e3f2a7...",
      "prompt_template": "cascadia_research_v1",
      "prompt_hash": "sha256:c5a8b3e9...",
      "prompt_token_count": 412
    },

    "tool_calls": [
      {
        "tool": "web_search",
        "call_id": "tc-001",
        "input": {"query": "LLM CPU GPU inference efficiency energy benchmark 2024 2025"},
        "output_length_chars": 2841,
        "duration_ms": 1203
      }
    ]
  },

  "node": {
    "node_id": "worker-02",
    "hostname": "cascadia-worker-02",
    "tier": "small",
    "os": "Ubuntu Server 24.04 LTS",
    "kernel": "6.8.0-47-generic",
    "architecture": "x86_64",
    "cpu_model": "Intel Core i5-8400",
    "cpu_generation": "Coffee Lake",
    "cpu_cores_physical": 6,
    "cpu_cores_logical": 6,
    "cpu_base_clock_mhz": 2800,
    "cpu_boost_clock_mhz": 4000,
    "ram_gb": 16,
    "ram_type": "DDR4",
    "ram_speed_mhz": 2666,
    "ram_channels": 2,
    "disk_type": "SSD",
    "disk_model": "Samsung 870 EVO",
    "disk_capacity_gb": 500,
    "gpu": null,
    "network_interface": "eth0",
    "network_speed_gbps": 1.0
  },

  "runtime": {
    "start_time": "2026-02-17T14:30:00.000Z",
    "end_time": "2026-02-17T14:31:45.312Z",
    "duration_seconds": 105.312,
    "wall_clock_seconds": 105.312,
    "inference_seconds": 87.4,
    "retrieval_seconds": 14.2,
    "overhead_seconds": 3.7,

    "tokens": {
      "generated": 1876,
      "per_second": 21.47,
      "prompt_tokens": 412,
      "total_tokens": 2288
    },

    "memory": {
      "peak_rss_mb": 9216,
      "peak_vms_mb": 11264,
      "model_footprint_mb": 4200,
      "swap_used_mb": 0,
      "swap_activity_detected": false,
      "oom_kill_risk": "low"
    },

    "cpu": {
      "utilization_curve": [0.12, 0.89, 0.94, 0.96, 0.91, 0.88, 0.93, 0.95, 0.91, 0.14],
      "curve_interval_seconds": 10,
      "mean_utilization": 0.76,
      "peak_utilization": 0.96,
      "idle_during_retrieval": true
    },

    "thermal": {
      "peak_cpu_temp_c": 81,
      "throttling_detected": true,
      "throttling_duration_seconds": 12.3,
      "throttling_temp_threshold_c": 80,
      "fan_speed_rpm": null
    },

    "network": {
      "bytes_sent": 2048,
      "bytes_received": 154624,
      "latency_to_controller_ms": 1.4
    },

    "energy": {
      "method": "proxy",
      "proxy_basis": "cpu_utilization_x_tdp",
      "cpu_tdp_w": 65,
      "estimated_joules": 2847,
      "confidence": "low",
      "note": "Proxy estimate only. Physical measurement unavailable on this node."
    }
  },

  "reproducibility": {
    "harness_version": "0.3.1",
    "harness_commit": "a7f3d2e1",
    "config_hash": "sha256:e4b9c2a8...",
    "ollama_version": "0.5.1",
    "python_version": "3.12.3",
    "environment_hash": "sha256:c7d3e9f2...",
    "deterministic": true,
    "seed_used": 42
  }
}
```

### 2.4 Schema Validation

A JSON Schema file enforcing this structure is maintained at:
```
infrastructure/research-harness/schemas/research_record_v1.json
```

All records are validated against this schema before insertion into PostgreSQL. Invalid records are stored in a `failed_records` table with the validation error attached.

---

## 3. Telemetry Stack Design

### 3.1 Component Overview

The telemetry stack operates in two modes simultaneously: **passive infrastructure monitoring** (always-on, 15-second scrape interval) and **active run tracing** (triggered by research task lifecycle).

**Stack components:**

| Component | Location | Port | Purpose |
|-----------|----------|------|---------|
| node_exporter | Every node | 9100 | Host metrics (CPU, memory, disk, network, temperature) |
| Prometheus | Controller | 9090 | Metrics aggregation and time-series storage |
| Grafana | Controller | 3000 | Dashboards and visualization |
| OTEL Agent | Every node | 4317/4318 | Span collection and forward |
| OTEL Collector | Controller | 4317/4318 | Span aggregation and routing |
| Jaeger/Tempo | Controller | 16686/3200 | Distributed trace storage |
| Promtail | Every node | - | Log shipping agent |
| Loki | Controller | 3100 | Log aggregation |

### 3.2 node_exporter Configuration

Standard deployment with the following non-default collectors enabled:

```yaml
# /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus node_exporter

[Service]
ExecStart=/usr/local/bin/node_exporter \
  --collector.cpu \
  --collector.cpufreq \
  --collector.diskstats \
  --collector.filesystem \
  --collector.meminfo \
  --collector.netdev \
  --collector.netstat \
  --collector.thermal_zone \        # CPU temperature via /sys/class/thermal
  --collector.hwmon \               # Hardware sensor monitoring
  --collector.pressure \            # Linux pressure stall information (PSI)
  --no-collector.arp \
  --no-collector.bcache \
  --no-collector.bonding \
  --web.listen-address=":9100"
```

**Why PSI (Pressure Stall Information):** On older hardware, memory and CPU pressure stalls are a direct indicator of resource saturation during inference. PSI metrics reveal when the kernel is blocking processes due to resource pressure before swap activity or OOM conditions occur—a critical signal for understanding throughput degradation.

### 3.3 Prometheus Configuration

```yaml
# /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

  external_labels:
    cluster: 'cascadia-mobile-lab'

scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets:
          - 'cascadia-controller:9100'
          - 'cascadia-worker-01:9100'
          - 'cascadia-worker-02:9100'
          - 'cascadia-worker-03:9100'
    relabel_configs:
      - source_labels: [__address__]
        regex: '([^:]+).*'
        target_label: node_id
        replacement: '$1'

  - job_name: 'ollama'
    static_configs:
      - targets:
          - 'cascadia-worker-01:11434'
          - 'cascadia-worker-02:11434'
          - 'cascadia-worker-03:11434'
    metrics_path: '/api/metrics'

  - job_name: 'research_harness'
    static_configs:
      - targets:
          - 'cascadia-worker-01:9091'   # Per-worker Prometheus client
          - 'cascadia-worker-02:9091'
          - 'cascadia-worker-03:9091'
```

### 3.4 Run ID Injection Into Prometheus

The Research Harness exposes a small Prometheus client on `:9091` that emits run-scoped metrics during active tasks. This allows Prometheus to capture metrics labeled with the active `run_id`:

```python
# In Research Harness: harness/telemetry/prometheus_client.py

from prometheus_client import Gauge, Counter, start_http_server

ACTIVE_RUN_ID   = Gauge('lab_harness_active_run_id_info', 'Active run metadata',
                        ['run_id', 'question_hash', 'model', 'node_id'])
TOKENS_TOTAL    = Counter('lab_harness_tokens_total', 'Tokens generated', ['run_id'])
TOKENS_PER_SEC  = Gauge('lab_harness_tokens_per_second', 'Current token rate', ['run_id'])
PHASE_ACTIVE    = Gauge('lab_harness_phase_active', 'Current research phase',
                        ['run_id', 'phase'])
MEMORY_PEAK_MB  = Gauge('lab_harness_memory_peak_mb', 'Peak RSS', ['run_id'])

class RunMetrics:
    def __init__(self, run_id: str, question_hash: str, model: str, node_id: str):
        self.run_id = run_id
        ACTIVE_RUN_ID.labels(run_id, question_hash, model, node_id).set(1)

    def set_phase(self, phase: str):
        for p in ['decompose', 'retrieve', 'analyze', 'synthesize', 'critique']:
            PHASE_ACTIVE.labels(self.run_id, p).set(1 if p == phase else 0)

    def record_tokens(self, count: int, rate: float):
        TOKENS_TOTAL.labels(self.run_id).inc(count)
        TOKENS_PER_SEC.labels(self.run_id).set(rate)

    def record_memory(self, peak_mb: int):
        MEMORY_PEAK_MB.labels(self.run_id).set(peak_mb)

    def clear(self):
        ACTIVE_RUN_ID.labels(self.run_id, ...).set(0)
```

Because Prometheus scrapes these gauges every 15 seconds with `run_id` as a label, any time-series metric in Prometheus can be filtered by `run_id`. A PromQL query for a specific run:

```promql
# CPU utilization for a specific research run (approximated by time range from record)
avg by (node_id) (
  rate(node_cpu_seconds_total{mode!="idle", node_id="cascadia-worker-02"}[1m])
)
```

Combined with the Research Record's `start_time` and `end_time`, this enables exact hardware metric reconstruction for any run.

### 3.5 OpenTelemetry Tracing

Every research pipeline phase is wrapped in an OTEL span. Spans carry `run_id` as a top-level attribute, enabling trace-level correlation.

```python
# harness/telemetry/tracing.py

from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter

def setup_tracing(node_id: str, controller_host: str):
    provider = TracerProvider(
        resource=Resource.create({"service.name": "research-harness", "node.id": node_id})
    )
    exporter = OTLPSpanExporter(endpoint=f"http://{controller_host}:4317")
    provider.add_span_processor(BatchSpanProcessor(exporter))
    trace.set_tracer_provider(provider)

tracer = trace.get_tracer("cascadia.research.harness")

def trace_phase(run_id: str, phase: str):
    """Decorator to trace a research pipeline phase."""
    def decorator(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            with tracer.start_as_current_span(f"research.{phase}") as span:
                span.set_attribute("run_id", run_id)
                span.set_attribute("phase", phase)
                span.set_attribute("node_id", os.environ["NODE_ID"])
                return fn(*args, **kwargs)
        return wrapper
    return decorator
```

**OTEL Span Hierarchy per Research Run:**

```
research.run [run_id=..., node_id=..., model=...]
  ├── research.decompose     [tokens=180, duration=8.2s]
  ├── research.retrieve      [sources=3, duration=14.1s]
  │   ├── retrieve.web_search [query=..., duration=1.2s]
  │   ├── retrieve.web_search [query=..., duration=0.9s]
  │   └── retrieve.corpus_search [path=..., duration=0.3s]
  ├── research.analyze       [tokens=420, duration=22.1s]
  ├── research.synthesize    [tokens=890, duration=45.3s]
  ├── research.critique      [tokens=386, duration=17.2s]
  └── research.record_write  [duration=0.4s]
```

### 3.6 Grafana Dashboard Design

**Dashboard 1: Cluster Overview**
- Active nodes (up/down)
- Current active research runs (by node)
- Cluster-wide CPU and memory heatmap
- Aggregate tokens/second over time
- Task queue depth

**Dashboard 2: Research Run Inspector**
- Filter variable: `run_id` (dropdown from PostgreSQL data source)
- CPU utilization timeline for the run (shaded start/end from record)
- Memory usage over time (with peak annotation)
- Thermal readings with throttling event markers
- Tokens/second over time (with phase boundaries)
- Network I/O during retrieval phases
- Side panel: Research Record metadata (question, model, outcome)

**Dashboard 3: Node Performance Comparison**
- Tokens/second per node, grouped by model
- Memory pressure stall index per node
- Temperature vs throughput correlation
- Disk I/O during model load operations

**Dashboard 4: Hardware-Aware Research Analytics**
- Tokens/second by CPU generation (Coffee Lake, Skylake, Ryzen 3000, etc.)
- Run duration by RAM size tier
- Throttling frequency by node
- Quantization level vs throughput matrix

### 3.7 Loki Log Configuration

```yaml
# promtail-config.yaml (per worker node)
server:
  http_listen_port: 9080
  grpc_listen_port: 0

clients:
  - url: http://cascadia-controller:3100/loki/api/v1/push

scrape_configs:
  - job_name: research_harness
    static_configs:
      - targets: [localhost]
        labels:
          job: research-harness
          node_id: cascadia-worker-02
          __path__: /var/log/cascadia/harness/*.log
    pipeline_stages:
      - json:
          expressions:
            run_id: run_id
            level: level
            phase: phase
      - labels:
          run_id:
          level:
          phase:
```

All logs are emitted as structured JSON with `run_id` in every line, enabling Loki label-based filtering:

```logql
{job="research-harness", run_id="550e8400-e29b-41d4-a716-446655440000"}
  | json
  | level = "ERROR"
```

---

## 4. Research Harness Design

### 4.1 Design Philosophy

The Research Harness treats model-assisted research as a scientific pipeline with discrete, auditable stages. Each stage is individually traced, timed, and its output is preserved. The harness does not attempt to produce "good" outputs—it attempts to produce **reproducible** outputs under controlled conditions. Variation in output quality across hardware conditions and model configurations is the signal being studied.

### 4.2 Core Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      Research Harness                            │
│                                                                   │
│  Input: ResearchTask(run_id, question, config)                   │
│                                                                   │
│  ┌────────────┐    ┌───────────┐    ┌───────────┐               │
│  │   Phase 1  │    │  Phase 2  │    │  Phase 3  │               │
│  │  Decompose │───▶│  Retrieve │───▶│  Analyze  │               │
│  │            │    │           │    │           │               │
│  │ LLM → Plan │    │ Web+Corpus│    │ LLM →     │               │
│  │ + Hypo-    │    │ → Sources │    │ Evidence  │               │
│  │ theses     │    │           │    │ Table     │               │
│  └────────────┘    └───────────┘    └─────┬─────┘               │
│                                           │                       │
│  ┌────────────┐    ┌───────────┐          │                       │
│  │   Phase 6  │    │  Phase 5  │    ┌─────▼─────┐               │
│  │   Record   │◀───│ Critique  │◀───│  Phase 4  │               │
│  │   Write    │    │           │    │ Synthesize│               │
│  │            │    │ LLM self- │    │           │               │
│  │ Merge +    │    │ evaluation│    │ LLM →     │               │
│  │ Hash +     │    │           │    │ Synthesis │               │
│  │ Store      │    │           │    │           │               │
│  └────────────┘    └───────────┘    └───────────┘               │
│                                                                   │
│  Throughout: TelemetryCollector samples every 1s                 │
│  Throughout: OTEL spans open/close around each phase             │
│  Throughout: Prometheus metrics updated                           │
└─────────────────────────────────────────────────────────────────┘
```

### 4.3 Core Module Structure

```
infrastructure/research-harness/
├── harness/
│   ├── __init__.py
│   ├── pipeline.py           # Main ResearchPipeline class
│   ├── task.py               # ResearchTask and ResearchConfig dataclasses
│   ├── record.py             # ResearchRecord builder and serializer
│   ├── phases/
│   │   ├── decompose.py      # Phase 1: question → plan + hypotheses
│   │   ├── retrieve.py       # Phase 2: plan → sources
│   │   ├── analyze.py        # Phase 3: sources → evidence
│   │   ├── synthesize.py     # Phase 4: evidence → synthesis
│   │   └── critique.py       # Phase 5: synthesis → self-critique
│   ├── llm/
│   │   ├── client.py         # Ollama client wrapper
│   │   ├── prompts.py        # Prompt templates (versioned)
│   │   └── determinism.py    # Seed and temperature controls
│   ├── retrieval/
│   │   ├── web_search.py     # Web retrieval (SearXNG or similar)
│   │   ├── corpus_search.py  # Local document corpus
│   │   └── hasher.py         # Source content hashing
│   ├── telemetry/
│   │   ├── collector.py      # TelemetryCollector (psutil sampling loop)
│   │   ├── prometheus_client.py  # Prometheus metrics exposure
│   │   └── tracing.py        # OpenTelemetry setup
│   └── storage/
│       ├── pg_client.py      # PostgreSQL write client
│       └── local_cache.py    # Local fallback cache (if controller unreachable)
├── worker.py                 # Celery worker entry point
├── submit.py                 # CLI task submission tool
├── schemas/
│   └── research_record_v1.json  # JSON Schema for validation
├── prompts/
│   ├── v1/
│   │   ├── system_decompose.txt
│   │   ├── system_retrieve.txt
│   │   ├── system_analyze.txt
│   │   ├── system_synthesize.txt
│   │   └── system_critique.txt
│   └── manifest.json         # Prompt version manifest with hashes
├── config/
│   ├── default.yaml          # Default harness configuration
│   └── node_profile.yaml     # This node's hardware declaration
├── Dockerfile
├── docker-compose.yml
└── requirements.txt
```

### 4.4 Primary Pipeline Class

```python
# harness/pipeline.py

import uuid
import time
import psutil
import hashlib
from dataclasses import dataclass
from typing import Optional

from .task import ResearchTask, ResearchConfig
from .record import ResearchRecord
from .phases import decompose, retrieve, analyze, synthesize, critique
from .telemetry.collector import TelemetryCollector
from .telemetry.tracing import trace_phase, setup_tracing
from .storage.pg_client import PostgresClient
from .llm.client import OllamaClient


class ResearchPipeline:
    """
    Orchestrates the full research pipeline for a single ResearchTask.
    Each pipeline instance is bound to a single run_id.
    Thread-safe for single-run use; instantiate new pipeline per task.
    """

    def __init__(self, config: ResearchConfig, node_profile: dict):
        self.config = config
        self.node_profile = node_profile
        self.llm = OllamaClient(
            host=config.ollama_host,
            model=config.model,
            temperature=0.0,      # Always deterministic
            seed=config.seed,
            top_p=config.top_p,
            repeat_penalty=config.repeat_penalty,
        )
        self.pg = PostgresClient(config.controller_host)
        self.tracer = setup_tracing(node_profile['node_id'], config.controller_host)

    def execute(self, task: ResearchTask) -> ResearchRecord:
        run_id = task.run_id
        telemetry = TelemetryCollector(run_id=run_id, sample_interval=1.0)

        try:
            telemetry.start()
            wall_start = time.monotonic()

            # Phase 1: Decompose
            plan_result = self._run_phase("decompose", decompose.run, task, telemetry)

            # Phase 2: Retrieve
            retrieval_result = self._run_phase("retrieve", retrieve.run, plan_result, telemetry)

            # Phase 3: Analyze
            evidence_result = self._run_phase("analyze", analyze.run, retrieval_result, telemetry)

            # Phase 4: Synthesize
            synthesis_result = self._run_phase("synthesize", synthesize.run, evidence_result, telemetry)

            # Phase 5: Self-critique
            critique_result = self._run_phase("critique", critique.run, synthesis_result, telemetry)

            wall_end = time.monotonic()
            hardware_snapshot = telemetry.stop()

            # Build and persist Research Record
            record = ResearchRecord.build(
                task=task,
                plan=plan_result,
                retrieval=retrieval_result,
                evidence=evidence_result,
                synthesis=synthesis_result,
                critique=critique_result,
                hardware=hardware_snapshot,
                node_profile=self.node_profile,
                wall_duration=wall_end - wall_start,
            )

            self.pg.insert_record(record)
            return record

        except Exception as exc:
            telemetry.stop()
            self.pg.mark_failed(run_id, str(exc))
            raise

    def _run_phase(self, phase_name: str, fn, input_data, telemetry: TelemetryCollector):
        telemetry.set_phase(phase_name)
        with self.tracer.start_as_current_span(f"research.{phase_name}") as span:
            span.set_attribute("run_id", str(input_data.run_id))
            result = fn(input_data, self.llm, self.config)
            span.set_attribute("tokens_used", result.tokens_used)
            return result
```

### 4.5 Telemetry Collector

```python
# harness/telemetry/collector.py

import time
import threading
import psutil
from dataclasses import dataclass, field
from typing import List, Optional


@dataclass
class HardwareSnapshot:
    run_id: str
    cpu_utilization_curve: List[float]
    cpu_mean_utilization: float
    cpu_peak_utilization: float
    memory_peak_rss_mb: int
    memory_peak_vms_mb: int
    swap_used_mb: int
    swap_activity_detected: bool
    cpu_temp_peak_c: Optional[float]
    throttling_detected: bool
    throttling_duration_seconds: float
    sample_count: int
    sample_interval_seconds: float
    bytes_sent: int
    bytes_received: int


class TelemetryCollector:
    """
    Samples hardware metrics at fixed interval in a background thread.
    Produces a HardwareSnapshot when stopped.
    """

    THROTTLE_TEMP_C = 80.0  # Conservative threshold for throttling detection

    def __init__(self, run_id: str, sample_interval: float = 1.0):
        self.run_id = run_id
        self.interval = sample_interval
        self._cpu_samples: List[float] = []
        self._mem_peak_rss = 0
        self._mem_peak_vms = 0
        self._swap_peak = 0
        self._swap_activity = False
        self._temp_peak: Optional[float] = None
        self._throttle_seconds = 0.0
        self._net_start = None
        self._phase = "idle"
        self._running = False
        self._thread: Optional[threading.Thread] = None
        self._lock = threading.Lock()

    def start(self):
        self._net_start = psutil.net_io_counters()
        self._running = True
        self._thread = threading.Thread(target=self._sample_loop, daemon=True)
        self._thread.start()

    def stop(self) -> HardwareSnapshot:
        self._running = False
        if self._thread:
            self._thread.join(timeout=self.interval * 2)

        net_end = psutil.net_io_counters()

        with self._lock:
            curve = self._cpu_samples[:]
            mean_util = sum(curve) / len(curve) if curve else 0.0
            peak_util = max(curve) if curve else 0.0

        return HardwareSnapshot(
            run_id=self.run_id,
            cpu_utilization_curve=curve,
            cpu_mean_utilization=round(mean_util, 3),
            cpu_peak_utilization=round(peak_util, 3),
            memory_peak_rss_mb=self._mem_peak_rss // (1024 * 1024),
            memory_peak_vms_mb=self._mem_peak_vms // (1024 * 1024),
            swap_used_mb=self._swap_peak // (1024 * 1024),
            swap_activity_detected=self._swap_activity,
            cpu_temp_peak_c=self._temp_peak,
            throttling_detected=self._throttle_seconds > 0,
            throttling_duration_seconds=round(self._throttle_seconds, 1),
            sample_count=len(curve),
            sample_interval_seconds=self.interval,
            bytes_sent=net_end.bytes_sent - self._net_start.bytes_sent,
            bytes_received=net_end.bytes_recv - self._net_start.bytes_recv,
        )

    def set_phase(self, phase: str):
        with self._lock:
            self._phase = phase

    def _sample_loop(self):
        while self._running:
            self._take_sample()
            time.sleep(self.interval)

    def _take_sample(self):
        mem = psutil.virtual_memory()
        swap = psutil.swap_memory()
        cpu_pct = psutil.cpu_percent(interval=None) / 100.0

        with self._lock:
            self._cpu_samples.append(round(cpu_pct, 3))
            self._mem_peak_rss = max(self._mem_peak_rss, mem.used)
            self._mem_peak_vms = max(self._mem_peak_vms, mem.total - mem.available)
            if swap.used > self._swap_peak:
                self._swap_peak = swap.used
                if swap.used > 0:
                    self._swap_activity = True

            # Temperature sampling (hwmon via psutil)
            try:
                temps = psutil.sensors_temperatures()
                core_temps = temps.get('coretemp', temps.get('k10temp', []))
                if core_temps:
                    current_max = max(t.current for t in core_temps)
                    if self._temp_peak is None or current_max > self._temp_peak:
                        self._temp_peak = current_max
                    if current_max >= self.THROTTLE_TEMP_C:
                        self._throttle_seconds += self.interval
            except (AttributeError, OSError):
                pass
```

### 4.6 Reproducibility Controls

**Determinism Layer:**

| Parameter | Controlled Value | Rationale |
|-----------|-----------------|-----------|
| Temperature | 0.0 | Greedy sampling for deterministic outputs |
| Seed | Per-config (default: 42) | Fixed seed for reproducibility across reruns |
| Model Tag | Pinned (e.g., `mistral:7b-instruct-q4_K_M`) | Prevents silent model updates |
| Prompt Version | Hashed manifest | Prompts are immutable once versioned |
| Python Environment | Hash-locked `requirements.txt` | Prevents library drift |
| Ollama Version | Pinned in Dockerfile | API and inference behavior consistency |

**Version Control Requirements:**

- The harness itself is version-controlled (git SHA stored in `reproducibility.harness_commit`)
- Prompts are stored in `prompts/v{N}/` directories; a new version is created for any change
- The prompt manifest (`prompts/manifest.json`) tracks hashes of all active prompts
- All schema changes increment `schema_version` and are backward compatible

**Containerization Strategy:**

```dockerfile
# infrastructure/research-harness/Dockerfile
FROM python:3.12-slim

# Pin OS packages
RUN apt-get update && apt-get install -y \
    curl \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements first for layer caching
COPY requirements.txt .
# requirements.txt uses exact pinned versions:
# ollama==0.5.1
# psutil==6.0.0
# opentelemetry-sdk==1.29.0
# prometheus-client==0.21.0
# celery==5.4.0
# redis==5.2.0
# psycopg2-binary==2.9.9
# jsonschema==4.23.0
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Record build-time metadata
ARG GIT_COMMIT="unknown"
ARG BUILD_DATE="unknown"
LABEL cascadia.commit=${GIT_COMMIT}
LABEL cascadia.build_date=${BUILD_DATE}

# Expose Prometheus metrics port
EXPOSE 9091

CMD ["celery", "-A", "worker", "worker", "--loglevel=info", "--queues=research"]
```

---

## 5. Scheduling and Orchestration

### 5.1 Technology Selection Rationale

**Selected: Celery + Redis**

For a heterogeneous cluster of older hardware running CPU-primary inference, the scheduling requirements are:
- Simple, reliable task dispatch
- Capability-aware routing (not all nodes can run all models)
- Low overhead on the coordinator
- No assumption of Kubernetes or Slurm availability
- Operator-friendly configuration and debugging

**Options evaluated:**

| Option | Verdict | Rationale |
|--------|---------|-----------|
| **Slurm** | Rejected | Designed for HPC homogeneous nodes; complex setup; overkill for research lab scale; poor fit for containerized workloads |
| **Kubernetes / k3s** | Deferred to Phase 3 | Excellent for container-native workloads but adds complexity that is premature for initial hardware |
| **Nomad** | Viable alternative | Simpler than k3s, good heterogeneous hardware support; revisit if Celery limitations appear |
| **Celery + Redis** | **Selected** | Simple, battle-tested, Python-native, capability routing via queues, low overhead |
| **Custom queue** | Rejected | Unnecessary complexity when Celery solves the problem |

### 5.2 Node Capability Registry

Each Worker registers its hardware profile with the Controller at startup. The profile is stored in PostgreSQL and Redis for fast routing decisions.

```yaml
# infrastructure/research-harness/config/node_profile.yaml
# Filled in per-node during provisioning

node_id: cascadia-worker-02
hostname: cascadia-worker-02
tier: small
gpu: false
gpu_vram_gb: null
ram_gb: 16
cpu_cores: 6
cpu_model: "Intel Core i5-8400"
disk_type: SSD
network_gbps: 1.0

# Which model size classes this node can serve
capable_model_sizes:
  - "1b"
  - "3b"
  - "7b"

# Explicit model allow-list (must be pre-downloaded)
downloaded_models:
  - "mistral:7b-instruct-q4_K_M"
  - "llama3.2:3b-instruct-q8_0"
  - "phi3.5:3.8b-mini-instruct-q4_K_M"
```

### 5.3 Celery Queue Topology

Queues are defined by node tier rather than by specific node, allowing flexible assignment:

```python
# infrastructure/research-harness/celery_config.py

CELERY_TASK_ROUTES = {
    'harness.tasks.run_research': {
        'queue': None,   # Dynamic: set at dispatch based on model requirements
    }
}

# Queue definitions by tier
QUEUES = {
    'research-micro':  # < 3B models
    'research-small':  # 3B-7B models
    'research-medium': # 7B-13B models
    'research-large':  # 13B+ models
    'research-gpu':    # Any model, GPU-accelerated
    'research-any':    # Best-available
}

# Worker startup: each worker subscribes to its tier queue
# cascadia-worker-02 (tier=small): listens to research-small, research-micro
```

**Dispatch logic:**

```python
# infrastructure/research-harness/controller/dispatcher.py

def dispatch_research_task(task: ResearchTask) -> str:
    """Route task to appropriate queue based on model requirements."""
    model_config = MODEL_REGISTRY[task.config.model]
    required_ram = model_config.min_ram_gb
    requires_gpu = task.config.require_gpu

    if requires_gpu:
        queue = 'research-gpu'
    elif required_ram >= 32:
        queue = 'research-large'
    elif required_ram >= 16:
        queue = 'research-medium'
    elif required_ram >= 8:
        queue = 'research-small'
    else:
        queue = 'research-micro'

    # Check queue health before dispatch
    if not queue_has_available_workers(queue):
        fallback = get_fallback_queue(queue)
        if fallback:
            queue = fallback
        else:
            raise NoAvailableWorkersError(f"No workers available for queue: {queue}")

    celery_app.send_task(
        'harness.tasks.run_research',
        args=[task.to_dict()],
        queue=queue,
        task_id=str(task.run_id),
        expires=3600,
    )
    return queue
```

### 5.4 Model Placement Strategy

**Key constraint:** No cross-node tensor sharding over Gigabit Ethernet.

Reasoning: Consumer-grade Ethernet (1 Gbps = ~125 MB/s) is approximately 2-3 orders of magnitude too slow for tensor parallelism at practical granularity. A 7B model in F16 is ~14 GB—loading it across 2 nodes over GbE would require ~112 seconds for the transfer alone, dwarfing inference time. The correct architecture is **model replication** (each node holds a full copy of the model it serves), not model parallelism.

**Placement rules:**

1. **Fit-first**: Assign model to smallest tier that can fit it in RAM with 20% headroom
2. **Pre-download required**: Models must be pulled to the worker before task dispatch; no on-demand pulling during task execution (adds variability to run timing)
3. **Single model per worker**: During active inference, load only the required model. Unload between tasks if RAM pressure is detected
4. **Isolation**: No concurrent inference tasks on the same worker (simplifies telemetry attribution)

```bash
# Pre-download script: scripts/setup/pull-models.sh
# Run during node provisioning, not at task time

TIER=$1  # micro | small | medium | large

case $TIER in
  micro)
    ollama pull phi3.5:3.8b-mini-instruct-q4_K_M
    ollama pull llama3.2:1b-instruct-q8_0
    ;;
  small)
    ollama pull mistral:7b-instruct-q4_K_M
    ollama pull llama3.1:8b-instruct-q4_K_M
    ollama pull phi3.5:3.8b-mini-instruct-q4_K_M
    ;;
  medium)
    ollama pull mistral-nemo:12b-instruct-2407-q4_K_M
    ollama pull llama3.1:8b-instruct-q8_0
    ;;
esac

echo "Model pre-download complete for tier: $TIER"
```

### 5.5 Throughput Scaling via Replication

Since tensor parallelism is excluded, scaling is achieved by:

1. **Horizontal replication**: Multiple workers run the same model; tasks distribute across them via the shared queue
2. **Model rotation**: Workers in lower tiers can be reassigned by updating their model download and queue subscription
3. **Priority scheduling**: Research tasks can be annotated with priority scores; Celery routes higher-priority tasks first within a queue

**Scaling example:** To double throughput of 7B model inference, provision a second `tier=small` worker, run the provisioning scripts, and subscribe it to `research-small`. No other configuration change required.

---

## 6. Meta-Analysis Capabilities

### 6.1 Design Objective

The RRSTF is not merely a research execution system—it is a data collection instrument for studying the relationship between hardware conditions and model output quality. Every Research Record is a data point in a multi-dimensional experiment space. Meta-analysis queries exploit the unified schema to produce insights that would be impossible without the permanent bonding of methodological and telemetry data.

### 6.2 Quality Scoring via Evaluator Pass

Research Records gain an `evaluation` field through a post-hoc evaluator pass. A separate evaluator harness runs a scoring LLM (ideally a different model than the one that produced the output, to reduce self-evaluation bias) against each completed record.

```json
{
  "evaluation": {
    "evaluator_model": "mistral-nemo:12b-instruct-2407-q4_K_M",
    "evaluator_run_id": "another-uuid",
    "evaluated_at": "2026-02-17T16:00:00Z",
    "scores": {
      "factual_grounding": 0.78,
      "logical_coherence": 0.85,
      "source_utilization": 0.71,
      "limitations_acknowledged": 0.90,
      "self_critique_accuracy": 0.83,
      "overall": 0.81
    },
    "evaluator_notes": "Synthesis is well-grounded but extrapolates beyond source evidence in paragraph 3. Self-critique correctly identifies this gap.",
    "schema_version": "1.0"
  }
}
```

### 6.3 Analysis Queries

The following SQL queries illustrate the meta-analysis capabilities enabled by the unified schema. All queries run against the `research_records` table in PostgreSQL.

**Query 1: Tokens per second by CPU model and quantization**
```sql
SELECT
    node_profile->>'cpu_model'                         AS cpu_model,
    model_name,
    record->'model'->>'quantization'                   AS quantization,
    COUNT(*)                                           AS runs,
    ROUND(AVG(tokens_per_second)::numeric, 2)          AS avg_tps,
    ROUND(STDDEV(tokens_per_second)::numeric, 2)       AS stddev_tps,
    MIN(tokens_per_second)                             AS min_tps,
    MAX(tokens_per_second)                             AS max_tps
FROM research_records
WHERE status = 'completed'
  AND tokens_per_second IS NOT NULL
GROUP BY cpu_model, model_name, quantization
ORDER BY avg_tps DESC;
```

**Query 2: Memory pressure vs output coherence**
```sql
SELECT
    CASE
        WHEN memory_peak_mb < 8000  THEN '< 8 GB'
        WHEN memory_peak_mb < 12000 THEN '8–12 GB'
        WHEN memory_peak_mb < 16000 THEN '12–16 GB'
        ELSE '> 16 GB'
    END                                               AS memory_tier,
    ROUND(AVG((evaluation->'scores'->>'logical_coherence')::float)::numeric, 3)
                                                       AS avg_coherence,
    ROUND(AVG((evaluation->'scores'->>'overall')::float)::numeric, 3)
                                                       AS avg_quality,
    COUNT(*)                                           AS runs
FROM research_records
WHERE status = 'completed'
  AND evaluation IS NOT NULL
GROUP BY memory_tier
ORDER BY memory_tier;
```

**Query 3: Throttling impact on throughput**
```sql
SELECT
    (record->'runtime'->'thermal'->>'throttling_detected')::boolean
                                                       AS throttled,
    COUNT(*)                                           AS runs,
    ROUND(AVG(tokens_per_second)::numeric, 2)          AS avg_tps,
    ROUND(AVG(duration_seconds)::numeric, 1)           AS avg_duration_s,
    ROUND(AVG(
        (record->'runtime'->'thermal'->>'throttling_duration_seconds')::float
    )::numeric, 1)                                     AS avg_throttle_s
FROM research_records
WHERE status = 'completed'
GROUP BY throttled;
```

**Query 4: Latency distribution by node tier**
```sql
SELECT
    record->'node'->>'tier'                            AS tier,
    model_name,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY duration_seconds)
                                                       AS p50_duration,
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY duration_seconds)
                                                       AS p90_duration,
    PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY duration_seconds)
                                                       AS p99_duration
FROM research_records
WHERE status = 'completed'
GROUP BY tier, model_name
ORDER BY tier, model_name;
```

**Query 5: Quantization vs quality tradeoff matrix**
```sql
SELECT
    record->'model'->>'quantization'                   AS quantization,
    model_name,
    ROUND(AVG(tokens_per_second)::numeric, 2)          AS avg_tps,
    ROUND(AVG(memory_peak_mb)::numeric, 0)             AS avg_peak_mb,
    ROUND(AVG((evaluation->'scores'->>'overall')::float)::numeric, 3)
                                                       AS avg_quality
FROM research_records
WHERE status = 'completed'
  AND evaluation IS NOT NULL
GROUP BY quantization, model_name
ORDER BY model_name, quantization;
```

**Query 6: Energy efficiency proxy by hardware class**
```sql
SELECT
    cpu_model,
    ram_gb,
    ROUND(AVG(
        (record->'runtime'->'energy'->>'estimated_joules')::float /
        NULLIF(tokens_per_second * duration_seconds, 0)
    )::numeric, 2)                                     AS joules_per_token,
    COUNT(*)                                           AS runs
FROM research_records
WHERE status = 'completed'
  AND record->'runtime'->'energy'->>'method' = 'proxy'
GROUP BY cpu_model, ram_gb
ORDER BY joules_per_token;
```

**Query 7: Swap activity as predictor of quality degradation**
```sql
SELECT
    (record->'runtime'->'memory'->>'swap_activity_detected')::boolean
                                                       AS swap_occurred,
    ROUND(AVG((evaluation->'scores'->>'logical_coherence')::float)::numeric, 3)
                                                       AS avg_coherence,
    ROUND(AVG((evaluation->'scores'->>'factual_grounding')::float)::numeric, 3)
                                                       AS avg_factual,
    COUNT(*)                                           AS runs
FROM research_records
WHERE status = 'completed'
  AND evaluation IS NOT NULL
GROUP BY swap_occurred;
```

### 6.4 Enabling Systems-Aware Model Research

The meta-analysis capability enables a class of research questions that are novel precisely because they require the bonding of hardware telemetry with model output assessment:

- **Hardware-informed model selection**: Given a specific node's CPU and RAM, which model+quantization combination produces the best quality-per-second tradeoff?
- **Thermal sensitivity analysis**: At what sustained CPU temperature does output quality measurably degrade? Is this effect model-dependent?
- **Memory pressure thresholds**: What is the RAM utilization percentage at which swap activity begins to impact coherence scores?
- **Aging hardware detection**: By comparing TPS over time on the same node, can we detect hardware degradation (thermal paste failure, disk slowdown)?
- **Publishable experimental results**: Because every variable is recorded—model, quantization, hardware, temperature, runtime, output, and quality scores—results are fully citable and reproducible by external parties who replicate the hardware configuration.

---

## 7. Implementation Phases

### Phase 1 — Single-Node Prototype

**Objective:** Establish the core feedback loop between research execution, telemetry capture, and Research Record storage on a single machine.

**Deliverables:**
- Research Harness (decompose → retrieve → synthesize → critique pipeline)
- TelemetryCollector running during task execution
- Research Record written to local SQLite (not yet PostgreSQL)
- `node_exporter` installed and functional
- Prompts versioned in `prompts/v1/`
- Basic CLI tool for task submission (`submit.py`)
- JSON Schema validation of output records
- Docker Compose for local harness + Ollama

**Required Tools:**
- Python 3.12, Ollama, Docker, SQLite, psutil
- One capable worker machine (≥ 8 GB RAM)

**Risks:**
- LLM quality on small models may be insufficient for complex research phases—mitigation: start with simpler questions
- Retrieval latency from web search introduces non-determinism in timing—mitigation: record retrieval time separately and use local corpus for reproducibility testing
- Hardware temperature sensor availability varies by hardware—mitigation: treat as optional with graceful fallback

**Validation Criteria:**
- Research task executes end-to-end without interruption
- Research Record passes JSON Schema validation
- Hardware telemetry (CPU, memory, temperature) captured in record
- Record is inspectable and all fields populated
- Same question + same config produces structurally identical output (modulo retrieval variability)

---

### Phase 2 — Multi-Node Cluster

**Objective:** Extend the framework to operate across 3+ heterogeneous nodes with centralized observability and task routing.

**Deliverables:**
- Controller Node provisioned (Prometheus, Grafana, Loki, OTEL Collector, PostgreSQL, Redis)
- Celery task queue operational with tier-based routing
- Workers containerized and registered with capability profiles
- Prometheus scraping all `node_exporter` endpoints
- `run_id` propagated through OTEL spans to Jaeger/Tempo
- Loki receiving structured logs with `run_id` labels
- Grafana: Cluster Overview and Run Inspector dashboards
- PostgreSQL as canonical Research Record store
- Worker isolation: one active inference task per worker at a time

**Required Tools:**
- Docker Compose (per node), Ansible (cluster provisioning), Redis, PostgreSQL
- Prometheus, Grafana, Loki/Promtail, OTEL Collector, Jaeger/Tempo

**Risks:**
- Network reliability on older switches may cause inter-node communication errors—mitigation: implement retry with exponential backoff in Celery; local cache fallback for record writes
- PostgreSQL on Controller becomes SPOF—mitigation: local record cache on workers; async write with retry
- Mixed Ollama versions across nodes may produce different outputs—mitigation: pin Ollama version in provisioning scripts and enforce in Docker image

**Validation Criteria:**
- Tasks submitted to Controller execute on appropriate worker tier
- Research Records from all workers visible in Grafana dashboards
- Run Inspector dashboard correctly shows hardware metrics for a given `run_id`
- At least 3 nodes operating simultaneously under independent task loads
- Record written to PostgreSQL even when one intermediate service is briefly unavailable

---

### Phase 3 — Research Automation + Evaluation Suite

**Objective:** Enable automated research pipelines, post-hoc quality evaluation, and meaningful meta-analysis queries.

**Deliverables:**
- Evaluator harness: scores completed Research Records using a second LLM pass
- `evaluation` field populated in PostgreSQL for all completed records
- Question bank: curated set of 50+ research questions across domains
- Batch submission tool: run a full question bank against all worker configurations
- Meta-analysis query library: SQL query set for hardware vs quality correlation
- Grafana: Hardware-Aware Research Analytics dashboard
- Report generator: produces summary tables from meta-analysis queries
- Model registry: central tracking of model names, quantizations, known RAM requirements

**Required Tools:**
- Evaluator harness (extends Research Harness with scoring pipeline)
- PostgreSQL advanced queries (window functions, percentile_cont)
- Grafana data source: PostgreSQL direct connection
- Python report generator (Jinja2 templates + CSV/Markdown output)

**Risks:**
- Self-evaluation bias in scoring LLM—mitigation: use a different model family for evaluation than for generation; document evaluator model in record
- Quality scores are LLM-generated and thus subjective—mitigation: define multiple independent scoring dimensions; treat as approximate signal not ground truth
- Large-scale batch runs may overwhelm older hardware—mitigation: implement concurrency limits and thermal throttle detection with automatic pause

**Validation Criteria:**
- All completed Research Records have `evaluation` field with multi-dimensional scores
- At least one statistically significant correlation found between hardware metric and quality score
- Meta-analysis queries produce results matching manually verified spot-check samples
- Report generator produces readable summaries from database

---

### Phase 4 — Continuous Research Benchmarking System

**Objective:** Transform the cluster into a continuously operating research instrument that tracks model behavior, hardware aging, and infrastructure performance over time.

**Deliverables:**
- Scheduled research campaigns: periodic re-execution of standardized question bank across all nodes
- Drift detection: statistical monitoring for throughput degradation (hardware aging, thermal paste failure)
- Alerting: Grafana alerts on TPS drop > 20% from baseline for any node
- Research Record versioning: if a question is re-run, records are linked via `question_hash`
- Longitudinal analysis dashboard: TPS trends over months per node
- Hardware aging report: automated report of performance changes over time
- Publication-ready export: LaTeX/Markdown report templates for sharing findings
- Automated model update testing: when new quantizations are published, re-run benchmark suite

**Required Tools:**
- Grafana alerting (PagerDuty or email integration)
- Apache Airflow or cron-based scheduler for research campaigns
- Statistical analysis (SciPy for Mann-Whitney U tests on TPS distributions)
- Pandoc or LaTeX for publication export

**Risks:**
- Long-running campaigns may accumulate significant storage—mitigation: implement data retention policies; archive old records to compressed storage
- Hardware failures will interrupt campaigns—mitigation: Celery retry logic; graceful degradation when nodes go offline
- Evaluator model updates may shift quality scores non-comparably—mitigation: pin evaluator model version per campaign; re-evaluate historical records when evaluator changes

**Validation Criteria:**
- System runs at least one research campaign per week without manual intervention
- Drift detection correctly identifies a simulated performance regression (e.g., CPU frequency cap applied manually)
- Longitudinal dashboard shows 3+ months of TPS trend per node
- At least one research finding produced from the lab is presentable in external format

---

## 8. Philosophical Framing

### The Instrument Problem in Heterogeneous Computing

Scientific inquiry has always been constrained and shaped by its instruments. Galileo's observations were limited by his lenses; radiotelescopes determined what cosmologists could hear; the sensitivity of a spectrograph defines the chemistry one can detect in a distant star. In each case, the instrument does not merely reveal the phenomenon—it participates in constituting what the researcher can know.

Cascadia Mobile Systems Lab takes this insight seriously in the domain of model-generated research. When an LLM produces a synthesis, that synthesis is not a context-free output—it is the product of a specific model, with a specific quantization, on a specific piece of hardware, under specific thermal and memory pressure conditions, at a particular time. These factors are not noise to be controlled away; they are part of the experimental situation.

### Hardware Behavior as Epistemology

The RRSTF treats hardware behavior as an epistemological variable. A model running at 22 tok/s on a well-cooled i7 with 32 GB of fast DDR5 is operating in a different computational environment than the same model at 9 tok/s on a thermally throttled i5 with 16 GB of slow DDR4. Whether these conditions affect output quality is an empirical question—one that existing systems research largely ignores because it either assumes GPU compute or abstracts away hardware entirely.

This lab does not make that abstraction. Every Research Record permanently bonds the epistemological artifact (the synthesis) to the physical substrate conditions that produced it. This is not a technical convenience—it is a methodological commitment.

### Compute Constraints as Part of the Research Method

Classical laboratory science reports instrument specifications in the methods section because readers need to know whether findings generalize beyond the specific conditions of measurement. systems research rarely does this with comparable rigor. A benchmark run on 8×A100s tells us relatively little about what will happen when the same model runs on a 2018 laptop with 8 GB of RAM—a configuration that describes the majority of the world's deployed distributed compute.

Cascadia Mobile Systems Lab deliberately operates in the constrained regime. By documenting compute conditions as first-class experimental variables, the lab produces findings that speak to real-world deployment conditions. The constraint is the contribution.

### Model Outputs as Experimentally Situated Artifacts

The Research Records produced by this framework are not treated as authoritative knowledge—they are treated as situated artifacts. A synthesis produced by `mistral:7b-instruct-q4_K_M` on an Intel i5 with thermal throttling is a data point about what this class of model can produce under these conditions. Aggregated across hundreds of runs and multiple hardware configurations, these artifacts become the material for a genuinely novel kind of empirical compute systems research.

The lab's meta-analysis capabilities are designed to ask questions that belong to this domain: not "is this model smart?" but "how does this model's reasoning quality vary as a function of available memory, quantization level, and thermal state?" These are systems questions, and they deserve systems-grade instrumentation.

This is the mission of Cascadia Mobile Systems Lab: to build an infrastructure capable of treating model inference as a physical process subject to physical constraints, and to study the implications of those constraints with the rigor of experimental science.

---

## Appendix: File Inventory

The following files are created or specified by this design document:

```
infrastructure/
└── research-harness/
    ├── harness/
    │   ├── __init__.py
    │   ├── pipeline.py
    │   ├── task.py
    │   ├── record.py
    │   ├── phases/
    │   │   ├── decompose.py
    │   │   ├── retrieve.py
    │   │   ├── analyze.py
    │   │   ├── synthesize.py
    │   │   └── critique.py
    │   ├── llm/
    │   │   ├── client.py
    │   │   ├── prompts.py
    │   │   └── determinism.py
    │   ├── retrieval/
    │   │   ├── web_search.py
    │   │   ├── corpus_search.py
    │   │   └── hasher.py
    │   ├── telemetry/
    │   │   ├── collector.py
    │   │   ├── prometheus_client.py
    │   │   └── tracing.py
    │   └── storage/
    │       ├── pg_client.py
    │       └── local_cache.py
    ├── worker.py
    ├── submit.py
    ├── schemas/
    │   └── research_record_v1.json
    ├── prompts/
    │   ├── v1/
    │   │   ├── system_decompose.txt
    │   │   ├── system_retrieve.txt
    │   │   ├── system_analyze.txt
    │   │   ├── system_synthesize.txt
    │   │   └── system_critique.txt
    │   └── manifest.json
    ├── config/
    │   ├── default.yaml
    │   └── node_profile.yaml
    ├── Dockerfile
    ├── docker-compose.yml
    └── requirements.txt

infrastructure/monitoring/
├── prometheus/
│   └── prometheus.yml
├── grafana/
│   ├── provisioning/
│   │   ├── dashboards/
│   │   │   ├── cluster-overview.json
│   │   │   ├── run-inspector.json
│   │   │   ├── node-comparison.json
│   │   │   └── research-analytics.json
│   │   └── datasources/
│   │       ├── prometheus.yaml
│   │       └── postgresql.yaml
└── loki/
    ├── loki-config.yaml
    └── promtail-config.yaml

infrastructure/orchestration/
├── celery_config.py
├── dispatcher.py
└── worker_registry.py

docs/architecture/
├── RESEARCH_TELEMETRY_FRAMEWORK.md      # This document
└── OVERVIEW.md                          # (updated)

docs/decisions/
└── 2026-02-17-research-telemetry-framework.md

docs/experiments/
└── INDEX.md                             # (updated with planned experiments)
```

---

*Cascadia Mobile Systems Lab — Reproducible Research + Systems Telemetry Framework*
*Document Version 1.0 — 2026-02-17*
*Status: Accepted for implementation*
