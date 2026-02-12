# Architecture Overview

**Cascadia AI Systems Lab - System Architecture**

---

## Purpose

This document provides a high-level overview of the lab's infrastructure architecture, design patterns, and key technical decisions. It serves as an entry point for understanding how systems are organized and interconnected.

---

## Current Architecture State

**Last Updated**: 2026-02-11
**Phase**: Foundation / Initial Setup

The lab is in its foundational phase. This document will evolve significantly as infrastructure is built out.

---

## Infrastructure Layers

### Layer 1: Physical Infrastructure
- **Compute**: GPU-accelerated workstations and servers
- **Storage**: Direct-attached and network storage systems
- **Networking**: Local network topology, inter-node connectivity
- **Power/Cooling**: Environmental considerations

*Status*: Being documented in [Hardware Inventory](../hardware/INVENTORY.md)

### Layer 2: Operating System & Drivers
- **OS**: Linux-based (distribution TBD based on hardware)
- **GPU Drivers**: NVIDIA proprietary or open-source stack
- **Kernel**: Optimizations for CUDA, networking, storage
- **System Services**: Core OS services and daemons

*Status*: Standards to be established during first system build

### Layer 3: Container & Virtualization
- **Containers**: Docker, Podman, or containerd
- **Orchestration**: Kubernetes (k3s), Docker Compose, or Nomad
- **GPU Passthrough**: NVIDIA Container Runtime, MIG, or vGPU
- **Resource Isolation**: cgroups, namespaces, NUMA awareness

*Status*: Options being evaluated; see [Decision Log](../decisions/)

### Layer 4: Data & Storage
- **Object Storage**: MinIO, Ceph, or S3-compatible
- **Block Storage**: Local NVMe, SAN, or distributed block
- **File Systems**: ZFS, Btrfs, or NFS for shared storage
- **Caching Layer**: Local SSD caching, distributed cache

*Status*: Architecture to be determined based on workload requirements

### Layer 5: AI/ML Runtime
- **Inference Engines**: vLLM, Triton, TensorRT-LLM, HuggingFace TGI
- **Training Frameworks**: PyTorch, JAX, DeepSpeed
- **Serving APIs**: OpenAI-compatible endpoints, gRPC services
- **Model Storage**: HuggingFace Hub, local model registry

*Status*: Experimentation phase; multiple options under evaluation

### Layer 6: Orchestration & Scheduling
- **Workload Scheduling**: Kubernetes, Slurm, or custom scheduler
- **Job Queues**: Celery, RabbitMQ, or distributed task queues
- **Resource Management**: GPU allocation, memory limits, priorities
- **Fault Tolerance**: Retries, health checks, failover

*Status*: Design pending; depends on Layer 3 decisions

### Layer 7: Observability & Operations
- **Metrics**: Prometheus, DCGM for GPU metrics, node_exporter
- **Logging**: Loki, ELK stack, or structured logging to files
- **Tracing**: Jaeger or OpenTelemetry (if distributed workloads)
- **Dashboards**: Grafana for visualization
- **Alerting**: Prometheus Alertmanager or custom alerts

*Status*: Prometheus + Grafana likely; to be confirmed in experiments

### Layer 8: Data Pipelines & Tooling
- **ETL/ELT**: Data ingestion and transformation pipelines
- **Workflow Orchestration**: Airflow, Prefect, or custom
- **Data Quality**: Validation, monitoring, anomaly detection
- **Automation**: CI/CD for infrastructure, GitOps patterns

*Status*: To be designed based on specific data workloads

---

## Design Principles

### Multi-Node Ready
Even single-machine experiments should consider:
- Network communication patterns
- Data locality and transfer costs
- Distributed coordination mechanisms
- Horizontal scaling strategies

### Observable by Default
Every component should expose:
- Health status endpoints
- Performance metrics
- Structured logs
- Debugging interfaces

### Failure-Aware
Design assumes:
- Hardware will fail
- Networks will partition
- GPUs will fault
- Storage will fill

### Self-Hosted First
Prefer running infrastructure locally:
- Greater control and visibility
- Cost optimization through hardware ownership
- Learning opportunities from operations
- Offline operation capability

### Reproducible
Infrastructure should be:
- Declaratively configured
- Version-controlled
- Documented with runbooks
- Testable in isolation

---

## Network Topology

*To be documented as infrastructure is built.*

### Current State
- Single node with local network connectivity
- Internet access for package downloads and research

### Future State
- Multi-node cluster with dedicated interconnect
- Separate management, data, and storage networks
- Potential WireGuard mesh for secure remote access

---

## Data Flow Patterns

*To be documented based on actual workloads.*

### Anticipated Patterns
1. **Model Inference Flow**
   - Request → API Gateway → Inference Engine → Model (GPU) → Response

2. **Training Data Flow**
   - Raw Data → Preprocessing → Training Dataset → GPU → Model Checkpoints

3. **Monitoring Data Flow**
   - Metrics Export → Prometheus → Grafana Dashboards
   - Logs → Aggregation → Storage → Query Interface

---

## Security Considerations

*To be expanded as infrastructure matures.*

### Current Focus
- No public exposure of services
- Local-only access during development
- Secrets management for API keys and credentials

### Future Considerations
- Authentication and authorization for multi-user access
- Network segmentation and firewall rules
- Encrypted storage for sensitive data
- Audit logging for infrastructure changes

---

## Scaling Strategy

### Phase 1: Single Node (Current)
- Focus on vertical scaling: maximize single-GPU performance
- Establish baselines and operational patterns

### Phase 2: Multi-GPU
- Scale to multiple GPUs within single node
- Test GPU-to-GPU communication patterns
- Implement resource scheduling

### Phase 3: Multi-Node
- Expand to multiple physical machines
- Implement distributed inference or training
- Test network-bound workloads

### Phase 4: Dynamic Scaling
- Auto-scaling based on workload
- Job scheduling across heterogeneous hardware
- Cost and power optimization

---

## Technology Decisions

Major technology choices are documented in [Decision Logs](../decisions/). Key decisions pending:

- [ ] Container orchestration platform
- [ ] Storage backend architecture
- [ ] Model serving framework
- [ ] Monitoring stack components
- [ ] Network topology design

---

## Integration Points

*How systems communicate with each other.*

### APIs
- REST APIs for user-facing services
- gRPC for high-performance inter-service communication
- NVIDIA DCGM API for GPU monitoring

### Message Queues
- To be determined based on workload patterns

### Shared Storage
- Model artifacts, datasets, logs, and checkpoints
- Access patterns to be profiled during experiments

---

## Performance Targets

*To be established through baseline experiments.*

### Latency
- Interactive inference: < 100ms p95
- Batch inference: Maximize throughput
- Monitoring metrics: < 5s staleness

### Throughput
- TBD based on hardware capabilities and workload types

### Utilization
- GPU utilization: > 80% for production workloads
- Storage I/O: Avoid bottlenecks in data loading
- Network: Monitor for saturation during distributed workloads

---

## Future Directions

### Potential Areas of Exploration
- Distributed training across multiple nodes
- Model quantization and optimization
- Custom CUDA kernels for specialized workloads
- Energy efficiency optimization
- Hybrid cloud-edge architectures

---

## References

- [Lab Philosophy](LAB_PHILOSOPHY.md)
- [Standards & Conventions](STANDARDS.md)
- [Hardware Inventory](../hardware/INVENTORY.md)
- [Decision Logs](../decisions/)
- [Experiment Index](../experiments/INDEX.md)

---

**Status**: Living document - updated continuously as architecture evolves.

*This overview provides strategic context for infrastructure decisions in Cascadia AI Systems Lab.*
