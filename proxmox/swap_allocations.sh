#!/bin/bash

# Show swap allocations
# script from: https://forum.proxmox.com/threads/swappiness-question.42295/page-2

set -xe
smem -s swap -r | head -n 12

