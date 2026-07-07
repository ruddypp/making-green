---
name: commit-message-style
description: Write clear English Conventional Commit messages for small git commits. Use before git commit, with making-green or safe-staging, when commit history must be reviewable, when validation results need to be recorded, or when many commits need consistent messages.
---

# Commit Message Style

Write every commit message in English. Optimize for review, rollback, and search. High commit volume only works when the log stays easy to scan.

Use after `$safe-staging`, before `git commit`, or inside `$making-green`.

## Format

Use Conventional Commits:

```text
type(scope): concise imperative summary

Body explains what changed, why this commit stands alone, and validation status.
```

Allowed types:

- `feat`: user-visible capability
- `fix`: bug fix
- `refactor`: behavior-preserving structure change
- `style`: formatting or visual-only code style
- `test`: test coverage or test fixture change
- `docs`: documentation
- `chore`: tooling, config, metadata, checkpoint, or maintenance
- `perf`: performance improvement
- `build`: build system or dependency packaging
- `ci`: CI workflow change

Use a short scope from the touched area, such as `auth`, `ui`, `api`, `docs`, `config`, `deps`, or `checkpoint`.

## Summary Rules

- Use English only.
- Use imperative mood: `add`, `fix`, `remove`, `split`, `document`.
- Keep summary under 72 characters when practical.
- State the specific outcome, not the action mechanics.
- Avoid vague summaries: `update`, `changes`, `fix stuff`, `misc`, `wip`.
- Do not mention AI or the agent unless the repo convention requires it.
- Make adjacent commits distinguishable at a glance.
- If two messages would look almost identical, the commits are probably too small or the summaries need sharper scopes.

## Body Rules

Add a body when it helps review:

```text
fix(ui): align toolbar actions

Adjusts the page toolbar container so primary and secondary actions keep a stable
baseline across desktop and mobile widths.
Why separate: UI-only layout fix; safe to revert without touching data flow.
Validation: git diff --cached --check passed; formatter ran.
```

If validation failed but the user expects commits anyway:

```text
Validation: git diff --cached --check failed: trailing whitespace remains in generated fixture.
```

If a commit combines hunks because splitting was unsafe:

```text
Why combined: the schema rename and call-site update must land together.
```

## Message Selection

Choose type by user-visible effect:

- Bug behavior changes -> `fix`
- New behavior -> `feat`
- Internal cleanup with same behavior -> `refactor`
- Formatting-only -> `style`
- Docs-only -> `docs`
- Tests-only -> `test`
- Repo maintenance -> `chore`

When unsure between `fix` and `refactor`, choose `fix` only if behavior changes.

## Commit Command

Prefer multi-line messages:

```bash
git commit -m "fix(ui): align toolbar actions" \
  -m "Adjusts the page toolbar container so actions keep a stable baseline." \
  -m "Why separate: UI-only layout fix." \
  -m "Validation: git diff --cached --check passed; formatter ran."
```

Before committing, ensure `git diff --cached` matches the message exactly.
