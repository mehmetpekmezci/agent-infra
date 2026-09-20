# Harness Router

Route requests to the smallest appropriate workflow.

| User intent | Workflow |
|---|---|
| New feature | `feature.md` |
| Bug/failure | `bugfix.md` |
| Refactoring | `refactor.md` |
| Create/update PR | `pull-request.md` |
| Root-cause investigation | `debugging` skill |

## Repository routing

For remote operations:

1. Inspect `git remote -v`.
2. Select GitHub or Gitea provider.
3. Load provider-neutral repository skill.
4. Load the provider-specific skill/tool contract.

The development workflow should remain identical across providers whenever
possible.
