# Experiment: [Title]

**Date**: YYYY-MM-DD
**Category**: [gpu-acceleration | model-serving | data-pipelines | storage-systems | virtualization | networking]
**Status**: [Planned | In Progress | Completed | Archived]
**Experimenter**: [Your Name]

---

## Objective

*What are you trying to learn, build, or validate?*

State the goal in 1-2 sentences. Be specific about what success looks like.

---

## Hypothesis

*What do you expect to happen?*

If this is a performance test: what metrics do you expect to see?
If this is a feasibility test: do you expect this approach to work?
If this is a comparison: which option do you expect to perform better, and why?

---

## Context

*Why is this experiment relevant? What prior work or decisions led here?*

- Link to related experiments
- Reference decision logs
- Cite external research or documentation
- Explain what gap in knowledge this fills

---

## Methodology

*How will you test your hypothesis?*

Describe the approach step-by-step:
1. Setup and configuration
2. Workload or test procedure
3. Data collection approach
4. Analysis method

Be detailed enough that someone else could reproduce this.

---

## Environment

### Hardware
- CPU:
- GPU:
- RAM:
- Storage:
- Network:

### Software
- OS:
- Kernel version:
- Driver versions:
- Key dependencies and versions:

### Configuration
- Link to config files or include relevant snippets
- Note any non-default settings
- Document environment variables

---

## Setup Instructions

*Step-by-step instructions to reproduce this environment.*

```bash
# Example:
# 1. Install dependencies
sudo apt install ...

# 2. Configure system
./setup.sh

# 3. Verify installation
./verify-setup.sh
```

Include any prerequisites, download links, or access requirements.

---

## Execution

### Duration
- **Estimated**: X hours/days
- **Actual**: X hours/days (fill in after completion)

### Procedure

*Detailed steps to run the experiment.*

1. Step one
2. Step two
3. ...

Include any parameters, flags, or commands used.

### Data Collection

*What metrics are being captured and how?*

- Metric name (unit) - collection method
- Example: GPU utilization (%) - nvidia-smi every 5s
- Example: Request latency (ms) - application logs

---

## Expected Outcomes

*What does success look like? What metrics validate the hypothesis?*

Define:
- Success criteria (e.g., "throughput > 100 req/s")
- Acceptable ranges
- Key metrics to evaluate

---

## Risk Assessment

*What could go wrong? What are the mitigation strategies?*

- Risk 1: [Description] - Mitigation: [Approach]
- Risk 2: [Description] - Mitigation: [Approach]

---

## Results

*To be filled during/after execution. Move detailed results to RESULTS.md.*

### Summary
[1-2 sentence summary of findings]

### Key Metrics
- Metric 1: [Value] (vs. expected: [Value])
- Metric 2: [Value] (vs. expected: [Value])

### Observations
- Notable finding 1
- Notable finding 2

### Issues Encountered
- Problem 1 and resolution
- Problem 2 and resolution

---

## Analysis

*What do the results mean? Did they confirm or contradict the hypothesis?*

- Interpretation of data
- Comparison to baseline or expectations
- Identification of bottlenecks or limitations
- Unexpected findings

---

## Conclusions

### What Worked
- Success 1
- Success 2

### What Didn't Work
- Failure 1 and likely reason
- Failure 2 and likely reason

### Lessons Learned
- Key insight 1
- Key insight 2

### Confidence Level
[High | Medium | Low] - Why?

---

## Next Steps

*What should be done based on these findings?*

- [ ] Follow-up experiment to test X
- [ ] Investigate anomaly in Y
- [ ] Apply findings to infrastructure component Z
- [ ] Document pattern for future use

---

## References

### Internal
- Related experiments: [Links]
- Decision logs: [Links]
- Infrastructure docs: [Links]

### External
- Papers: [Citations]
- Documentation: [URLs]
- Tools: [Links]

---

## Artifacts

*Links to outputs, data, code, configs*

- Raw data: `outputs/data.csv`
- Logs: `logs/experiment-YYYYMMDD.log`
- Plots/graphs: `outputs/graphs/`
- Code: `src/`
- Configs: `config/`

---

## Metadata

**Created**: YYYY-MM-DD
**Last Updated**: YYYY-MM-DD
**Total Time Investment**: X hours
**Cost**: $X (hardware, cloud, power)

---

*This template ensures consistent, reproducible, and well-documented experiments across Cascadia AI Systems Lab.*
