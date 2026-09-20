---
name: repository
description: Work with the project's remote Git repository through a provider-neutral GitHub or Gitea workflow.
---

# Repository Skill

## Goal

Perform repository operations without coupling the development workflow to a
specific hosting provider.

## Procedure

1. Inspect `git remote -v`.
2. Identify whether the remote is GitHub, Gitea, or another supported provider.
3. Load the matching provider contract.
4. Establish repository, branch, issue/PR, and CI context.
5. Perform only the requested operation.
6. Report the provider and exact object affected.

## Provider mapping

- GitHub -> `.harness/tools/github.md`
- Gitea -> `.harness/tools/gitea.md`

## Safety

Never:

- expose credentials
- invent repository URLs
- force-push without explicit instruction
- delete remote data without explicit instruction
- merge or close a PR merely because tests pass

Prefer provider-native tools/integrations when available.
