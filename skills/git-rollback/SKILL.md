---
name: git-rollback
description: Roll back git changes safely using small commits, checkpoint tags, revert commits, or file restoration. Use when a user asks to undo agent work, revert a bad commit, return to a making-green checkpoint, inspect rollback options, or recover from a misled AI-agent change.
---

# Git Rollback

Undo work with an auditable path. Prefer revert commits over history rewriting.

Use this skill directly when the user asks for rollback, or as a recovery reference for `$making-green`.

For no-remote and checkpoint examples in the Making Green package, see `examples/no-remote.md`.

## Safety Rules

- Inspect before undoing.
- Prefer `git revert` for pushed commits.
- Do not run destructive commands such as `git reset --hard`, `git clean -fd`, or force push unless the user explicitly asks after seeing the impact.
- If rollback touches many commits, explain the plan before running it.
- If secrets were committed, stop before pushing and tell the user. Secret cleanup may require history rewriting and credential rotation.

## Inspect Current State

Run:

```bash
git status --short --branch
git log --oneline --decorate -n 20
git tag --list "checkpoint/*" --sort=-creatordate | head -20
```

For one commit:

```bash
git show --stat <commit>
git show <commit>
```

For checkpoint tags:

```bash
git show --stat <tag>
```

## Roll Back One Commit

If the user explicitly asks to undo one commit and it is safe:

```bash
git revert <commit>
```

Then report the new revert commit.

## Roll Back A Range

For multiple commits, show plan first:

```bash
git log --oneline <oldest>^..<newest>
```

Then revert without committing, inspect, and commit once if the user wants one rollback commit:

```bash
git revert --no-commit <oldest>^..<newest>
git diff --cached --stat
git diff --cached
git commit -m "revert(scope): roll back <summary>"
```

Or revert one-by-one when separate rollback commits are easier to review:

```bash
git revert <newest>
git revert <next>
```

## Restore One File From A Commit

For local file recovery:

```bash
git restore --source=<commit> -- <path>
git diff -- <path>
```

Then commit the restore as a normal small commit.

## Return To A Checkpoint

Find checkpoint:

```bash
git tag --list "checkpoint/*" --sort=-creatordate
git show --stat <checkpoint-tag>
```

If checkpoint is behind current branch and commits are already pushed, prefer reverting the commits after the checkpoint:

```bash
git log --oneline <checkpoint-tag>..HEAD
git revert --no-commit <checkpoint-tag>..HEAD
```

Inspect before commit:

```bash
git diff --cached --stat
git diff --cached
```

## Final Report

Report:

- rollback target
- commands run
- commits reverted or files restored
- new commit hash, if created
- remaining risks or conflicts
