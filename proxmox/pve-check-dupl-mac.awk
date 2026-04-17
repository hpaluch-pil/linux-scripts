#!/usr/bin/awk -f
# Check Proxmox for duplicate VM MAC addresses.
# Usage: ./pve-check-dupl-mac.awk /etc/pve/qemu-server/*.conf
BEGIN {
	errmsg=""
#	print "ARGC: " ARGC
#	for (var in ARGV){
#		printf("- ARGV[%d]='%s'\n", var, ARGV[var]);
#	}
#	print "ERRNO: " ERRNO
	if (ARGC < 2 ){
		errx("Too few arguments, Usage: ./pve-check-dupl-mac.awk /etc/pve/qemu-server/*.conf")
	}
	# trick to declare empty array
	delete mac2vm["fake"]
}

BEGINFILE {
	name="";
	vmid="";
	if (ERRNO){
		errx(sprintf("Unable to open '%s': %s\n", FILENAME, ERRNO))
	}
	if (match(FILENAME,"/[0-9]+\\.conf$")){
		#printf("STR='%s' RSTART=%d RLENGTH=%d\n", FILENAME, RSTART, RLENGTH);
		fname=substr(FILENAME, RSTART, RLENGTH);
		#printf("basename='%s'\n", fname);
		if(match(fname,"[0-9]+")){
			vmid=substr(fname,RSTART,RLENGTH);
			#printf("Got VMID='%s'\n", vmid);
		} else {
			errx(sprintf("Unable to extract VMID from pathname '%s'\n", FILENAME));
		}
	} else {
	   errx(sprintf("Filename '%s' must match pattern NUMBER.conf\n",FILENAME))
	}
}

# skip empty line followed by [SNAPSHOT_NAME]
/^$/ {
	#printf("INFO: Skipping snapshot in '%s' VMID='%s'\n", FILENAME, vmid);
	nextfile
}

/^name:/ { name=$2; }
/^net[0-9]:/ {
	args=$2
	netname=substr($1,0,length($1)-1)
	if(match(args,"=..:..:..:..:..:..")){
		mac=substr(args,RSTART+1, RLENGTH-1);
		#printf("MAC='%s' for '%s'\n", mac, netname);
		vmstr=sprintf("%s (%s) %s", vmid, name, netname)
		if (mac in mac2vm){
			errx(sprintf("Duplicate MAC='%s' for '%s', first seen on '%s'\n", mac, vmstr, mac2vm[mac]));
		} else {
			mac2vm[mac]=vmstr;
		}
	} else {
		errx(sprintf("Unable to extract MAC address from '%s', filename='%s'\n", $0, FILENAME));
	}
}

ENDFILE {
	#printf("INFO: Processed '%s', VMID='%s', NAME='%s'\n", FILENAME, vmid, name);
}

END {
#	printf("END:\n")
#	for(var in mac2vm){
#		printf("- MAC='%s' => VM/NET: '%s'\n", var, mac2vm[var])
#	}
	if (errmsg){
		printf("Exiting on ERROR: %s\n", errmsg);
	} else {
		printf("OK: no duplicate MAC found, scanned %d files %d addresses\n", ARGC-1, length(mac2vm));
	}
}

# Print error on stderr and exit
function errx(msg){
	# NOTE: filename (/dev/stderr) MUST be quoted!
	printf("ERROR: %s\n", msg) > "/dev/stderr"
	errmsg=msg
	exit 1
}
