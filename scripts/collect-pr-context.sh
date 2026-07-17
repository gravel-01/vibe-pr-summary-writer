#!/usr/bin/env bash

set -euo pipefail

target=${1:-}

if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null || true)" != "true" ]]; then
  echo "Error: current directory is not inside a Git worktree." >&2
  exit 2
fi

current_branch=$(git branch --show-current)
upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || true)

section() {
  printf '\n## %s\n' "$1"
}

if [[ -z "$target" ]]; then
  section "Target Discovery"
  printf 'current_branch=%s\n' "${current_branch:-DETACHED_HEAD}"
  printf 'upstream=%s\n' "${upstream:-NONE}"

  echo "remote_default_candidates:"
  remote_defaults=$(
    git for-each-ref \
      --format='%(refname:short) %(symref:short)' \
      refs/remotes/ \
      | awk '$1 ~ /\/HEAD$/ && $2 != "" { print "  " $2 }'
  )
  if [[ -n "$remote_defaults" ]]; then
    printf '%s\n' "$remote_defaults"
  else
    echo "  NONE"
  fi

  echo "remote_branch_candidates:"
  remote_branches=$(
    git for-each-ref --format='  %(refname:short)' refs/remotes/ \
      | awk '$0 !~ /\/HEAD$/'
  )
  if [[ -n "$remote_branches" ]]; then
    printf '%s\n' "$remote_branches"
  else
    echo "  NONE"
  fi

  printf '\ntarget_status=UNRESOLVED\n'
  echo "Confirm the intended PR target, then pass it explicitly."
  echo "Example: $0 origin/dev"
  exit 0
fi

if ! git rev-parse --verify "${target}^{commit}" >/dev/null 2>&1; then
  echo "Error: target branch or commit does not exist: ${target}" >&2
  exit 2
fi

merge_base=$(git merge-base "$target" HEAD)
head_commit=$(git rev-parse HEAD)

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
