# Repository Provider Contract

Workflows should depend on this provider-neutral interface rather than directly
depending on GitHub or Gitea.

## Read operations

- get repository metadata
- get repository/default branch
- inspect files
- search repository
- inspect issue
- inspect pull request
- inspect comments/reviews
- inspect CI/check status

## Write operations

- create branch
- push changes
- create issue
- create pull request
- comment on issue/PR
- update issue/PR metadata
- request/review a pull request
- create release

## Provider selection

Use the repository's actual remote and available integrations.

Typical detection:

```bash
git remote -v
```

Examples:

- `github.com/...` -> GitHub provider
- `gitea.example.com/...` -> Gitea provider

Do not infer credentials from the remote URL.

## Provider adapters

- GitHub: `.harness/tools/github.md`
- Gitea: `.harness/tools/gitea.md`

If a required operation is not supported by the connected provider tool,
state that limitation rather than silently substituting an unsafe workaround.
