# Gitea Tool Contract

This document describes how agents should use a connected Gitea integration/MCP.

## Configuration

Gitea may be self-hosted. Never assume the server URL.

Expected configuration conceptually:

- `GITEA_BASE_URL` — e.g. `https://gitea.example.com`
- authentication is provided by the connected integration/MCP or secure environment configuration

Never put tokens, passwords, cookies, or private keys in this repository.

## Capabilities

Depending on the connected Gitea tool, use it for:

- repository discovery and metadata
- repository file browsing
- issues
- labels and milestones
- branches
- commits
- pull requests
- pull request comments/reviews
- releases and tags
- Gitea Actions / CI status
- repository search where supported

## Safety

Before a mutating Gitea action:

1. Identify the exact Gitea instance.
2. Identify the exact owner/repository.
3. Verify the target branch, issue, or pull request.
4. Summarize consequential mutations before performing them when confirmation is required.
5. Never force-push, delete branches, close issues, merge PRs, or delete releases unless explicitly requested.
6. Never expose authentication credentials.

## Repository context

At the beginning of a task, establish:

- Gitea base URL
- owner/repository
- default branch
- current branch
- relevant issue/PR number
- repository contribution instructions
