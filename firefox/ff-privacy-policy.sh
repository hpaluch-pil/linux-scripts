#!/bin/bash
# My Firefox privacy settings via Policy - tested on Fedora 44
set -xeuo pipefail

my_dir=$(dirname $0)

d=/etc/firefox/policies
[ -d "$d" ] || sudo mkdir -p $d

s=$my_dir/policies.json
t=$d/policies.json

if [ -f "$t" ];then
	diff $t $s || {
		echo "File '$t' already exists and differs - exiting" >&2
		exit 1
	}
else
	sudo cp -v $s $t
fi
exit 0

