# Failed Validation

Scenario: `git diff --check` or formatter fails, but the user explicitly wants commits anyway.

Expected behavior:

1. Keep the commit small.
2. Do not hide the failure.
3. Put the failure in the commit body.
4. Mention the failure again in the final report.

Example commit:

```text
fix(form): preserve invalid submit guard

Keeps the submit button disabled while required fields are invalid.
Why separate: behavior-only form guard.
Validation: git diff --cached --check failed: trailing whitespace remains in generated fixture.
```

Do not write:

```text
fix: update form
```

Reason: vague and hides validation risk.
