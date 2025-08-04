#!/usr/bin/env bash
FILEEXISTS=$(git status | grep flake.lock)
echo "f e : $FILEEXISTS"

#git commit flake.lock -m 'chore: commit flake.lock'

