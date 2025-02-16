#!/bin/bash
set -euo pipefail
for mnt in `findmnt -t btrfs -o target -nl`
do
        set -x
        btrfs balance start -dusage=50 -musage=50 $mnt
        set +x
done
exit 0
