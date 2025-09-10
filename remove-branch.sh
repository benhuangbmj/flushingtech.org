#!/bin/bash

# Get open PR numbers into a variable
pr_numbers=$(gh pr list --state open --repo benhuangbmj/flushingtech.org --json number --jq '.[].number')

# Check if the variable is non-empty
if [ -n "$pr_numbers" ]; then
  echo "Closing the following PRs:"
  echo "$pr_numbers"
  # Close PRs one by one
  echo "$pr_numbers" | xargs -n 1 gh pr close --repo benhuangbmj/flushingtech.org
else
  echo "No open PRs to close."
fi

git branch -r | grep -v "origin/main" | grep "origin/" | sed 's/origin\///' | xargs -n 1 git push origin --delete

# Make sure we are in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Not a git repository!"
  exit 1
fi

# Switch to main branch first (to avoid deleting the one you are on)
git checkout main || {
  echo "Failed to switch to 'main'. Make sure it exists."
  exit 1
}

# Delete all branches except 'main'
git branch | grep -v "main" | xargs git branch -D