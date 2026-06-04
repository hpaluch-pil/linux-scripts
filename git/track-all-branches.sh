#!/bin/bash
# Track all remote branches
# Based on: https://stackoverflow.com/a/6300386

set -euo pipefail

for i in $(git for-each-ref --format='%(refname:short)' \
          --no-merged=origin/HEAD refs/remotes/origin)
do
        just_branch="${i##*/}"
        if [ -r .git/refs/heads/$just_branch ]; then
                echo "Branch '$i' already tracked, skipping..."
                continue
        fi
        echo "Tracking '$i'..."
        git switch --track $i
done
exit 0
