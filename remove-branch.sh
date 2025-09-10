#!/bin/bash
gh pr list --state open --repo benhuangbmj/flushingtech.org --json number --jq '.[].number' | xargs -n 1 gh pr close --repo benhuangbmj/flushingtech.org
git branch -r | grep -v "origin/main" | grep "origin/" | sed 's/origin\///' | xargs -n 1 git push origin --delete
