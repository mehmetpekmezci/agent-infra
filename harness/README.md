# Rust Coding Harness

A project-local, agent-agnostic harness designed to be consumed by Kilo Code
and other Agent Skills-compatible coding agents.

## Structure

- `skills/` — reusable engineering procedures
- `modes/` — specialized agent roles
- `workflows/` — multi-step development workflows
- `policies/` — project-wide rules
- `tools/` — tool contracts/configuration notes

## Rust defaults

This harness assumes:

- Rust 2021+ / current stable toolchain
- `cargo fmt` before completion
- `cargo clippy --all-targets --all-features -- -D warnings`
- `cargo test --all-features`
- Prefer small, testable changes
- Avoid `unsafe` unless justified and reviewed
- Do not commit secrets

## GitHub

The harness is intentionally provider-neutral. GitHub operations are described
in `.harness/tools/github.md`. Connect GitHub through the GitHub integration/MCP
available in your Kilo environment rather than embedding credentials in this repo.

## Suggested flow

feature -> specification -> architecture -> implementation -> testing -> review -> QA

## Kilo integration

For Kilo project discovery, mirror or link the skills under `.harness/skills/`
into the Kilo-supported project skill directory (`.kilo/skills/`) as appropriate
for your Kilo version.

## v0.2 additions

This version adds provider-neutral repository operations plus GitHub and Gitea
skills/contracts. The same feature/bugfix/refactor workflow can therefore be
used with either hosting provider.
