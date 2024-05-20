#!/bin/bash
# scan files for non-ASCII characters
# based on: https://forum.gitlab.com/t/after-upgrade-from-15-11-5-to-16-0-gitlab-ce-down-cpu-100/86924/16
set -euo pipefail
[ $# -gt 0 ] || {
	echo "Usage: $0 file1 ...." >&2
	exit 1
}

for i in "$@"
do
	[ -f "$i" -a -r "$i" ] || {
		echo "ERROR: '$i' is not file or not readable" >&2
		exit 1
	}
	grep --color='auto' -H -P -n "[\x80-\xFF]" "$i"
done
exit 0
