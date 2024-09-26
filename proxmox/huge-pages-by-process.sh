#!/bin/bash
# huge-pages-by-process.sh - List Processes with Anonymous HugePages (typically KVM)
# - modified version from: https://access.redhat.com/solutions/46111
# - summing data from: https://stackoverflow.com/a/14916890
set -eu

# requires 'gawk' - some Proxmox installs have 'mawk' which has no 'gensub' function.
f=gawk
which "$f" > /dev/null 2>&1 || {
	echo "ERROR:  command '$f' not available" >&2
	exit 1
}
fmt="-o uid,pid,ppid,min_flt,maj_flt,vsz:8,rss:8,pmem,c,stime,tty,time,cmd"

# generate ps header only
ps -fp 1 $fmt | head -1
# list all THP by process
# we filter out zero HugePages to avoid race condition when process quickly exits
gawk  '/AnonHugePages:[ \t]+[1-9]/ { if($2>4){ kb[FILENAME] += $2 } }
END{ for (a in kb){
	system("ps --no-header -fp " gensub(/.*\/([0-9]+).*/, "\\1", "g", a) "'" $fmt"'");
	print "  -> AnonHugePages:",kb[a]/1024.0,"MB"
     }
}' /proc/*/smaps
exit 0

