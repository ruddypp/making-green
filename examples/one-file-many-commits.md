# One File, Many Commits

Scenario: one file contains several unrelated changes. Making Green should not commit the whole file at once.

Input summary:

```text
app/page.tsx
- changes toolbar layout classes
- changes empty-state copy
- adds loading skeleton
- changes submit button disabled logic
- updates inline validation message
```

Expected commit plan:

```text
Commit 1: fix(ui): align toolbar actions
Intent: one layout fix in the page toolbar.
Files/hunks: app/page.tsx toolbar container classes.
Why separate: can revert without changing copy or behavior.

Commit 2: docs(ui): clarify empty state copy
Intent: text-only user-facing copy update.
Files/hunks: app/page.tsx empty-state copy block.
Why separate: copy review does not need behavior review.

Commit 3: feat(ui): add loading skeleton
Intent: add visible pending state.
Files/hunks: app/page.tsx loading branch and skeleton markup.
Why separate: one user-visible UI feature.

Commit 4: fix(form): disable submit while invalid
Intent: prevent invalid form submission.
Files/hunks: app/page.tsx submit button disabled condition.
Why separate: behavior fix independent from UI copy.

Commit 5: fix(form): improve validation message
Intent: explain validation failure more clearly.
Files/hunks: app/page.tsx validation message block.
Why separate: message can be reverted without changing submit behavior.
```

Bad plan:

```text
Commit 1: update page
```

Reason: broad, hard to review, hard to revert.
