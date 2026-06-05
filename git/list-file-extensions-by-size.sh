#!/bin/bash
# list-file-extensions-by-size.sh - list file extensions sorted by size asc
# tested using Bash 5.3.9 under Fedora 44

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
# 5. (sort) - group output by ext names - we need that for next step
# 6. (awk ...) group items by name, printing sum of size
# 7. (sort) - sort output by size asc
# 8. (numfmt)  convert sizes to human readable format
# 9. (column) format output as 2 column table
find "$d" -path ./.git -prune -o -type f -printf '%s|%p\n' |
	sed 's@|.*/@|@;s@|\.\+@@'  |
	sed -r 's/\|.*(\.[^.]+)$/|\1/' |
	grep -F '.' |
	sort -t '|' -k 2 |
       	awk -F '|' '
BEGIN {
	last_ext = "";
	sum = 0;
}
/^[0-9]+/ {
	if ( $2 == last_ext ){
		sum += $1;
	} else {
		if (sum > 0){
			printf("%d|%s\n",sum,last_ext);
		}
		sum = $1; last_ext = $2;
	}
}
END {
	if (sum > 0){
		printf("%d|%s\n",sum,last_ext);
	}
}
' |
       	sort -n -t '|' -k 1 |
       	numfmt -d '|' --field=1 --to=iec |
       	column -t -s '|' --table-columns SIZE,EXT --table-right SIZE
exit 0
