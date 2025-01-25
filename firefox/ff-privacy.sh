#!/bin/bash
# My Firefox privacy settings - tested on Fedora 41
set -xeuo pipefail

my_dir=$(dirname $0)

d=/etc/firefox/defaults/pref
[ -d "$d" ] || sudo mkdir -p $d

s=$my_dir/syspref.js
t=$d/syspref.js

if [ -f "$t" ];then
	diff $t $s || {
		echo "File '$t' already exists and differs - exiting" >&2
		exit 1
	}
else
	sudo cp -v $s $t
fi
exit 0

