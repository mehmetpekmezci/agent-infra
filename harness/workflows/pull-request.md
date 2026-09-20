# Pull Request Workflow

Provider-neutral workflow for GitHub or Gitea.

## Flow

inspect repository
-> inspect issue/specification
-> create or verify branch
-> implement
-> test
-> inspect diff
-> push
-> create/update PR
-> inspect CI
-> review
-> QA

## Provider selection

Use `.harness/skills/repository/SKILL.md` to determine whether the remote is
GitHub or Gitea.

## Completion

Do not claim the PR is ready until:

- local validation has been performed
- the final diff has been inspected
- remote CI status has been checked when available
- relevant review comments have been addressed
