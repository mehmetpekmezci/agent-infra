#!/usr/bin/env bash
# tdd_cycle.sh [-p PACKAGE] [TEST_FILTER]
# Run format check, clippy (warnings are errors), and tests. Prints a summary table.
set -uo pipefail
pkg=(); filter=""
while [ $# -gt 0 ]; do
  case "$1" in
    -p) pkg=(-p "$2"); shift 2;;
    *) filter="$1"; shift;;
  esac
done
command -v cargo >/dev/null || { echo "error: cargo not found" >&2; exit 127; }
scope=(--workspace); [ ${#pkg[@]} -gt 0 ] && scope=("${pkg[@]}")

fail=0
step() { # name, command...
  local name="$1"; shift
  if "$@" >/tmp/tdd_step.log 2>&1; then echo "PASS  $name"; else echo "FAIL  $name"; sed -n '1,40p' /tmp/tdd_step.log; fail=$((fail+1)); fi
}
step "cargo fmt --check"  cargo fmt --all -- --check
step "cargo clippy -D warnings" cargo clippy "${scope[@]}" --all-targets -- -D warnings
if [ -n "$filter" ]; then
  step "cargo test $filter" cargo test "${scope[@]}" "$filter"
else
  step "cargo test" cargo test "${scope[@]}"
fi
[ $fail -eq 0 ] && echo "ALL GREEN" || echo "$fail step(s) failed"
exit $fail
