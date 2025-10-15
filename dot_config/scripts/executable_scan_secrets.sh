#!/bin/bash

# Fetch all remote branches
git fetch --all

# Get a list of all branches (local + remote)
branches=$(git branch -a | sed 's/^[* ] //' | grep -v HEAD)

for branch in $branches; do
  echo "Scanning branch: $branch"
  # Checkout the branch
  git checkout --quiet $branch
  # Run gitleaks on the current branch
  gitleaks detect --no-git --source . --report-path "gitleaks_report_${branch//\//_}.json"
done

echo "Scan complete. Check the gitleaks_report_*.json files for results."
