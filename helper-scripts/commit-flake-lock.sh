#!/usr/bin/env bash
flakeLock=$(git status | grep -oF "flake.lock")
#echo "file exists: <$flakeLock>"

if [ -z "$flakeLock" ]; then
  echo "No flake.lock to commit"
  exit 1
fi
echo "flakeLock: <${flakeLock}>"
git add $flakeLock 
git commit $flakeLock -m 'chore: commit flake.lock'
