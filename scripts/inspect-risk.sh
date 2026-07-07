#!/usr/bin/env bash
set -euo pipefail

echo "== git status =="
git status --short --branch

echo
echo "== remote =="
if git remote get-url origin >/dev/null 2>&1; then
  remote_url="$(git remote get-url origin)"
  echo "$remote_url"
  case "$remote_url" in
    https://*) echo "remote type: HTTPS" ;;
    git@*|ssh://*) echo "remote type: SSH" ;;
    *) echo "remote type: other" ;;
  esac
else
  echo "origin remote: missing"
fi

echo
echo "== checkpoint tags =="
tag_count="$(git tag --list 'checkpoint/*' | wc -l | tr -d ' ')"
echo "local checkpoint tags: $tag_count"

echo
echo "== staged files =="
git diff --cached --name-only || true

echo
echo "== risky staged paths =="
risky_regex='(^|/)(\.env($|\.)|node_modules/|vendor/|dist/|build/|\.next/|out/|coverage/|target/|.*\.pem$|.*\.key$|.*\.p12$|.*\.log$)'
if git diff --cached --name-only | grep -E "$risky_regex"; then
  echo "risk: staged protected-looking paths found"
else
  echo "no protected-looking staged paths found"
fi

echo
echo "== secret-looking staged content =="
secret_regex='(api[_-]?key|secret|token|password|private[_-]?key|BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY)'
if git diff --cached | grep -E -i "$secret_regex" >/tmp/making-green-secret-scan.txt; then
  cat /tmp/making-green-secret-scan.txt
  rm -f /tmp/making-green-secret-scan.txt
  echo "risk: staged secret-looking content found"
else
  rm -f /tmp/making-green-secret-scan.txt
  echo "no secret-looking staged content found"
fi

echo
echo "== diff check =="
git diff --check
git diff --cached --check

echo
echo "risk inspection complete"
