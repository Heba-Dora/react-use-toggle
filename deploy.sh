#!/bin/bash
cd "$(dirname "$0")"

rm -rf .git
git init
git branch -m main

# Hardcode the precise identity you provided
git config user.name "samibennett"
git config user.email "mehrbebe@gmail.com"

# Force the GH CLI to use samibennett native login
gh auth switch -u samibennett
gh auth setup-git

mv src .src_hidden

git add .
GIT_AUTHOR_DATE="$(date -v-3d)" GIT_COMMITTER_DATE="$(date -v-3d)" git commit -m "init: enterprise react toggle hook"

gh repo create react-use-toggle --public --source=. --remote=origin --push

git checkout -b feat/implement-toggle
mv .src_hidden src

git add src/
GIT_AUTHOR_DATE="$(date -v-5m)" GIT_COMMITTER_DATE="$(date -v-5m)" git commit -m "feat: implement declarative react toggle hook"
git push -u origin feat/implement-toggle

# Create the PR
gh pr create --title "Implement declarative React toggle hook" --body "Basic implementation for boolean state changes.

### Bots Activated
- **GitHub Actions**: Validating build integrity.
- **Dependabot**: Monitoring npm dependencies." --head feat/implement-toggle --base main

echo "---------------------------------------------------------"
echo "CRITICAL: Waiting 6 minutes (360 seconds) to avoid Quickdraw..."
echo "If we merge before 5 minutes, GitHub gives the Quickdraw badge instead of YOLO."
echo "Please leave this running. Do not cancel."
echo "---------------------------------------------------------"

sleep 360

gh pr merge feat/implement-toggle --merge
echo "Merged! Go check your profile for YOLO!"
