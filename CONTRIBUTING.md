# Contributing to Cascadia AI Systems Lab

Thank you for your interest in contributing to Cascadia AI Systems Lab. This document outlines how to contribute effectively to this infrastructure research environment.

---

## Understanding the Lab

Cascadia AI Systems Lab is not a traditional software project—it's an infrastructure laboratory focused on building, testing, and documenting AI systems. Contributions here may include:

- Infrastructure experiments and findings
- Tooling and automation
- Documentation improvements
- Operational procedures
- Performance benchmarks
- Architectural insights

---

## Getting Started

### Prerequisites

Before contributing:
1. Read the [Lab Philosophy](docs/architecture/LAB_PHILOSOPHY.md)
2. Review [Standards & Conventions](docs/architecture/STANDARDS.md)
3. Understand the [Architecture Overview](docs/architecture/OVERVIEW.md)
4. Familiarize yourself with the [Experiment Index](docs/experiments/INDEX.md)

### Communication

- **Questions**: Open an issue or discussion
- **Proposals**: Create a decision log draft in `docs/decisions/`
- **Experiments**: Follow the experiment template and coordinate with lab maintainers

---

## Types of Contributions

### 1. Experiments

**What**: Structured investigations into infrastructure behavior or performance.

**How to contribute**:
1. Propose experiment in issue or discussion
2. Create experiment directory following naming conventions
3. Use [Experiment Template](docs/experiments/TEMPLATE.md)
4. Document methodology, environment, and setup
5. Conduct experiment and document findings
6. Submit pull request with complete documentation

**Requirements**:
- Clear hypothesis and methodology
- Reproducible setup instructions
- Raw data or links to results
- Honest assessment (including failures)

### 2. Documentation

**What**: Improvements to architecture docs, runbooks, or standards.

**How to contribute**:
1. Identify documentation gap or inaccuracy
2. Propose change via issue or PR
3. Follow markdown conventions
4. Update related documents if needed
5. Submit pull request

**Examples**:
- Adding runbook for new infrastructure component
- Documenting decision rationale in decision log
- Updating architecture overview with new patterns
- Fixing typos or clarifying instructions

### 3. Tooling

**What**: Utilities for lab operations, diagnostics, or automation.

**How to contribute**:
1. Identify operational need
2. Build tool following script standards
3. Test thoroughly in isolated environment
4. Document usage and prerequisites
5. Submit pull request with tool and documentation

**Requirements**:
- Clear purpose and usage documentation
- Safe operation (dry-run for destructive actions)
- Error handling and logging
- Help flag (`--help`)

### 4. Infrastructure Code

**What**: Configuration management, provisioning, or orchestration code.

**How to contribute**:
1. Propose change via decision log or issue
2. Test in isolated environment
3. Document rollback procedure
4. Create runbook entry
5. Submit pull request with code and docs

**Requirements**:
- Idempotent and reproducible
- Documented configuration options
- Tested in realistic conditions
- Includes monitoring/alerting considerations

### 5. Research & Analysis

**What**: External research, performance analysis, or comparative studies.

**How to contribute**:
1. Document research question or goal
2. Conduct analysis or literature review
3. Synthesize findings
4. Add to `research/` directory with clear documentation
5. Link from relevant experiments or decision logs

---

## Contribution Workflow

### 1. Before Starting

- Check existing issues and experiments to avoid duplication
- Open an issue to discuss significant changes
- Coordinate with lab maintainers if unsure

### 2. During Development

- Follow [Standards & Conventions](docs/architecture/STANDARDS.md)
- Document as you go, don't wait until the end
- Test in isolated environment before applying to shared infrastructure
- Commit frequently with clear commit messages

### 3. Submitting Changes

- Ensure all documentation is complete
- Run any relevant tests or validation
- Create pull request with clear description
- Link related issues or decision logs
- Respond to review feedback

### 4. After Merge

- Update experiment index if applicable
- Monitor for any unexpected issues
- Update runbooks if operational procedures changed

---

## Commit Message Conventions

Use conventional commits format:

```
type(scope): description

Examples:
feat(monitoring): add GPU memory tracking dashboard
fix(storage): correct NFS mount path in config
docs(experiments): document vLLM baseline results
infra(cluster): update k3s to v1.28
experiment(gpu): complete inference latency baseline
```

**Types**:
- `feat`: New feature or capability
- `fix`: Bug fix
- `docs`: Documentation changes
- `infra`: Infrastructure configuration
- `experiment`: Experiment work
- `tooling`: New or updated tools
- `refactor`: Code restructuring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

---

## Code Review Process

### What We Look For

- **Correctness**: Does it work as intended?
- **Safety**: Are there risks or failure modes?
- **Documentation**: Is it well-documented?
- **Reproducibility**: Can someone else reproduce this?
- **Standards**: Does it follow lab conventions?

### Review Timeline

- Simple docs/fixes: 1-2 days
- Experiments: 3-5 days (time to review methodology and findings)
- Infrastructure changes: 5-7 days (requires careful review)

---

## Testing Standards

### For Experiments
- Document environment precisely
- Include reproducible setup
- Validate metrics collection
- Test in realistic conditions

### For Infrastructure
- Test in isolated environment first
- Validate idempotency
- Test rollback procedure
- Monitor for unexpected side effects

### For Tools
- Test with valid inputs
- Test with invalid inputs
- Test interruption handling (Ctrl+C)
- Verify cleanup on exit

---

## Documentation Standards

All contributions must include appropriate documentation:

- **Experiments**: Complete README.md and RESULTS.md
- **Infrastructure**: Runbook entry and decision log (if significant)
- **Tools**: Usage documentation and examples
- **Code**: Inline comments explaining "why" not "what"

See [Documentation Standards](docs/architecture/STANDARDS.md#documentation-standards) for details.

---

## Questions or Issues?

### Getting Help

- **General questions**: Open a discussion
- **Bug reports**: Open an issue with reproduction steps
- **Feature proposals**: Open an issue or create decision log draft
- **Security concerns**: Contact maintainers privately

### Response Times

This is an infrastructure lab, not a production service. Response times may vary:
- Urgent operational issues: Same day
- Bug reports: 2-3 days
- Feature requests: 1 week
- General questions: 3-5 days

---

## Recognition

Contributors will be:
- Credited in experiment documentation they author
- Listed in CONTRIBUTORS.md (to be created)
- Acknowledged in decision logs they help write
- Recognized in release notes (if applicable)

---

## Code of Conduct

### Expected Behavior

- Be respectful and constructive
- Focus on technical merit
- Document honestly (including failures)
- Help others learn and grow
- Maintain professional communication

### Unacceptable Behavior

- Personal attacks or harassment
- Dismissing others' contributions
- Withholding critical information
- Claiming credit for others' work
- Ignoring safety or security concerns

---

## License

By contributing, you agree that your contributions will be licensed under the same terms as the project (TBD based on component type).

---

## Evolution

This contribution guide will evolve as the lab grows. Suggestions for improving this process are welcome.

**Last Updated**: 2026-02-11

---

*Thank you for contributing to Cascadia AI Systems Lab. Your work helps advance practical AI infrastructure knowledge.*
