#!/bin/bash
# Proxmox: return SDN IPAM IP address for specified VMID
set -euo pipefail
zone=
subnet=
vmid=
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
TEMP=$(getopt -o 'z:s:v:' -n "$(basename $0)" -- "$@")
[ $? -eq 0 ]  || exit 1 # getopt already wrote error to stderr
set -e
eval set -- "$TEMP"
unset TEMP

while : ;do
	case "$1" in
		-z) shift; zone="$1" ;;
		-s) shift; subnet="$1" ;;
		-v) shift; vmid="$1" ;;
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
[ -n "$subnet" ] || errx "Missing required argument -s subnet. Use one of: $all_subnets"
echo " $all_subnets " | grep -F -q " $subnet " ||
       	errx "Invalid subnet '$subnet' for zone '$zone' specified. Valid subnets are: $all_subnets"

# third check for vmid under specified zone/subnet
all_vmids=$( jq -r --arg zone "$zone"  --arg subnet "$subnet" \
      	'.zones | .[$zone].subnets | .[$subnet].ips | to_entries | .[] | if .value.vmid then .value.vmid else empty end' \
       	 < $ipam_file | tr '\n' ' ' | sed 's/ $//' )
[ -n "$all_vmids" ] || errx "No vmid found for zone '$zone' and subnet '$subnet'"
[ -n "$vmid" ] || errx "Missing required argument -v vmid. Use one of: $all_vmids"
echo " $all_vmids " | grep -F -q " $vmid " ||
       	errx "Invalid vmid '$vmid' for subnet '$subnet' and zone '$zone' specified. Valid vmids are: $all_vmids"

jq -r --arg zone "$zone" --arg subnet "$subnet" --arg vmid "$vmid" \
   '.zones | .[$zone].subnets | .[$subnet].ips |
   to_entries | .[] |
   if .value.vmid == $vmid then .key else empty end'  \
   < $ipam_file
exit 0


