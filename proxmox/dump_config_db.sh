#!/bin/bash

# Dumps config.db as SQL commands
# Written by Henryk Paluch

set -e
set -o pipefail

db=/var/lib/pve-cluster/config.db

[ $# -eq 1 ] || {
	echo "Usage: $0 dump_directory" >&2
	exit 1
}

d="$1"
[ -d "$d" ] || {
	echo "Specified path '$d' is not directory" >&2
	exit 1
}

[ -r "$db" ] || {
	echo "Database file '$db' unreadable" >&2
	exit 1
}

t="$d/config-db-`date '+%Y-%m-%d-%H-%M-%S'`.sql"

sqlite3 "$db" .dump > $t
tail -1 $t | egrep -q "^COMMIT" || {
	echo "Last line in dump '$t' must contain COMMIT" >&2
	exit 1
}
gzip -9 $t

# trivial recovery check (not much reliable)
r=$(mktemp --suffix=.db)
zcat $t.gz | sqlite3 "$r"
ttt=$(sqlite3 "$r" .tables)
[ "$ttt" = "tree" ] || {
	echo "Restored tables '$ttt' <> 'tree'" >&2
	exit 1
}
rm -f -- "$r"



exit 0
