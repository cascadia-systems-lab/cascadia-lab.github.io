# Research Harness

**Cascadia Mobile Systems Lab — Research Execution and Telemetry System**

See the full design specification: [RESEARCH_TELEMETRY_FRAMEWORK.md](../../docs/architecture/RESEARCH_TELEMETRY_FRAMEWORK.md)

---

## Overview

The Research Harness executes structured systems research pipelines on worker nodes while simultaneously capturing hardware telemetry. Every execution produces a **Research Record**: a unified JSON document containing the full methodological output (hypotheses, retrieved sources, evidence, synthesis, self-critique) and the hardware metrics (CPU curve, memory peak, thermal readings, tokens/second) recorded during the run.

A `run_id` UUID binds all data to a single run across Prometheus, Loki, OpenTelemetry traces, and PostgreSQL.

---

## Quick Start (Single Node / Phase 1)

### Prerequisites

- Docker and Docker Compose installed
- Node profile filled in: `config/node_profile.yaml`
- Ollama accessible at `localhost:11434`

### 1. Configure the Node

```bash
# Copy and fill in your hardware profile
cp config/node_profile.yaml.example config/node_profile.yaml
vim config/node_profile.yaml   # Fill in CPU, RAM, disk, tier, etc.

# Pull the models for your tier (run once)
chmod +x ../../scripts/setup/pull-models.sh
../../scripts/setup/pull-models.sh small    # or: micro | medium | large
```

### 2. Set Environment Variables

```bash
export NODE_ID="cascadia-worker-02"
export CONTROLLER_HOST="cascadia-controller"
export DB_PASSWORD="your-db-password"
export REDIS_URL="redis://cascadia-controller:6379/0"
export NODE_TIER="small"     # Matches your tier in node_profile.yaml
```

### 3. Start the Worker Stack

```bash
docker compose up -d
```

### 4. Submit a Research Task (from controller)

```bash
python submit.py \
  --question "What are the energy efficiency tradeoffs of running quantized LLMs on CPU-only hardware?" \
  --model "mistral:7b-instruct-q4_K_M" \
  --tier small
```

### 5. View the Research Record

```bash
# Check PostgreSQL
psql -h cascadia-controller -U cascadia -d cascadia_lab \
  -c "SELECT run_id, status, tokens_per_second, memory_peak_mb FROM research_records ORDER BY created_at DESC LIMIT 5;"

# View full record as JSON
psql -h cascadia-controller -U cascadia -d cascadia_lab \
  -c "SELECT record FROM research_records WHERE status='completed' ORDER BY created_at DESC LIMIT 1;" \
  | python -m json.tool
```

---

## Directory Structure

```
research-harness/
├── harness/
│   ├── pipeline.py           # Main ResearchPipeline class
│   ├── task.py               # ResearchTask dataclass
│   ├── record.py             # ResearchRecord builder
│   ├── phases/               # Individual pipeline phases
│   │   ├── decompose.py      # Phase 1: question → plan
│   │   ├── retrieve.py       # Phase 2: plan → sources
│   │   ├── analyze.py        # Phase 3: sources → evidence
│   │   ├── synthesize.py     # Phase 4: evidence → synthesis
│   │   └── critique.py       # Phase 5: self-evaluation
│   ├── llm/                  # Ollama client and prompt management
│   ├── retrieval/            # Web search and corpus retrieval
│   ├── telemetry/            # Hardware sampling, OTEL, Prometheus
│   └── storage/              # PostgreSQL and local cache
├── worker.py                 # Celery worker entry point
├── submit.py                 # CLI task submission tool
├── schemas/
│   └── research_record_v1.json  # JSON Schema for validation
├── prompts/
│   ├── v1/                   # Versioned prompt templates
│   └── manifest.json         # Prompt version manifest with SHA-256 hashes
├── config/
│   ├── default.yaml          # Default harness configuration
│   └── node_profile.yaml     # This node's hardware declaration
├── Dockerfile
├── docker-compose.yml
└── requirements.txt
```

---

## Research Pipeline Phases

Each phase is independently traced (OpenTelemetry) and its token usage is recorded.

| Phase | Input | Output | Model Call? |
|-------|-------|--------|-------------|
| 1. Decompose | Question | Plan + Hypotheses | Yes |
| 2. Retrieve | Plan | Source list with hashes | No (web/corpus) |
| 3. Analyze | Sources | Evidence table | Yes |
| 4. Synthesize | Evidence | Synthesis text | Yes |
| 5. Critique | Synthesis | Self-critique + confidence | Yes |

---

## Research Record

Every completed run writes a Research Record to PostgreSQL. The record contains:

**Methodological fields:**
- `research.question`, `research.question_hash`
- `research.hypotheses`, `research.plan`
- `research.retrieval.sources` (with SHA-256 content hashes)
- `research.evidence`, `research.synthesis`
- `research.limitations`, `research.self_critique`

**Model fields:**
- `model.tag`, `model.quantization`, `model.parameter_count_b`
- `model.parameters` (temperature=0.0, seed=42, etc.)
- `model.prompts.system_prompt_hash`, `model.prompts.prompt_hash`

**Hardware fields:**
- `node.cpu_model`, `node.ram_gb`, `node.tier`, `node.disk_type`
- `runtime.tokens.per_second`, `runtime.tokens.generated`
- `runtime.memory.peak_rss_mb`, `runtime.memory.swap_activity_detected`
- `runtime.cpu.utilization_curve`, `runtime.cpu.mean_utilization`
- `runtime.thermal.peak_cpu_temp_c`, `runtime.thermal.throttling_detected`
- `runtime.energy.estimated_joules` (proxy or RAPL)

**Reproducibility fields:**
- `reproducibility.harness_version`, `reproducibility.harness_commit`
- `reproducibility.ollama_version`, `reproducibility.seed_used`
- `reproducibility.deterministic: true`

See [research_record_v1.json](schemas/research_record_v1.json) for the complete JSON Schema.

---

## Reproducibility

The harness enforces determinism through:

- **Temperature 0.0**: Greedy decoding; same input → same output
- **Fixed seed**: Configurable, default 42
- **Pinned model tags**: Full tag including quantization (e.g., `mistral:7b-instruct-q4_K_M`)
- **Versioned prompts**: Each prompt change creates a new version directory; hashes are stored in the record
- **Pinned environment**: `requirements.txt` uses exact version pins; Docker image tags are pinned
- **Config hashing**: The active configuration is SHA-256 hashed and stored in the record

To reproduce a past run, use its `reproducibility` fields to restore the exact model, prompts, config, and environment.

---

## Telemetry Integration

| System | What It Captures | run_id Integration |
|--------|-----------------|-------------------|
| Prometheus | CPU, memory, disk, network, temperature | Label on harness metrics at `:9091` |
| OpenTelemetry | Per-phase spans, durations, token counts | Root span attribute |
| Loki | All log lines with structured context | Label on every log line |
| PostgreSQL | Complete Research Record | Primary key |

All four systems are queryable by `run_id`.

---

## Node Tiers and Celery Queues

| Tier | RAM | Queue | Typical Models |
|------|-----|-------|---------------|
| micro | < 8 GB | `research-micro` | 1B–3B models |
| small | 8–16 GB | `research-small` | 3B–7B models |
| medium | 16–32 GB | `research-medium` | 7B–13B models |
| large | 32+ GB | `research-large` | 13B–70B models |
| gpu | any + GPU | `research-gpu` | Accelerated inference |

Workers subscribe to their tier queue plus lower tier queues. A `small` worker accepts `research-small` and `research-micro` tasks.

---

## Operational Runbook

See [Research Harness Runbook](../../docs/runbooks/research-harness.md) for:
- Starting, stopping, and restarting procedures
- Common troubleshooting issues
- Model pull and update procedures
- Log inspection commands

---

## Development

### Running without Docker (for development)

```bash
# Install dependencies
pip install -r requirements.txt

# Start Ollama separately
ollama serve &

# Run harness worker in foreground
CONTROLLER_HOST=localhost NODE_ID=dev-node \
  celery -A worker worker --loglevel=debug --queues=research-any --concurrency=1

# Submit a test task
python submit.py --local \
  --question "What is transformer attention?" \
  --model "phi3.5:3.8b-mini-instruct-q4_K_M"
```

### Adding a New Pipeline Phase

1. Create `harness/phases/<phase_name>.py`
2. Implement `run(input_data, llm_client, config) -> PhaseResult`
3. Add phase to `pipeline.py` execution sequence
4. Create corresponding prompt in `prompts/v1/system_<phase_name>.txt`
5. Update prompt manifest with hash
6. Update `research_record_v1.json` if schema changes

### Adding a New Prompt Version

1. Create `prompts/v2/` directory
2. Copy prompts from `v1/`, modify as needed
3. Update `prompts/manifest.json` with new hashes
4. Set `prompt_version: v2` in `config/default.yaml`
5. Never modify existing versioned prompts

---

## References

- [Full Design: RESEARCH_TELEMETRY_FRAMEWORK.md](../../docs/architecture/RESEARCH_TELEMETRY_FRAMEWORK.md)
- [Decision Log](../../docs/decisions/2026-02-17-research-telemetry-framework.md)
- [Research Record Schema](schemas/research_record_v1.json)
- [Monitoring Stack](../monitoring/)

---

**Status**: Implementing Phase 1
**Last Updated**: 2026-02-17
