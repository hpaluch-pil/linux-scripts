#!/bin/bash
# list-file-extensions.sh - list unique file extensions in git project
# tested using Bash 5.2.37 under Fedora 42

set -euo pipefail

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

g="$d/.git"
[ -d "$g" ] || {
	echo "WARN: There is no '.git' folder in '$d' directory - you may get unexpected results" >&2
}

# 1. find all files ignoring these under .git directory
# 2. (sed) we remove path - everything till last '/' + remove starting dots '.' from filename
# 3. (sed -r) we remove all text before extension (last '.')
# 4. (grep -F) we filter out files without extension (without '.' in filename)
# 5. Unique sort - print each unique extension only once
find "$d" -path ./.git -prune -o -type f |
	sed 's@.*/@@;s@^\.\+@@'  |
	sed -r 's/.*(\.[^.]+)$/\1/' |
	grep -F '.' |
	sort -u
exit 0
