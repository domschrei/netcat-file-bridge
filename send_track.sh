#!/bin/bash

# Watches all files in a given directory and sends new lines,
# qualified by their filename, to a netcat destination.

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]; then
    echo "Usage: [script] local-base-dir mirrored-sub-dir port [remote-host]"
    exit 1
fi

localbasedir="$1"
mirroredsubdir="$2"
port="$3"

listen=true
if ! [ -z "$4" ]; then
    listen=false
    remotehost="$4"
fi

# Gather all files which should be watched
allfiles=$(cd "$localbasedir" && find "$mirroredsubdir" -type f | tr '\n' ' ')
echo "Watching (relative to $localbasedir): $allfiles"

# This function takes a number of files and prints a tail -f like
# output for each file without providing any actual content.
# This could be needed to properly initialize empty sender-side files 
# on the receiver side as well.
function introduce_all_files() {
    files="$1"
    for f in $files; do
        echo "==> $f <=="
        echo ""
    done
}

cd "$localbasedir"
if $listen; then
    nc_cmd="nc -l -p $port"
else
    nc_cmd="nc $remotehost $port"
fi

# Introduce and then follow all files, write to netcat.
# "-c +0" tells tail to begin at the 0th byte of each file
# instead of beginning at the last 10 lines.
( introduce_all_files "$allfiles" ; tail -c +0 -f $allfiles ) | $nc_cmd
