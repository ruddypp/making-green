#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

expected=(
  commit-message-style
  commit-planner
  contribution-hygiene
  git-rollback
  making-green
  safe-staging
)

for skill in "${expected[@]}"; do
  test -f "skills/$skill/SKILL.md"
done

test -f "skills/making-green/references/strict-checklist.md"
test -x "scripts/cleanup-checkpoints.sh"
test -x "scripts/inspect-risk.sh"

output="$(npx skills add . --list)"

printf '%s\n' "$output" | grep -q "Found 6 skills"

for skill in "${expected[@]}"; do
  printf '%s\n' "$output" | grep -q "$skill"
done

echo "smoke test passed"
