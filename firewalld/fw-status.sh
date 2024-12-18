#!/bin/bash
set -euo pipefail

function run_cmd
{
	echo
	echo "\$ $@"
	"$@"
}

run_cmd firewall-cmd --state
run_cmd firewall-cmd --get-active-zones

# list of active zones, filter out lines starting with spaces
az=`firewall-cmd --get-active-zones | awk '/^[a-z]/ { print $1 }'`
for i in $az
do
	run_cmd firewall-cmd --info-zone=$i
done
pols=`firewall-cmd --get-policies`
for i in $pols
do
	run_cmd firewall-cmd --info-policy=$i
done
exit 0
