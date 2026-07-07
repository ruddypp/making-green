# Protected Content

Check this list before staging each commit.

Do not commit:

- `.env`, `.env.*`, or local environment files
- API keys, tokens, passwords, private keys, certificates, cookies, or session dumps
- cloud credentials such as AWS, GCP, Azure, Vercel, Supabase, Firebase, GitHub, npm, PyPI, Docker, SSH, or database credentials
- `node_modules/`, `vendor/`, virtualenvs, package caches, or dependency folders
- build output such as `dist/`, `build/`, `.next/`, `out/`, `coverage/`, `target/`, or generated binaries unless the repo intentionally tracks them
- logs, crash dumps, temp files, editor swap files, OS metadata, or screenshots not requested by the user
- large binary files unless the repo already tracks that file type and the user expects it
- unrelated user changes mixed into the current logical commit

Before committing, inspect staged files:

```bash
git diff --cached --name-only
git diff --cached
```

If protected content is staged, unstage it:

```bash
git restore --staged <path>
```

If protected content was committed, stop before pushing and tell the user.
