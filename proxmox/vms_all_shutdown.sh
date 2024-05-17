#!/bin/bash

# shutdowns all running VMs
# Written by Henryk Paluch

set -e
#set -o pipefail

for vmid in `qm list | awk '$3=="running"' | awk '{print $1}'`
do
        vmname=$( qm config $vmid| egrep '^name:' | awk '{print $2}')
        echo "Shutting down $vmid:'$vmname'..."
	set -x
	qm shutdown $vmid && qm wait $vmid
	set +x
done
exit 0
