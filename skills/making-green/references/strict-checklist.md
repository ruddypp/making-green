# Strict Checklist

Use this checklist before final report.

## Commit Planning

- Every commit maps to one meaningful logical change.
- High granularity was used where it improves reviewability.
- No commit exists only to increase contribution count.
- Combined commits explain why smaller splits would be misleading or unsafe.
- Pre-existing user changes were committed separately or explicitly left untouched.

## Staging Safety

- `git add .` was not used.
- `git diff --cached` was inspected before each commit.
- `git diff --cached --check` ran before each commit.
- Protected files were not staged.
- Build output, dependency folders, logs, temp files, and local env files were not staged unless the repo intentionally tracks them.

## Message Quality

- Commit messages are English.
- Commit messages use Conventional Commit style.
- Adjacent commit summaries are distinguishable at a glance.
- Commit bodies record validation failures when present.
- Each commit remains understandable months later.

## Checkpoint Tags

- Each commit has a local `checkpoint/*` tag.
- Checkpoint tags were not pushed unless the user explicitly requested remote checkpoints.
- If remote checkpoints were requested, tag volume was reported first.

## Push

- Only the active branch was pushed.
- The existing `origin` URL was used.
- HTTPS and SSH remotes were accepted as-is.
- Remote URL was not changed unless the user explicitly asked.

## Final State

- `git status --short --branch` was checked.
- Remaining uncommitted files, if any, were reported.
- Validation commands and failures were reported.
- Final report includes commit count and local checkpoint tag count.
