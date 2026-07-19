# Experiments Index

**Active, planned, and completed experiments at Cascadia Mobile Research**

---

## Purpose

This index tracks all lab experiments, their status, and key findings. It is the repository counterpart of the site's [Lab Notes](https://cascadiasystems.org/research/) page — the two are kept in sync.

---

## Active Experiments

*Currently running or in-progress experiments.*

| Experiment | Category | Started | Status | Priority |
|------------|----------|---------|--------|----------|
| - | - | - | - | - |

---

## Planned Experiments

*Experiments on the bench but not yet started. These match the Lab Notes page.*

| ID | Experiment | Category | Objective | Dependencies |
|----|------------|----------|-----------|--------------|
| EXP-001 | Photogrammetry vs. LiDAR SLAM Accuracy | Capture Methods | Capture the same site both ways; compare geometric accuracy, coverage, capture time, and processing cost quantitatively (CloudCompare) | Test site selection; ground-reference workflow |
| EXP-002 | Self-Hosted Photogrammetry vs. Cloud Services | Processing | Benchmark an open-source pipeline on owned GPU hardware against commercial cloud processing: quality, turnaround, cost per project | Representative capture dataset |
| EXP-003 | Corridor Mapping Sample Deliverable | Deliverables | Produce and publish a complete corridor package (orthomosaic, elevation model, report) for a public right-of-way segment as a worked example | Site/airspace selection |
| EXP-004 | Magnetometry Processing Pipeline | Geophysics | Data handling, filtering, and visualization for magnetometer surveys, developed against public geophysical datasets before hardware is fielded | Public dataset selection (in development) |

---

## Completed Experiments

*No completed experiments yet. Write-ups will be added here and surfaced on the site as they finish.*

---

## Archived Experiments

| Experiment | Category | Completed | Outcome | Link |
|------------|----------|-----------|---------|------|
| - | - | - | - | - |

---

## Experiments by Category

### Capture Methods
*Drone photogrammetry, LiDAR SLAM, repeatable capture planning, ground truth.*
- EXP-001 (planned)

### Processing
*Self-hosted photogrammetry/SLAM pipelines, GPU workloads, storage and compute sizing.*
- EXP-002 (planned)

### Deliverables
*Orthomosaics, elevation models, point clouds, accuracy reporting.*
- EXP-003 (planned)

### Geophysics
*Magnetometry and custom sensing.*
- EXP-004 (in development)

---

## Experiment Statistics

**Total Experiments**: 4
- Active: 0
- Completed: 0
- Planned: 4
- Archived: 0

---

## How to Add an Experiment

1. Create experiment directory following [naming conventions](../architecture/STANDARDS.md#naming-conventions)
2. Copy [experiment template](TEMPLATE.md) to `README.md` in experiment directory
3. Add entry to this index in "Planned" or "Active" section
4. Begin experiment execution
5. Update status as experiment progresses
6. Move to "Completed" when finished — and update the site's Lab Notes page in the same change

---

**Last Updated**: 2026-07-19

*This index is maintained manually. Update it whenever experiment status changes.*
