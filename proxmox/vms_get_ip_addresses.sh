#!/bin/bash

# retrieve MAC and IPv4 addresses from running VMs using
# QEMU Guest Agent
# Written by Henryk Paluch

set -e
#set -o pipefail

for vmid in `qm list | awk '$3=="running"' | awk '{print $1}'`
do
        vmname=$( qm config $vmid| egrep '^name:' | awk '{print $2}')
        echo "$vmid:'$vmname' has"
        qm guest cmd $vmid network-get-interfaces |
           jq -r  '.[] | select ( .name | contains("Loopback") or test("lo") | not  ) |
                      .name as $name | ."hardware-address" as $mac | ."ip-addresses"[] |
                       select ( ."ip-address-type" == "ipv4" ) | ( "\t" + $name + "\t" + $mac + "\t" + ."ip-address" )'
done
exit 0
