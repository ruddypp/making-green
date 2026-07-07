# Making Green

Making Green is a public agent-skills package for turning completed code changes into many small, meaningful, reviewable commits, checkpointing each commit, and pushing the active branch once at the end.

It is designed for developers who want dense GitHub contribution activity without empty commits, misleading history, or mixed rollback points.

## Skills

```text
skills/
  making-green/           # main orchestrator
  commit-planner/         # turns a dirty diff into a commit plan
  safe-staging/           # stages one logical change safely
  commit-message-style/   # writes English Conventional Commit messages
  git-rollback/           # reverts commits/checkpoints safely
  contribution-hygiene/   # prevents spammy or misleading activity
```

Use `$making-green` for the full workflow. It references the other five skills as supporting capabilities.

## Install

Install all skills for every supported agent in the current project:

```bash
npx skills add ruddypp/making-green --all
```

Install all skills globally for every supported agent:

```bash
npx skills add ruddypp/making-green --skill '*' --agent '*' --global --copy -y
```

Install the main skill only:

```bash
npx skills add ruddypp/making-green --skill making-green
```

Install all skills for Codex only:

```bash
npx skills add ruddypp/making-green --skill '*' --agent codex
```

Use without installing:

```bash
npx skills use ruddypp/making-green --skill making-green
```

The package uses plain `SKILL.md` files plus optional `agents/openai.yaml` metadata, so it stays portable across agents. The Skills CLI handles each agent's install path.

## What Making Green Does

- Plans one commit per logical change.
- Defaults to high granularity: section-level commits are expected when sections have different review purposes.
- Splits several changes in one file into several commits when safe.
- Turns medium-sized features into many meaningful commits, not one broad commit.
- Uses patch staging instead of `git add .`.
- Preserves pre-existing dirty work in separate checkpoint commits.
- Runs fast checks: formatter when obvious, plus `git diff --check`.
- Writes English Conventional Commit messages.
- Tags every commit with a checkpoint tag.
- Pushes the active branch and checkpoint tags once after all commits are done.
- Supports both HTTPS and SSH Git remotes by using the existing `origin` URL.
- Avoids protected content such as secrets, local env files, dependency folders, and build output.

## Remote Handling

Making Green does not force HTTPS or SSH. It uses the active repository's existing `origin` remote:

```bash
git remote get-url origin
```

Both are valid:

```text
https://github.com/owner/repo.git
git@github.com:owner/repo.git
```

If authentication is missing, the agent should leave local commits and tags intact, report the push failure, and avoid changing the remote URL unless the user asks.

## Philosophy

High-frequency commits are useful only when each commit carries review value. Code quality and commit log quality must move together.

Making Green should bias toward more commits than a typical human workflow. A new skill, feature, or module can reasonably produce many commits when each commit maps to a distinct section, behavior, example, safety rule, or metadata file.

More commits are not the goal by themselves. The goal is more readable rollback points: small code changes, clear English messages, coherent repository state, and logs that remain easy to scan.

Good:

- `fix(ui): align toolbar actions`
- `feat(auth): add session expiry warning`
- `test(auth): cover expired session rejection`
- `docs(git): document checkpoint rollback flow`
- `refactor(api): split request validation helper`
- `style(page): format dashboard layout classes`
- `chore(config): update formatter settings`

Bad:

- empty commits
- fake micro-commits
- whitespace churn for activity
- mixed unrelated changes
- hiding failed validation

## Skill Contents

Each skill contains a `SKILL.md` file. Some skills include `agents/openai.yaml` metadata or references.

```text
skills/making-green/
  SKILL.md
  agents/openai.yaml
  references/protected-content.md
```

## Notes

This package is instruction-only. It does not install Git hooks, background daemons, or automatic Git automation. The agent executes the workflow when the skill is invoked.
