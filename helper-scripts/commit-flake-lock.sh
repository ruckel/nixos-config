#!/usr/bin/env bash
flakeLock=$(git status | grep -F "flake.lock")
#echo "file exists: <$flakeLock>"

if [ -z "$flakeLock" ]; then
  echo "No flake.lock to commit"
  exit 1
fi
git add $flakeLock 
git commit $flakeLock -m 'chore: commit flake.lock'
