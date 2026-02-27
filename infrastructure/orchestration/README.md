# Orchestration

Task scheduling, worker coordination, and capability-aware dispatch for Cascadia Mobile Systems Lab.

---

## Overview

The lab uses **Celery + Redis** for research task orchestration. This combination provides:

- Simple, reliable task dispatch over TCP
- Capability-aware routing via named queues
- Low overhead on older hardware
- Python-native integration with the Research Harness

See the full design rationale in [RESEARCH_TELEMETRY_FRAMEWORK.md](../../docs/architecture/RESEARCH_TELEMETRY_FRAMEWORK.md#5-scheduling-and-orchestration).

## Architecture

```
[Research Submission API]
    │
    ▼
[Controller: Redis Broker]
    │
    ├── Queue: research-micro  → Worker(s) with tier=micro
    ├── Queue: research-small  → Worker(s) with tier=small
    ├── Queue: research-medium → Worker(s) with tier=medium
    ├── Queue: research-large  → Worker(s) with tier=large
    ├── Queue: research-gpu    → Worker(s) with gpu=true
    └── Queue: research-any    → Any available worker
```

## Key Design Decisions

### No Cross-Node Tensor Sharding

Tensor parallelism across nodes is explicitly excluded. 1 Gbps Ethernet is 2–3 orders of magnitude too slow for practical tensor communication. All inference runs entirely within a single worker node. Scaling is achieved through **model replication** (multiple workers running the same model) rather than model parallelism.

### One Task Per Worker

Workers accept one research task at a time (`concurrency=1`). This ensures:
- Clean telemetry attribution (all hardware metrics are attributable to the active run)
- No memory contention between concurrent inference tasks
- Predictable resource usage

### Capability Routing

Workers subscribe to queues matching their hardware tier. A `small` tier worker subscribes to both `research-small` (its primary queue) and `research-micro` (lower tier it can always handle). Tasks are dispatched to the smallest capable tier to preserve high-RAM nodes for models that need them.

## Files

- `celery_config.py` — Celery broker and queue configuration
- `dispatcher.py` — Task routing logic (selects queue based on model requirements)
- `worker_registry.py` — Node capability registration and health tracking

## Adding a New Worker

1. Provision the node: `scripts/setup/provision-worker.sh`
2. Pull appropriate models: `scripts/setup/pull-models.sh <tier>`
3. Fill in `config/node_profile.yaml`
4. Start worker stack: `NODE_ID=<id> docker compose up -d`
5. Worker auto-registers with Controller

No manual configuration change is needed on the Controller — workers register themselves via the capability registry API.

## Monitoring

- Worker health: Grafana → Cluster Overview dashboard
- Queue depth: Redis `LLEN research-small` or Grafana dashboard
- Active tasks: `celery -A worker inspect active`

## Future Consideration

If workload volume grows beyond what Celery handles comfortably, **Nomad** is the preferred next step—better native support for heterogeneous hardware, resource-aware scheduling, and simpler operation than Kubernetes. See [2026-02-17-research-telemetry-framework.md](../../docs/decisions/2026-02-17-research-telemetry-framework.md) for the k3s/Nomad/Slurm analysis.
