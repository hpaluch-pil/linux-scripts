#!/bin/bash
# pull all git repos here
set -euo pipefail

function usage
{
	echo "Usage: to pull all sub-projects in this directory, try: $0 */.git/config" >&2
	exit 1
}

declare -a cfg_files

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
	set -x
	pushd "$gitdir"
	git branch -v
	git status
	set +x
	echo -n "Run git pull in '$gitdir' [Y/n]? "
	read ans
	case "$ans" in
		[nN]|[nN][oO])
			echo "INFO: Skipped on user request"
			;;
		*)
			set -x
			git pull
			set +x
			;;
	esac
	echo "INFO: leaving  '$gitdir'"
	popd
done
exit 0

