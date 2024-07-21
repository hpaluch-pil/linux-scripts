#!/bin/bash
set -euo pipefail
echo -e "Node\t\tRAM Usage Pct"
pvesh get /cluster/resources --output-format json-pretty |
 jq -r '.[] | select(.type == "node") | [.id,(10000*.mem/.maxmem|round/100)] | @tsv'
exit 0
