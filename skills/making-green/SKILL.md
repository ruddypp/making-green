---
name: making-green
description: |
  Orchestrate a high-frequency, reviewable git contribution workflow after code changes: plan small meaningful commits, stage safely, write clear English Conventional Commit messages, tag each commit as a checkpoint, and push the active branch once at the end. Use after an AI agent finishes editing code, when the user wants granular GitHub contribution activity, when every logical change should be tracked separately, or when rollback protection matters.
---

# Making Green

Use this skill after code edits are complete. Convert the final worktree into a sequence of tiny, meaningful commits on the active branch, tag every commit as a local checkpoint, then push the branch once after all commits are created.

The goal is a dense, clear audit trail: every logical change should be easy to review, revert, and explain. High commit count must not reduce code quality or log readability.

This is the orchestrator skill for the Making Green package. Use these supporting skills when available:

- `$commit-planner` to produce the commit plan.
- `$safe-staging` to stage one logical change safely.
- `$commit-message-style` to write English Conventional Commit messages.
- `$contribution-hygiene` to prevent fake, spammy, or misleading activity.
- `$git-rollback` when a checkpoint or commit must be reverted.

Read `references/strict-checklist.md` before final reporting.

## Keeping This Skill Updated

If the user says this package changed, asks why behavior differs from the latest README, or wants the newest Making Green behavior, tell them to update installed skills:

```bash
npx skills update -g
npx skills update -p
```

For a full global reinstall from GitHub:

```bash
npx skills add ruddypp/making-green --skill '*' --agent '*' --global --copy -y
```

## Rules

- Commit on the active branch. Do not create or switch branches unless the user explicitly asks.
- Commit pre-existing dirty work before new agent work when possible, so user changes do not mix with agent changes.
- Default to high granularity. Create one commit per smallest meaningful logical change.
- If one file contains four independent sections or edits, make four commits.
- If a new feature naturally contains twenty meaningful review units, make twenty commits.
- Use patch staging (`git add -p`, `git restore --staged -p`, or equivalent). Do not use `git add .`.
- Push only after all commits and local checkpoint tags are done.
- Tag every commit with a local checkpoint tag.
- Do not push checkpoint tags unless the user explicitly asks for remote checkpoints.
- Keep commits meaningful. Do not split one logical change into fake micro-commits only to increase commit count.
- Keep code quality and commit log quality together. More commits are useful only when the code and history stay clearer.
- Never commit protected content. Read `references/protected-content.md` before staging.
- Write commit messages in English.
- Use the existing remote configuration. HTTPS and SSH remotes are both valid.
- Do not change remote URLs unless the user explicitly asks.

## Workflow

### 1. Inspect Repository State

Run:

```bash
git status --short --branch
git branch --show-current
git remote -v
```

If the worktree is dirty before the agent's own edits, commit those existing changes first as separate checkpoint commits. Use clear messages such as `chore(checkpoint): preserve existing workspace changes`. Do not merge them with later agent changes.

If no Git repository exists, stop and report that the skill requires a Git repository.

If no remote exists, continue with local commits and tags, then report that push could not run because no remote is configured.

### 2. Identify Commit Units

Use `$commit-planner` when available. Review all changes:

```bash
git diff
git diff --stat
```

If this package's `examples/` directory is available, use it as guidance for expected granularity:

- `examples/one-file-many-commits.md`
- `examples/skill-package-plan.md`
- `examples/no-remote.md`
- `examples/failed-validation.md`

Group changes by intent and section, not by file. Good commit units use Conventional Commit style:

- `fix(ui): align toolbar actions`
- `feat(auth): add session expiry warning`
- `test(auth): cover expired session rejection`
- `docs(git): document checkpoint rollback flow`
- `refactor(api): split request validation helper`
- `style(page): format dashboard layout classes`
- `chore(config): update formatter settings`

For high-frequency workflows, a medium feature should often produce many commits. Split by:

- public documentation sections
- skill frontmatter versus skill body
- each workflow phase
- each safety rule group
- each example group
- each metadata file
- each implementation behavior
- each test behavior

When multiple logical changes are in one hunk, split with patch staging if safe. If Git cannot split the hunk cleanly, prefer the smallest truthful combined commit over risky manual churn.

Write a commit plan before staging. Use this shape:

```text
Commit 1: fix(ui): align toolbar actions
Intent: one UI layout fix.
Files/hunks: app/page.tsx toolbar container classes.
Why separate: can revert without touching empty state copy.
Validation: git diff --check; formatter if obvious.
```

For a new skill file, a better high-granularity plan is:

```text
Commit 1: feat(skill-name): add invocation metadata
Commit 2: feat(skill-name): define workflow goals
Commit 3: feat(skill-name): add safety rules
Commit 4: feat(skill-name): add execution workflow
Commit 5: feat(skill-name): add final report requirements
Commit 6: feat(skill-name): add agent metadata
```

Before continuing, verify every changed hunk is assigned to exactly one planned commit or intentionally left uncommitted.

### 3. Run Fast Validation

Use `$contribution-hygiene` while deciding whether the planned commits are meaningful. Then run whitespace/conflict checks:

```bash
git diff --check
```

If this package's scripts are available, run the risk inspector before final push:

```bash
scripts/inspect-risk.sh
```

Run the project's formatter if it is obvious and quick. Prefer existing commands from package scripts, task runners, or repo docs, for example:

```bash
npm run format
pnpm format
yarn format
bun run format
cargo fmt
gofmt -w <changed-go-files>
ruff format <changed-python-files>
black <changed-python-files>
prettier --write <changed-files>
```

Do not spend the task budget hunting for full test suites. This skill optimizes commit hygiene and traceability, not full verification.

If validation fails and cannot be fixed quickly, still commit the change. Put the failure in the commit body and final report.

### 4. Stage One Logical Change

Use `$safe-staging` when available. Stage only one logical change:

```bash
git add -p <files>
git diff --cached
git diff --cached --stat
git diff --cached --check
```

Before committing, verify:

- staged diff contains one logical change
- staged diff contains no protected content
- unstaged changes remain available for later commits when needed
- commit can be reverted without removing unrelated work
- repository state remains coherent after this commit
- commit message will make sense when read months later

### 5. Commit With Clear Message

Use `$commit-message-style` when available. Use Conventional Commits:

```text
type(scope): concise change summary
```

Common types:

- `feat`: user-visible capability
- `fix`: bug fix
- `refactor`: behavior-preserving code structure change
- `style`: formatting or visual-only code style
- `test`: test change
- `docs`: documentation
- `chore`: tooling, config, generated metadata, or checkpoints

Use a commit body when line/file context helps review:

```text
fix(ui): align dashboard header spacing

Updates page.tsx header layout so title and action controls align at mobile width.
Checkpoint: small UI-only change.
Validation: git diff --cached --check passed; formatter ran.
```

If validation failed:

```text
Validation: git diff --cached --check failed: <short reason>
```

### 6. Tag Commit Checkpoint

After each commit, tag the new commit:

```bash
git tag checkpoint/$(date +%Y%m%d-%H%M%S)-<short-slug>
```

Use short slugs from the commit intent, such as:

- `fix-ui-spacing`
- `docs-skill-workflow`
- `refactor-auth-parser`

If the tag already exists, append `-2`, `-3`, or the short commit hash.

Checkpoint tags are local by default. Before pushing tags in a public repo, inspect tag volume:

```bash
git tag --list "checkpoint/*" | wc -l
```

If checkpoint tag volume is extreme, report the count. Do not push checkpoint tags unless the user explicitly asks for remote checkpoints.

### 7. Repeat Until Clean

Repeat staging, committing, and tagging until:

```bash
git status --short
```

shows no uncommitted changes that should be committed.

If files remain intentionally uncommitted, report them clearly.

### 8. Push Once At End

After all commits and local checkpoint tags are created, push only the active branch. Use the repository's existing `origin` remote, whether it is HTTPS or SSH:

```bash
git remote get-url origin
```

Examples of valid remotes:

```text
https://github.com/owner/repo.git
git@github.com:owner/repo.git
ssh://git@github.com/owner/repo.git
```

Push:

```bash
CURRENT_BRANCH=$(git branch --show-current)
git push origin "$CURRENT_BRANCH"
```

If no upstream exists, push to `origin` with upstream:

```bash
git push -u origin "$CURRENT_BRANCH"
```

Do not push after every commit. Do not push checkpoint tags by default.

If the user explicitly asks for remote checkpoint tags, then run:

```bash
git push origin --tags
```

If push fails because authentication is missing, report the exact failure and leave local commits and tags intact. Do not change the remote from HTTPS to SSH or SSH to HTTPS unless the user asks.

## Final Report

Before final report, read and satisfy `references/strict-checklist.md`.

Report:

- active branch pushed
- number of commits created
- local checkpoint tags created
- whether checkpoint tags were pushed; default is no
- remote URL type used: HTTPS, SSH, or other
- validation commands run and failures, if any
- files left uncommitted, if any
- rollback hint: use `$git-rollback` with the relevant checkpoint tag or commit hash
