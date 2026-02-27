# Lab Philosophy

**Operating Principles for Cascadia Mobile Systems Lab**

---

## Core Principles

### 1. Infrastructure First, Applications Second

compute systems are built on infrastructure. Before optimizing model performance, we optimize the systems that run those models. This lab prioritizes understanding storage I/O, network throughput, GPU utilization, and resource scheduling over chasing leaderboard metrics.

**Implication**: We measure infrastructure metrics (latency, throughput, utilization) before model metrics (accuracy, perplexity). A model that performs well in a vacuum but breaks infrastructure assumptions is a failed experiment.

### 2. Real Workloads, Real Hardware

Synthetic benchmarks are useful but insufficient. This lab runs actual workloads on physical hardware. We care about what happens when:
- A model runs for 8 hours, not 5 minutes
- Storage is 80% full, not empty
- Multiple workloads compete for GPU memory
- Network switches are handling real traffic, not isolated tests

**Implication**: Experiments must run in production-like conditions. Benchmark results are validated against sustained, realistic usage patterns.

### 3. Document Everything, Especially Failures

Failed experiments are valuable. A documented failure saves future time and informs better designs. This lab maintains detailed records of:
- What was tried and why
- What worked and what didn't
- Performance characteristics observed
- Decisions made and alternatives rejected

**Implication**: Every experiment produces documentation. No undocumented infrastructure changes. Write-ups are mandatory, not optional.

### 4. Reproducibility Over Novelty

A reproducible, well-documented system beats a cutting-edge system no one else can build or understand. This lab values:
- Clear setup instructions
- Version-pinned dependencies
- Explicit hardware requirements
- Step-by-step configuration procedures

**Implication**: If an experiment cannot be reproduced by following its documentation, it is incomplete. Reproducibility is a first-class requirement.

### 5. Optimize for Learning, Not Speed

This is a research lab, not a production service. Taking time to understand why something works (or doesn't) is more valuable than getting it working quickly. We:
- Measure and profile before optimizing
- Test one variable at a time
- Validate assumptions with data
- Iterate based on observations

**Implication**: Rushing to "done" is discouraged. Thoughtful experimentation with clear methodology is the goal.

### 6. Self-Hosted by Default

Where practical, this lab runs infrastructure on self-hosted hardware rather than cloud services. This constraint forces:
- Deeper understanding of system-level concerns
- Cost optimization through hardware efficiency
- Direct control over the full stack
- Real experience with operational complexity

**Implication**: Cloud services are used only when self-hosting is impractical or instructive to compare. The default assumption is "we run it ourselves."

### 7. Multi-Node Thinking from Day One

Even single-machine experiments are designed with distributed systems in mind. We think about:
- Network communication patterns
- Data locality and transfer costs
- Failure modes and coordination
- Resource isolation and multi-tenancy

**Implication**: Architectures should be extendable to multiple nodes without fundamental redesign. Single-machine simplicity is good; single-machine assumptions are bad.

### 8. Pragmatism Over Purity

The goal is working systems, not perfect systems. We use the right tool for the job, even if it's not the most elegant. We:
- Choose boring, proven technology when possible
- Accept technical debt if it unblocks learning
- Iterate rather than over-engineer upfront
- Simplify architectures as understanding improves

**Implication**: "Good enough" with a plan to improve beats "perfect" in theory. Ship experiments, gather data, refine.

---

## Operational Values

### Clarity
Write documentation as if you're explaining it to yourself in six months. Assume you will forget context.

### Honesty
Report what actually happened, not what was supposed to happen. Failed experiments are published, not hidden.

### Rigor
Measure performance. Validate assumptions. Test edge cases. Anecdotes are interesting; data is required.

### Sustainability
Build systems you can maintain long-term. Avoid complexity that requires heroic effort to operate.

### Generosity
Share findings, tooling, and infrastructure patterns publicly when possible. Infrastructure knowledge should not be gatekept.

---

## Anti-Patterns to Avoid

### ❌ "It works on my machine"
If it can't be reproduced elsewhere, it doesn't work.

### ❌ Undocumented magic
Clever hacks without explanation are future tech debt.

### ❌ Premature optimization
Measure first, optimize second. Guessing at bottlenecks is costly.

### ❌ Vendor lock-in by accident
Understand what choices tie you to specific platforms or products.

### ❌ "This will scale" without evidence
Don't assume. Test under realistic conditions or acknowledge the assumption.

---

## Decision Framework

When evaluating infrastructure choices, ask:

1. **Can we run it ourselves?** (Self-hosting bias)
2. **Can we understand how it works?** (Observability and debuggability)
3. **Can someone else reproduce this?** (Documentation quality)
4. **Does it work under load?** (Real workload validation)
5. **What breaks first?** (Failure mode analysis)
6. **What does this cost?** (Hardware, power, time, complexity)
7. **Does this teach us something?** (Learning value)

---

## Evolution

This philosophy will evolve as the lab grows. Principles that prove impractical will be revised. New principles will be added as patterns emerge.

**Current Version**: 1.0 (2026-02-11)

---

*This document reflects the values and operating principles of Cascadia Mobile Systems Lab. It is a living document and will be updated as the lab matures.*
