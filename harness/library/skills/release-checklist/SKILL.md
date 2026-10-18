---
name: release-checklist
description: Run the final quality checks before a release - build, lint, test, audit, version, changelog, open issues, requirement coverage, and architecture status - and report a clear pass or fail with evidence. Use this skill whenever the Qa role gets a release or final-check issue, before any package is built, or when anyone asks whether the project is ready to ship.
---

# release-checklist

Qa is the last gate. A defect that passes this gate reaches the user. The gate must be repeatable, so it is a script, plus a short list of checks that need reading.

## Procedure

1. Read the issue, the release scope, and the wiki pages `Requirements Index` and `Architecture Status` (`gitea-wiki`).
2. Run the automatic gate:

```bash
$AGENT_INFRA_DIR/harness/library/skills/release-checklist/scripts/release_gate.sh <project-dir>
```

It prints PASS, FAIL, or WARN per check and exits with the number of failures.
3. Do the checks that need reading, from `references/checklist.md`: requirement coverage, open issues, architecture findings, Reviewer approval.
4. If anything FAILs, do not build packages. Comment with the failing checks and their output. Return the issue to the Coordinator as `blocked`. Never fix code as Qa.
5. If everything passes, continue with `rpm-deb-packaging`.
6. Comment on the issue (`issue-comment-protocol`): gate result, version, list of WARN items with your judgement, and the evidence for each reading check.

## Rules

- A WARN is a decision, not noise. Say why it is acceptable or escalate it.
- Do not skip a check because it passed last time.
- Do not change the version number. The Coordinator or the Human sets it.
