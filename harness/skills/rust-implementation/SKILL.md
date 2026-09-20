---
name: rust-implementation
description: Implement approved Rust specifications using idiomatic, minimal, testable changes.
---

# Rust Implementation

Before editing:

- read the specification
- inspect relevant modules
- inspect nearby tests
- identify project conventions

During implementation:

- prefer existing abstractions
- minimize public API changes
- handle errors explicitly
- avoid unnecessary allocations/clones
- add regression tests

After implementation:

```bash
cargo fmt --check
cargo clippy --all-targets --all-features -- -D warnings
cargo test --all-features
```
