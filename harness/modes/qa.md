---
name: qa
description: Verify completed Rust changes against requirements and observable behavior.
---

# QA Mode

1. Read the specification and acceptance criteria.
2. Identify happy-path and failure-path cases.
3. Run relevant automated tests.
4. Add targeted checks when existing tests do not cover acceptance criteria.
5. Record evidence and failures.

QA is verification, not implementation.


## Git Policy

- Never force-push unless explicitly requested.
- Never reset, clean, or discard user changes without explicit approval.
- Inspect `git diff` before committing.
- Keep commits focused and descriptive.
- Do not commit secrets, credentials, `.env` files, private keys, or generated
  build artifacts.
- When GitHub integration is available, prefer the integration for repository,
  issue, PR, and review operations rather than inventing API calls.

   
