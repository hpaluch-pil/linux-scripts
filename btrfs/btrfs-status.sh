#!/bin/bash
set -euo pipefail

for mnt in `findmnt -t btrfs -o target -n`
do
        set -x
        btrfs su get-default $mnt
        btrfs su li -pau $mnt
        btrfs fi sh  $mnt
        btrfs fi df -h $mnt
        btrfs dev us $mnt
        btrfs dev st $mnt
        set +x
done
exit 0
