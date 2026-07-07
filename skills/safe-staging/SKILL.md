---
name: safe-staging
description: Stage one logical git change at a time without leaking secrets or mixing unrelated work. Use before every commit, with commit-planner or making-green, when patch staging is needed, when files contain multiple changes, or when protected content must be excluded from Git.
---

# Safe Staging

Stage exactly one planned commit unit. This skill protects reviewability and prevents accidental leaks.

Use after `$commit-planner` and before `$commit-message-style`, or as the staging phase inside `$making-green`.

## Hard Rules

- Do not run `git add .`.
- Do not stage protected content.
- Do not stage unrelated user changes with agent changes.
- Do not stage multiple logical changes just because they are in the same file.
- If clean split is impossible, stage the smallest truthful combined change and record why.

## Protected Content

Before staging, check:

- `.env`, `.env.*`, local config with secrets
- API keys, tokens, passwords, cookies, sessions, private keys, certificates
- cloud credentials for AWS, GCP, Azure, Vercel, Supabase, Firebase, GitHub, npm, PyPI, Docker, SSH, databases
- dependency folders such as `node_modules/`, `vendor/`, virtualenvs, package caches
- build output such as `dist/`, `build/`, `.next/`, `out/`, `coverage/`, `target/`
- logs, temp files, editor swap files, OS metadata, crash dumps
- large binaries unless the repo intentionally tracks them

Also read project `.gitignore` and existing tracked patterns:

```bash
git status --short
git ls-files <path>
```

If protected content is already committed but not pushed, stop and report it before pushing.

## Staging Workflow

Inspect the planned unit:

```bash
git diff -- <files>
```

Stage interactively:

```bash
git add -p <files>
```

If a generated or whole-file addition belongs entirely to one commit, stage that path explicitly:

```bash
git add <path>
```

Then verify staged content:

```bash
git diff --cached --stat
git diff --cached
git diff --cached --check
git status --short
```

If too much is staged:

```bash
git restore --staged <path>
git restore --staged -p <path>
```

## Non-Interactive Fallback

If interactive patch staging is unavailable, use one of these:

```bash
git add <specific-file>
git restore --staged -p <specific-file>
```

or create a temporary patch from the exact hunks and apply it to the index:

```bash
git diff > /tmp/making-green.patch
git apply --cached --include=<path> /tmp/making-green.patch
```

Use patch files only when they reduce risk. Delete temporary patches after use.

## Completion Criteria

Staging is complete only when:

- `git diff --cached` contains one planned logical change
- `git diff --cached --check` has been run
- protected content is absent
- unstaged work still contains only future planned commits or intentionally uncommitted files
- the staged change can be described in one Conventional Commit message
