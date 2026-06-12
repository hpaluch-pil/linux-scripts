#!/bin/bash
# dump info on Metadata chunks (filled Metadata can cause ENOSPC even on disk with lot of free space in Data chunks!)
set -euo pipefail

# we will examine only 1st mount point of specific disk partition (partuuid) - subvolumes provide duplicate info
for mnt in `findmnt -t btrfs -o target,partuuid -nl  | awk '{ if (!id[$2]){ print $1; id[$2]=1; } }'`
do
	echo "Examining '$mnt'..."
        set -x
        btrfs fi df -h $mnt
	btrfs inspect list-chunks $mnt | sed -n '1,2p;/Metadata/p' 
        set +x
	echo
done
exit 0
