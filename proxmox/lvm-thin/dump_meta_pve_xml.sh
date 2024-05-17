#!/bin/bash
set -euo pipefail

vg=pve
lv=$vg-data
# NOTE: -tpool is visible to dmsetup only (see "dmsetup ls")
set -x
xml=$lv-$(date '+%s').xml
lvs -a -o-convert_lv,move_pv,mirror_log,copy_percent $vg
echo
dmsetup message $lv-tpool 0 reserve_metadata_snap
trap "dmsetup message $lv-tpool 0 release_metadata_snap" EXIT
thin_dump -m /dev/mapper/${lv}_tmeta | tee $xml
exit 0
