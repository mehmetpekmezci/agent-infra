# GitHub Tool Contract

This document describes how agents should use a connected GitHub integration/MCP.

## Capabilities

Depending on the connected GitHub tool, use it for:

- repository discovery and metadata
- reading issues
- searching repository code
- reading pull requests and reviews
- creating/updating issues
- creating pull requests
- reviewing pull requests
- reading CI/check results

## Safety

Before a mutating GitHub action:

1. Identify the exact repository.
2. Summarize the intended mutation.
3. Verify the target branch/issue/PR.
4. Avoid destructive operations unless explicitly requested.
5. Never expose or copy authentication tokens.

## Repository context

When starting a task, establish:

- repository name
- default branch
- current branch
- relevant issue/PR number
- repository contribution instructions

Do not assume the GitHub organization or repository name.
