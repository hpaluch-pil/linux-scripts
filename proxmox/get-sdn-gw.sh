#!/bin/bash
# Proxmox: return SDN IPAM Gateway address for specified Zone and Subnet
set -euo pipefail
zone=
subnet=
ipam_file=/etc/pve/sdn/pve-ipam-state.json

errx ()
{
	echo "ERROR: $*" >&2
	exit 1
}

[ -r "$ipam_file" ] || errx "IPAM file: $ipam_file not readable"

for i in getopt jq; do
	which "$i" > /dev/null 2>/dev/null || errx "Command '$i' not found"
done

# get all zones
all_zones=$( jq -r '.zones | keys | @tsv' < $ipam_file | tr '\t' ' ' )
[ -n "$all_zones" ] || errx "No zone found in $ipam_file"


# getopt handling based on: /usr/share/doc/util-linux/examples/getopt-example.bash
# intermediate TEMP variable required keep getopt status code
set +e
TEMP=$(getopt -o 'z:s:' -n "$(basename $0)" -- "$@")
[ $? -eq 0 ]  || exit 1 # getopt already wrote error to stderr
set -e
eval set -- "$TEMP"
unset TEMP

while : ;do
	case "$1" in
		-z) shift; zone="$1" ;;
		-s) shift; subnet="$1" ;;
		--) shift; break ;;
		*) errx "Invalid option '$1'" ;;
	esac
	shift
done
[ $# -eq 0 ] || errx "Run-away arguments: '$@'"
# first check for top-level: Zone
[ -n "$zone" ] || errx "Missing required argument -z zone. Use one of: $all_zones"
echo " $all_zones " | grep -F -q " $zone " ||
       	errx "Invalid zone '$zone' specified. Valid zones are: $all_zones"

# second check for Subnet under specified zone
all_subnets=$( jq --arg zone "$zone"  -r '.zones | .[$zone].subnets | keys | @tsv' < $ipam_file | tr '\t' ' ' )
[ -n "$all_subnets" ] || errx "No subnet found for zone '$zone'"
[ -n "$subnet" ] || errx "Missing required argument -s subnet. Use one of: $all_subnets "
echo " $all_subnets " | grep -F -q " $subnet " ||
       	errx "Invalid subnet '$subnet' for zone '$zone' specified. Valid subnets are: $all_subnets"

jq -r --arg zone "$zone" --arg subnet "$subnet" \
   '.zones | .[$zone].subnets | .[$subnet].ips |
   to_entries | .[] |
   if .value.gateway == 1 then .key else empty end'  \
   < $ipam_file
exit 0


