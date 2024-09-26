#!/bin/bash
# Show running KVM processes with Fault info + memory info
set -euo pipefail
ps -C kvm -o pid,min_flt,maj_flt,%mem,rss,vsz,comm,cmd | sed 's/,debug-threads.*//'
exit 0
