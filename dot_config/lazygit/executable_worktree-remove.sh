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

is_clean() {
  [ -z "$(git -C "$1" status --porcelain)" ]
}

has_compose_file() {
  for file in compose.yml compose.yaml docker-compose.yml docker-compose.yaml; do
    [ ! -f "$1/$file" ] || return 0
  done
  return 1
}

clean_project() {
  if [ -x "$1/.worktree-teardown" ]; then
    echo "Running project worktree teardown hook..."
    (cd "$1" && ./.worktree-teardown)
  elif [ -f "$1/Makefile" ] && grep -Eq '^[[:space:]]*clean[[:space:]]*:' "$1/Makefile"; then
    echo "Running project clean target..."
    make -C "$1" clean
  elif has_compose_file "$1"; then
    echo "Stopping Docker Compose project..."
    (cd "$1" && docker compose down --volumes --remove-orphans)
  fi
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

if ! is_clean "$target"; then
  echo "Refusing to remove a worktree with uncommitted changes: $target" >&2
  exit 1
fi

branch="$(git -C "$target" symbolic-ref --quiet --short HEAD || true)"
clean_project "$target"

if ! is_clean "$target"; then
  echo "Project cleanup changed tracked files; refusing to remove: $target" >&2
  exit 1
fi

git -C "$main" worktree remove -- "$target"
git -C "$main" worktree prune
rmdir "$expected_root" 2>/dev/null || true

echo "Removed worktree: $target"
if [ -z "$branch" ]; then
  echo "The worktree had a detached HEAD; no branch was deleted."
else
  git -C "$main" branch -D -- "$branch"
fi
