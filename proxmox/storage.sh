#!/bin/bash
set -xeuo pipefail
pvesh get /nodes/`hostname`/storage
exit 0
