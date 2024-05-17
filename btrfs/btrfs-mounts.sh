#!/bin/bash
set -xeuo pipefail
exec findmnt -t btrfs
