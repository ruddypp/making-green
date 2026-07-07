#!/usr/bin/env bash
set -euo pipefail

remote=0
yes=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --remote)
      remote=1
      ;;
    -y|--yes)
      yes=1
      ;;
    -h|--help)
      cat <<'USAGE'
Usage: scripts/cleanup-checkpoints.sh [--remote] [--yes]

Delete local checkpoint/* tags. With --remote, also delete matching remote tags from origin.
Remote deletion is irreversible for other users who rely on those tags.
USAGE
      exit 0
      ;;
    *)
      echo "unknown option: $1" >&2
      exit 2
      ;;
  esac
  shift
done

mapfile -t tags < <(git tag --list 'checkpoint/*' | sort)

if [[ ${#tags[@]} -eq 0 ]]; then
  echo "no checkpoint tags found"
  exit 0
fi

printf 'checkpoint tags found: %s\n' "${#tags[@]}"
printf '%s\n' "${tags[@]}"

if [[ "$yes" -ne 1 ]]; then
  read -r -p "delete these local checkpoint tags? [y/N] " answer
  case "$answer" in
    y|Y|yes|YES) ;;
    *) echo "aborted"; exit 0 ;;
  esac
fi

git tag -d "${tags[@]}"

if [[ "$remote" -eq 1 ]]; then
  if ! git remote get-url origin >/dev/null 2>&1; then
    echo "origin remote not found; skipped remote tag cleanup"
    exit 0
  fi

  if [[ "$yes" -ne 1 ]]; then
    read -r -p "delete matching checkpoint tags from origin? [y/N] " answer
    case "$answer" in
      y|Y|yes|YES) ;;
      *) echo "remote cleanup skipped"; exit 0 ;;
    esac
  fi

  for tag in "${tags[@]}"; do
    git push origin ":refs/tags/$tag"
  done
fi

echo "checkpoint cleanup complete"
