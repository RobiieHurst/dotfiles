#!/bin/sh
set -eu

path="${1:-}"
if [ -z "$path" ]; then
  echo "Usage: worktree-remove.sh <worktree-path>" >&2
  exit 2
fi

physical_path() {
  (cd "$1" && pwd -P)
}

target="$(physical_path "$path")"
current="$(physical_path "$(git rev-parse --show-toplevel)")"
common_dir="$(git -C "$target" rev-parse --path-format=absolute --git-common-dir)"
main="$(physical_path "$(dirname "$common_dir")")"
expected_root="$(dirname "$main")/worktrees/$(basename "$main")"

if [ "$target" = "$main" ]; then
  echo "Refusing to remove the main worktree: $target" >&2
  exit 1
fi

if [ "$target" = "$current" ]; then
  echo "Refusing to remove the worktree running this Lazygit session: $target" >&2
  exit 1
fi

case "$target" in
  "$expected_root"/*) ;;
  *)
    echo "Refusing to remove a worktree outside $expected_root: $target" >&2
    exit 1
    ;;
esac

if [ -n "$(git -C "$target" status --porcelain)" ]; then
  echo "Refusing to remove a worktree with uncommitted changes: $target" >&2
  exit 1
fi

branch="$(git -C "$target" symbolic-ref --quiet --short HEAD || true)"
git -C "$main" worktree remove -- "$target"
git -C "$main" worktree prune
rmdir "$expected_root" 2>/dev/null || true

echo "Removed worktree: $target"
if [ -z "$branch" ]; then
  echo "The worktree had a detached HEAD; no branch was deleted."
elif git -C "$main" branch -d -- "$branch"; then
  echo "Deleted merged local branch: $branch"
else
  echo "Kept unmerged local branch: $branch"
fi
