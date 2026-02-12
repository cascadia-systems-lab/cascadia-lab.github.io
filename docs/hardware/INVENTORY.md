# Hardware Inventory

**Physical infrastructure for Cascadia AI Systems Lab**

---

## Purpose

This document tracks all hardware in the lab, including specifications, performance baselines, current roles, and physical locations. Accurate hardware documentation enables informed infrastructure decisions and reproducible experiments.

---

## Compute Nodes

### Node 1: [Hostname/Identifier]

**Status**: [Planned | Active | Maintenance | Decommissioned]
**Acquired**: YYYY-MM-DD
**Location**: [Physical location]
**Primary Role**: [e.g., GPU workstation, inference server, storage node]

#### Specifications
- **CPU**: [Model, cores, threads, base/boost clock]
- **GPU**: [Model, VRAM, CUDA cores, tensor cores]
- **RAM**: [Capacity, type, speed, channels]
- **Storage**:
  - Boot: [Type, capacity, interface]
  - Data: [Type, capacity, interface]
  - Cache: [Type, capacity, interface]
- **Network**: [NIC model, speed, interface type]
- **Power Supply**: [Wattage, efficiency rating]
- **Cooling**: [Air/liquid, configuration]

#### Performance Baseline
- **GPU Compute**: TBD (TFLOPS fp32/fp16/int8)
- **Memory Bandwidth**: TBD (GB/s)
- **Storage I/O**: TBD (seq read/write MB/s, IOPS)
- **Network Throughput**: TBD (Gbps)
- **Power Draw**: TBD (idle/load watts)

#### Software Configuration
- **OS**: [Distribution, version, kernel]
- **GPU Driver**: [Version]
- **CUDA**: [Version]
- **Container Runtime**: [Docker/Podman version]

#### Notes
- [Any special considerations, known issues, modifications]

---

## Storage Systems

*Dedicated storage nodes or NAS systems.*

### Storage 1: [Identifier]

**Status**: [Planned | Active | Maintenance | Decommissioned]
**Acquired**: YYYY-MM-DD
**Location**: [Physical location]
**Purpose**: [e.g., object storage, model repository, dataset cache]

#### Specifications
- **Capacity**: [Total raw capacity]
- **Drives**: [Number, type, capacity per drive]
- **RAID/Pool**: [Configuration, usable capacity]
- **Controller**: [Model, cache size]
- **Network**: [Interface, speed]

#### Performance Baseline
- **Sequential Read/Write**: TBD (MB/s)
- **Random IOPS**: TBD (4K reads/writes)
- **Latency**: TBD (ms)

#### Notes
- [RAID level, deduplication, compression settings]

---

## Network Infrastructure

### Switch/Router: [Model]
- **Ports**: [Number and type]
- **Speed**: [Per-port speed]
- **Features**: [Managed/unmanaged, VLAN support, etc.]
- **Location**: [Physical location]

### Network Topology
```
[Diagram or description of network layout]

Example:
Internet → Router → Switch → Node1
                           → Node2
                           → Storage1
```

---

## Peripherals & Accessories

### UPS (Uninterruptible Power Supply)
- **Model**: [Model number]
- **Capacity**: [VA/Watt rating]
- **Runtime**: [Estimated runtime at load]
- **Protected Devices**: [What's connected]

### KVM / Remote Access
- **Type**: [Hardware KVM, IPMI, etc.]
- **Access**: [How to access]

### Other Equipment
- [List any other relevant equipment]

---

## Planned Hardware Acquisitions

| Item | Purpose | Priority | Est. Cost | Target Date |
|------|---------|----------|-----------|-------------|
| - | - | - | - | - |

---

## Hardware Performance Summary

*Aggregate capabilities of the lab.*

- **Total GPU Memory**: TBD GB
- **Total System Memory**: TBD GB
- **Total Storage**: TBD TB (raw) / TBD TB (usable)
- **Total Compute (FP16)**: TBD TFLOPS
- **Network Bandwidth**: TBD Gbps
- **Power Capacity**: TBD kW

---

## Hardware Decision Rationale

### Why This Hardware?

*Document key hardware selection decisions.*

#### GPU Choice
- [Rationale for GPU model(s) selected]
- [Alternatives considered]
- [Price/performance considerations]

#### Storage Strategy
- [Why this storage configuration]
- [Trade-offs accepted]
- [Future expansion plan]

#### Network Design
- [Why this topology]
- [Bandwidth requirements]
- [Future scaling considerations]

---

## Maintenance Log

| Date | Node | Action | Reason | Outcome |
|------|------|--------|--------|---------|
| - | - | - | - | - |

---

## Physical Layout

*Description or diagram of physical server rack / workspace layout.*

```
[Rack layout, cable management, cooling airflow, etc.]
```

---

## Environmental Conditions

- **Temperature**: [Ambient temp range]
- **Humidity**: [If monitored]
- **Power**: [Electrical capacity, breaker ratings]
- **Cooling**: [Active cooling, airflow strategy]

---

## Warranty & Support

| Device | Warranty Expiry | Support Contact | Notes |
|--------|-----------------|-----------------|-------|
| - | - | - | - |

---

## Hardware Monitoring

*How hardware health is monitored.*

- **Tools**: [DCGM, SMART monitoring, IPMI, etc.]
- **Metrics**: [What's tracked]
- **Alerting**: [What triggers alerts]

---

**Last Updated**: 2026-02-11

*This inventory should be updated whenever hardware is added, removed, or reconfigured.*
