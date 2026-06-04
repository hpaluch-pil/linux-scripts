#!/bin/bash
# Shows you the largest objects in your repo's pack file.
# Based on https://web.archive.org/web/20220126211421/https://stubbisms.wordpress.com/2009/07/10/git-script-to-show-largest-pack-objects-and-trim-your-waist-line/
set -eu
# lastpipe is needed so the block {} may append "output" variable
shopt -s lastpipe

echo "All sizes are in kB's. The pack column is the size of the object, compressed, inside the pack file."
output="size_kb,pack_kb,SHA,location"
git verify-pack -v .git/objects/pack/pack-*.idx | grep -v chain | sort -k3nr | head | {
        while read sha typ sizekb packsizekb offset
        do
            #echo "sha='$sha',sizekb='$sizekb',packsizekb='$packsizekb',offset='$offset'"
            (( sizekb = sizekb / 1024 ))
            (( packsizekb = packsizekb / 1024 ))
            other=`git rev-list --all --objects | grep $sha`
            output="${output}\n${sizekb},${packsizekb},${other}"
        done
}
echo -e $output | column -t -s ','
exit 0

