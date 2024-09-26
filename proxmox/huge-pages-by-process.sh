#!/bin/bash
# huge-pages-by-process.sh - List Processes with Anonymous HugePages (typically KVM)
# - modified version from: https://access.redhat.com/solutions/46111
set -eu

# generate ps header only
ps -fp 1 | head -1
# list all THP by process (does NOT group listing by PID)
# we filter out zero HugePages to avoid race condition when process quickly exits
awk  '/AnonHugePages:[ \t]+[^0]/ { if($2>4){print FILENAME " " $0; system("ps --no-header -fp " gensub(/.*\/([0-9]+).*/, "\\1", "g", FILENAME))}}' \
       	/proc/*/smaps
exit 0

