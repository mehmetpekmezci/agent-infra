---
name: gitea
description: Use connected Gitea tooling for repository, issue, pull request, review, branch, release, and CI operations.
---

# Gitea Skill

Use the connected Gitea integration/MCP for remote repository operations.

## Common tasks

### Repository

- inspect repository metadata
- browse files
- inspect branches
- inspect commits

### Issues

- read issue
- search issues
- create issue
- comment
- update labels/milestones when requested

### Pull requests

- inspect PR
- inspect changed files
- inspect comments/reviews
- create PR
- comment on PR
- submit review when supported

### CI

Inspect Gitea Actions/check status before declaring a remote change ready.

## Self-hosted instances

Always use the configured Gitea base URL. Do not assume `gitea.com`.

## Authentication

Credentials belong to the external tool/integration or secure environment.
Never place tokens in `SKILL.md`, source code, workflow artifacts, or commits.
