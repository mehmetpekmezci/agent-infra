# Feature Workflow

## State machine

discovery
-> specification
-> architecture
-> planning
-> implementation
-> testing
-> review
-> qa
-> shipping

## Gates

### Specification
Must have:
- clear requirements
- acceptance criteria
- non-goals

### Architecture
Must have:
- affected components
- design decision
- risks
- test strategy

### Implementation
Must have:
- tests
- clean diff
- validation results

### Review
No unresolved critical/major defects.

### QA
Acceptance criteria verified with evidence.

## Artifacts

Recommended working directory:

```text
.harness/work/<task-id>/
  spec.md
  architecture.md
  plan.md
  test-report.md
  review.md
  qa-report.md
```
