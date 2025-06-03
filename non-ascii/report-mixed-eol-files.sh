#!/bin/bash
# validate text files that mix both LF and CRLF
# tested using Bash 5.2.37 under Fedora 42

set -euo pipefail

exp_type='ASCII text'
mixed_eols_regex='with CRLF, (CR|LF) line terminators'
ret=0 # return code, 0=success

[ $# -lt 2 ] || {
	echo "Usage: $0 [ git_project_directory ]"
	exit 1
}
d="."
[ $# -eq 0 ] || d="$1"
[ -d "$d" ] || {
	echo "ERROR: Path '$d' is not directory" >&2
	exit 1
}

if [[ $d =~ ./$ ]]; then
	newd="${d%%/}"
	echo "WARN: Removing trailing '/' from '$d' -> '$newd'" >&2
	d="$newd"
fi

g="$d/.git"
[ -d "$g" ] || {
	echo "WARN: There is no '.git' folder in '$d' directory - you may get unexpected results" >&2
}

filelist="`mktemp`"
errlist="`mktemp`"
trap "rm -f -- $filelist $errlist" EXIT

# -size +0 => only non empty files with size > 0
# find either files with specific extensions + .gitignore and .gitattributes
find "$d" -path "$d/.git" -prune -o -type f \
       	-size +0 -print0 | xargs -0 file -N | grep -F "$exp_type" > $filelist
[ -s "$filelist" ] || {
	echo "ERROR: File list is empty - file of type '$exp_type' found(?)" >&2
	exit 1
}
#cat -v "$filelist"
echo "INFO: Found $(wc -l < "$filelist") text files"

# error: list text files with CRLF
if grep -E "$mixed_eols_regex" "$filelist" > "$errlist"; then 
	echo "ERROR: found $(wc -l < "$errlist") text files with mixed CR and CRLF EOLs:" >&2
	sed -e 's/^/- /' "$errlist" | cat -v
	(( ret = ret + 1 ))
fi

exit $ret
