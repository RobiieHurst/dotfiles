#!/bin/sh
# Make a worktree the Zed way: ../worktrees/<repo>/<name>
# Usage: worktree-add.sh [name] [base-ref]
set -eu

name="${1:-}"
base="${2:-HEAD}"

# Main repo root (works from inside another worktree too)
main="$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"
repo="$(basename "$main")"
root="$(dirname "$main")/worktrees/$repo"

# Random adjective-noun name if none given
if [ -z "$name" ]; then
  adj="calm quiet bold brisk misty sunny mossy amber cedar coral dusky fresh gentle golden hazel keen lunar maple noble olive pale polar quick rosy sage silver sleek snowy solar steady tidy vivid warm wild"
  noun="river maple otter falcon meadow harbor comet grove ridge brook cliff finch heron lagoon marsh pebble reef summit thrush valley willow acorn beacon canyon dune fjord glade juniper lark orchid raven sparrow"
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    a="$(echo $adj | tr ' ' '\n' | shuf -n1)"
    n="$(echo $noun | tr ' ' '\n' | shuf -n1)"
    name="$a-$n"
    [ -e "$root/$name" ] || git show-ref --verify --quiet "refs/heads/$name" || break
  done
fi

dest="$root/$name"
[ -e "$dest" ] && { echo "Already exists: $dest" >&2; exit 1; }
mkdir -p "$root"

if git show-ref --verify --quiet "refs/heads/$name"; then
  echo "Branch '$name' exists. Checking it out."
  git worktree add -- "$dest" "$name"
else
  echo "New branch '$name' from '$base'."
  git worktree add -b "$name" -- "$dest" "$base"
fi
echo "Worktree ready: $dest"
