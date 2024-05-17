#!/bin/bash
set -euo pipefail
for mnt in `findmnt -t btrfs -o target -n`
do
        set -x
	btrfs scrub start -Br $mnt
        set +x
done
exit 0
