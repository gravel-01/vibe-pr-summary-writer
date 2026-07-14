#!/usr/bin/env bash

set -euo pipefail

target=${1:-}

if [[ -z "$target" ]]; then
  echo "Usage: $0 <target-branch>" >&2
  echo "Example: $0 origin/dev" >&2
  exit 2
fi

if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null || true)" != "true" ]]; then
  echo "Error: current directory is not inside a Git worktree." >&2
  exit 2
fi

if ! git rev-parse --verify "${target}^{commit}" >/dev/null 2>&1; then
  echo "Error: target branch or commit does not exist: ${target}" >&2
  exit 2
fi

merge_base=$(git merge-base "$target" HEAD)
current_branch=$(git branch --show-current)
head_commit=$(git rev-parse HEAD)
upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || true)

section() {
  printf '\n## %s\n' "$1"
}

section "Repository"
printf 'current_branch=%s\n' "${current_branch:-DETACHED_HEAD}"
printf 'target=%s\n' "$target"
printf 'merge_base=%s\n' "$merge_base"
printf 'head=%s\n' "$head_commit"
printf 'upstream=%s\n' "${upstream:-NONE}"

section "Working Tree"
git status --short --branch

section "Commits In PR"
git log --oneline --decorate "${merge_base}..HEAD"

section "Changed Files"
git diff --name-status "${merge_base}..HEAD"

section "Diff Stat"
git diff --stat "${merge_base}..HEAD"

section "Diff Check"
if git diff --check "${merge_base}..HEAD"; then
  echo "PASS"
else
  echo "FAIL"
  exit 1
fi
