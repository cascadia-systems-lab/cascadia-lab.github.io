# Research

External research, academic papers, vendor documentation, and theoretical explorations relevant to Cascadia AI Systems Lab work.

## Purpose

This directory stores research materials that inform lab experiments and infrastructure decisions. It serves as a curated library of relevant external knowledge.

## Organization

- **papers/** - Academic papers, white papers, technical reports
- **findings/** - Synthesized research findings and literature reviews
- **ideas/** - Future research directions and unexplored concepts

## What Goes Here

### Papers
- Academic research on AI systems, distributed computing, storage architectures
- Vendor white papers on hardware capabilities and optimizations
- Technical reports from industry labs and research groups
- Conference proceedings and workshop papers

**Format**: Store as PDFs with descriptive filenames

**Naming**: `YYYY-author-short-title.pdf`

Example: `2024-nvidia-h100-performance.pdf`

### Findings
Synthesized research summaries that answer specific questions:
- "What are current best practices for LLM inference serving?"
- "How do different GPU memory management strategies compare?"
- "What storage architectures work best for training data?"

**Format**: Markdown documents with citations

**Structure**:
```markdown
# Research Question

## Summary
[1-2 paragraph synthesis]

## Key Findings
- Finding 1
- Finding 2

## Relevant Papers
- Citation 1
- Citation 2

## Implications for Lab
- How this informs our work

## Open Questions
- What's still unknown
```

### Ideas
Speculative research directions and unexplored concepts:
- "Could we use X technology for Y purpose?"
- "What if we tried approach Z?"
- "Investigate whether A is feasible"

**Format**: Markdown notes, can be informal

**Purpose**: Capture ideas for future investigation

## Citation Format

Use consistent citation format for papers:

```
Author, A., Author, B. (Year). Title of paper. Conference/Journal. DOI/URL
```

Example:
```
Brown, T., et al. (2020). Language Models are Few-Shot Learners.
NeurIPS 2020. https://arxiv.org/abs/2005.14165
```

## Integration with Lab Work

Research here should:
- **Inform experiments**: Background reading before designing experiments
- **Support decisions**: Cited in decision logs when relevant
- **Validate approaches**: Used to compare lab findings with published results
- **Inspire exploration**: Generate new experiment ideas

## Linking Research to Work

In experiment documentation or decision logs, reference research materials:

```markdown
## References

### External Research
- [Brown et al. 2020](../../research/papers/2020-brown-gpt3.pdf) -
  Few-shot learning with large language models
- [Findings: LLM Inference Optimization](../../research/findings/llm-inference-optimization.md)
```

## Research Questions to Explore

*Active research areas relevant to lab work.*

### Infrastructure
- What are the performance characteristics of different GPU memory allocation strategies?
- How does network topology affect distributed training efficiency?
- What storage architectures minimize I/O bottlenecks for AI workloads?

### AI Systems
- What are the trade-offs between different model serving frameworks?
- How do quantization techniques affect inference latency and accuracy?
- What are best practices for multi-tenant GPU sharing?

### Operations
- How should AI infrastructure be monitored differently from traditional infrastructure?
- What are failure modes specific to GPU workloads?
- How can we optimize power efficiency in AI compute clusters?

---

## Avoiding Information Overload

### Quality Over Quantity
Don't store every paper you find. Focus on:
- Directly relevant to lab work
- High-quality sources (peer-reviewed, reputable vendors)
- Practical applicability
- Novel insights or comprehensive surveys

### Regular Curation
- Review research materials quarterly
- Remove superseded or irrelevant papers
- Update findings docs with new information
- Archive outdated materials

---

## Copyright and Fair Use

**Academic Papers**:
- Many papers are open-access (arXiv, conference proceedings)
- Check licensing before storing proprietary papers
- Maintain original attribution

**Vendor Documentation**:
- Freely available technical documentation is fine
- Respect vendor copyright on proprietary materials
- Link to online resources when possible

**Fair Use**:
- Research for non-commercial infrastructure lab work
- Keep only what's necessary for reference
- Cite sources properly

---

## Research Workflow

### 1. Identify Research Need
- What question does this answer?
- How does it relate to lab work?

### 2. Find Relevant Materials
- Search academic databases (arXiv, Google Scholar)
- Review vendor documentation
- Check industry blogs and conference talks

### 3. Store and Organize
- Save papers with descriptive filenames
- Create finding doc if synthesizing multiple sources
- Add to research questions list if exploring new area

### 4. Link to Lab Work
- Reference in experiment documentation
- Cite in decision logs
- Use to validate or inspire experiments

---

## Tools for Research

### Searching
- **arXiv**: AI/ML preprints and papers
- **Google Scholar**: Academic search
- **Papers With Code**: ML papers with implementations
- **Vendor Sites**: NVIDIA, AMD, Intel technical docs

### Organizing
- Use descriptive filenames
- Tag with topics if using external tools
- Keep notes in findings/ directory

### Reading
- Skim abstract and conclusion first
- Focus on methodology and results
- Note limitations and caveats
- Extract actionable insights

---

## Related Documentation

- [Architecture Overview](../docs/architecture/OVERVIEW.md)
- [Decision Logs](../docs/decisions/)
- [Experiment Index](../docs/experiments/INDEX.md)

---

**Note**: Research here supports lab work but is not a substitute for hands-on experimentation. Theory informs practice, but validation comes from running real workloads on real infrastructure.
