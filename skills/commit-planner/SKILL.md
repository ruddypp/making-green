---
name: commit-planner
description: Plan a sequence of small, meaningful git commits from a dirty worktree. Use before committing, before using making-green, when changes span multiple files or multiple intents, or when an agent needs to split one file into several reviewable commits without creating fake commit noise.
---

# Commit Planner

Create a commit plan before staging. The plan is the contract for all later commits.

Use this skill directly, or as the first planning phase of `$making-green`.

## Goal

Maximize meaningful commit count. Never create empty, misleading, or fake commits.

Each planned commit must answer:

- what changes
- why it belongs alone
- which files or hunks belong to it
- whether it can be reverted without removing unrelated work

## Inputs

Run:

```bash
git status --short --branch
git diff --stat
git diff --name-only
git diff
```

If staged changes already exist, inspect them too:

```bash
git diff --cached --stat
git diff --cached
```

Do not assume every file equals one commit. One file can contain many commit units, and one commit can touch multiple files if the intent is one behavior.

## Commit Unit Rules

Create separate commits for separate intents:

- independent bug fixes
- separate UI changes
- separate validation rules
- separate refactor steps
- config/tooling updates
- documentation updates
- tests that specify one behavior
- formatting-only changes, when formatting is not mixed with behavior

Keep changes together when splitting would mislead review:

- implementation and matching test for one behavior
- type/schema update and required call-site update
- rename and references needed for code to keep building
- one UI state spread across component, style, and test files

If one hunk contains multiple intents but cannot be split safely, plan one small combined commit and mark why it is combined.

## Plan Format

Write the plan before staging:

```text
Commit 1: fix(auth): reject expired sessions
Intent: one bug fix in session validation.
Files/hunks: src/auth/session.ts expiration branch; tests/auth/session.test.ts expired-token case.
Why separate: can revert without touching UI or docs.
Validation: git diff --check; formatter if needed.

Commit 2: docs(auth): document session expiry behavior
Intent: explain behavior changed above.
Files/hunks: docs/auth.md expiry section.
Why separate: documentation-only review.
Validation: git diff --check.
```

For one-file multi-change plans, mention approximate anchors instead of exact line numbers when line numbers may shift:

```text
Commit 1: fix(ui): align toolbar actions
Files/hunks: app/page.tsx toolbar container classes.

Commit 2: fix(ui): improve empty state copy
Files/hunks: app/page.tsx empty-state text block.
```

## Quality Gate

Before handing off to `$safe-staging` or `$making-green`, verify:

- every changed hunk appears in exactly one planned commit
- no planned commit is empty
- no planned commit exists only to inflate contribution count
- combined commits explain why they cannot split cleanly
- pre-existing user changes are either planned first or explicitly left untouched

If the plan is uncertain, state the uncertainty and choose the smallest honest commit grouping.
