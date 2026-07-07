# Skill Package Commit Plan

Scenario: adding a new public skill package.

Expected high-granularity plan:

```text
Commit 1: chore(repo): add ignore rules
Commit 2: docs(readme): introduce skill package
Commit 3: docs(readme): add install commands
Commit 4: docs(readme): document remote handling
Commit 5: docs(readme): explain checkpoint tag policy
Commit 6: feat(commit-planner): add invocation metadata
Commit 7: feat(commit-planner): define planning goals
Commit 8: feat(commit-planner): add granularity targets
Commit 9: feat(commit-planner): add plan examples
Commit 10: feat(safe-staging): add protected content rules
Commit 11: feat(safe-staging): add staging workflow
Commit 12: feat(commit-message-style): define message format
Commit 13: feat(commit-message-style): add readability rules
Commit 14: feat(git-rollback): add revert workflow
Commit 15: feat(contribution-hygiene): add quality invariant
Commit 16: feat(making-green): add orchestrator workflow
Commit 17: test(smoke): verify skills package discovery
```

The exact count can change. The important rule: each commit must remain reviewable, revertable, and readable.
