---
name: contribution-hygiene
description: Keep high-frequency git contribution workflows ethical, useful, and reviewable. Use with making-green, before publishing many commits or tags, when optimizing GitHub contribution activity, or when preventing spammy, misleading, or low-quality commit history.
---

# Contribution Hygiene

High commit count is acceptable only when each commit carries useful review value. Commit volume and code quality must move together.

Use this skill as the quality layer for `$making-green`.

## Principles

- Keep code quality and commit readability as equal goals.
- Maximize meaningful commits, not empty activity.
- Prefer high granularity by default: section-level commits are good when sections have different review purposes.
- Prefer small revertable patches over artificial commit inflation.
- Do not create commits that only exist to turn GitHub green.
- Do not hide failures; record validation failures in commit bodies.
- Do not mix unrelated user work with agent work.
- Do not rewrite public history unless the user explicitly requests it and understands the impact.

## Quality Invariant

Never make the code worse to produce more commits.

Each commit should leave the repository in a coherent state:

- code remains readable
- public behavior is not accidentally broken
- formatting is consistent with the project
- generated or noisy changes are isolated
- commit message explains the exact intent
- rollback target is obvious from the log

If a smaller split would make code temporarily confusing, misleading, or broken, use a larger honest commit instead.

## Good High-Frequency Commits

Good:

- `fix(ui): align toolbar actions`
- `feat(auth): add session expiry warning`
- `test(auth): cover expired session rejection`
- `docs(git): document checkpoint rollback flow`
- `refactor(api): split request validation helper`
- `style(page): format dashboard layout classes`
- `chore(config): update formatter settings`

Bad:

- whitespace-only churn split across many commits
- repeated edits that cancel each other out
- empty commits
- splitting one sentence into many commits without review value
- combining multiple independently reviewable sections into one broad commit
- generated artifacts committed only for activity
- huge tag spam without a rollback purpose

## Checkpoint Tag Hygiene

`$making-green` creates local checkpoint tags per commit by default. This improves rollback without cluttering GitHub tags.

Use stable tag names:

```text
checkpoint/YYYYMMDD-HHMMSS-short-slug
```

If the user explicitly asks to push checkpoint tags, inspect volume first:

```bash
git tag --list "checkpoint/*" --sort=-creatordate | head -50
git tag --list "checkpoint/*" | wc -l
```

If tag volume is extreme for a public repository, report it before pushing. Do not push checkpoint tags unless the user explicitly asks for remote checkpoints.

Do not create releases from checkpoint tags.

## Public Repo Expectations

Before final push:

```bash
git log --oneline --decorate -n 30
git status --short --branch
git remote -v
```

Check that:

- commit messages are English and specific
- no commit is empty
- no protected content is staged or committed
- branch target is the active branch
- remote URL can be HTTPS or SSH; use whatever `origin` already uses
- final report names the branch, commit count, and tag count

## If Asked To Make More Commits

Create more commits by finding real logical boundaries at section, hunk, behavior, example, metadata, and validation levels. If no honest boundary remains, say so and stop.

Never use:

```bash
git commit --allow-empty
```

unless the user explicitly requests an empty marker commit and the message says it is a marker.
