#!/bin/bash
# huge-pages-by-process.sh - List Processes with Anonymous HugePages (typically KVM)
# - modified version from: https://access.redhat.com/solutions/46111
set -eu

# requires 'gawk' - some Proxmox installs have 'mawk' which has no 'gensub' function.
f=gawk
which "$f" || {
	echo "ERROR:  command '$f' not available" >&2
	exit 1
}

# generate ps header only
ps -fp 1 | head -1
# list all THP by process (does NOT group listing by PID)
# we filter out zero HugePages to avoid race condition when process quickly exits
gawk  '/AnonHugePages:[ \t]+[^0]/ { if($2>4){print FILENAME " " $0; system("ps --no-header -fp " gensub(/.*\/([0-9]+).*/, "\\1", "g", FILENAME))}}' \
       	/proc/*/smaps
exit 0

