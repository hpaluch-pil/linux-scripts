#!/bin/bash
# report-modified-projects.sh - list all modified git projects in current directory"
set -euo pipefail

usage()
{
	echo "Usage: to report all modified projects in current dir, try: $0 */.git/config" >&2
	exit 1
}

verbose_command()
{
	echo "INFO: Running '$@'..."
	"$@"
}

declare -a cfg_files
declare -A bad_projects
bad_projects=( )

cfg_files=( */.git/config )
[ $# -lt 1 ] || cfg_files=( "$@" )

for i in "${cfg_files[@]}"
do
	[ -f "$i" ] || {
		echo "ERROR: '$i' is not a file" >&2
		usage
	}
	gitdir="${i%%/.git/config}"
	[ -d "$gitdir" ] || {
		echo "ERROR: git parent dir '$gitdir' is not directory" >&2
		usage
	}
	grep -HEo 'url = .*' "$i"
	#verbose_command git branch -v
	gs="$( cd "$gitdir" && git status --porcelain)"
	[ -z "$gs" ] || {
		: "${bad_projects["$gitdir"]:=$gs}"
		echo "ERROR: Project '$gitdir' has been modified:"
		echo "$gs"

	}
done
echo "There are ${#bad_projects[@]} modified projects out of total ${#cfg_files[@]}:"
for i in "${!bad_projects[@]}"
do
	echo "- $i:"
	echo "${bad_projects[$i]}" | sed 's/^/ /'
done
exit 0

