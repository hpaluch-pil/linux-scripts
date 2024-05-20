#!/bin/bash

set -e
set -o pipefail

[ $# -gt 0 ] || {
	echo "Usage: $0 file1 ..." >&2
	echo "This script renames accents to pure ASCII" >&2
	exit 1	
}

for i in "$@"
do
	[ -r "$i" ] || {
		echo "Unable to read '$i' " >&2
		exit 1
	}	
	d="$(dirname "$i")"
	f="$(basename "$i")"
	#echo "d='$d' f='$f'"
	#exit 1
	ascii=$(echo "$f" | iconv -f UTF-8 -t ASCII//TRANSLIT | sed 's/[^-a-zA-Z0-9.]/-/g' | sed 's/\.-/-/g' | sed 's/-\+/-/g' | sed 's/^-\+//' | sed 's/-\+\././g' )
	[ -n "$ascii" ] || {
		echo "Unable to convert '$i' to ASCII" >&2
		exit 1
	}
	[ "$i" != "$d/$ascii" ] || {
		echo "Conversion of '$i' resulted in same name - skipping"
		continue
	}
	echo mv -i "$i" "$d/$ascii"
	mv -i "$i" "$d/$ascii" || true
done
exit 0
