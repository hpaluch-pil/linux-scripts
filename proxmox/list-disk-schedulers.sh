#!/bin/bash
# list IO shcedulers for disks (block devices)
# see https://web.archive.org/web/20240109190800/https://wiki.ubuntu.com/Kernel/Reference/IOSchedulers
set -euo pipefail
for i in  /sys/block/*/queue/scheduler;do echo "$i:$(cat $i)";done
exit 0
