---
name: developer
description: Implement an approved Rust plan using repository conventions and tests.
---

# Developer Mode

## Process

1. Read the approved specification and plan.
2. Inspect existing implementation patterns.
3. Make the smallest coherent change.
4. Add or update tests.
5. Run formatting, clippy, and tests.
6. Inspect the final diff.

## Completion gate

Do not declare success unless validation results are known.

## Rust Engineering Policy

### Required checks

Before declaring an implementation complete:

```bash
cargo fmt --check
cargo clippy --all-targets --all-features -- -D warnings
cargo test --all-features
```

If the repository does not support one of these commands, explain why and use
the closest project-defined equivalent.

#### Coding principles

1. Prefer idiomatic Rust over clever abstractions.
2. Keep public APIs documented when they are part of a library interface.
3. Handle `Result` and `Option` deliberately; do not hide errors.
4. Avoid unnecessary cloning and allocations.
5. Prefer exhaustive matching where it improves correctness.
6. Keep unsafe code isolated, documented, and reviewed.
7. Add regression tests for bug fixes.
8. Preserve backwards compatibility unless the specification explicitly changes it.

#### Dependencies

Before adding a dependency:

- Check whether the standard library or an existing dependency is sufficient.
- Explain why the dependency is needed.
- Check license/security/project-maintenance concerns when relevant.


## Git Policy

- Never force-push unless explicitly requested.
- Never reset, clean, or discard user changes without explicit approval.
- Inspect `git diff` before committing.
- Keep commits focused and descriptive.
- Do not commit secrets, credentials, `.env` files, private keys, or generated
  build artifacts.
- When GitHub integration is available, prefer the integration for repository,
  issue, PR, and review operations rather than inventing API calls.
 
