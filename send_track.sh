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

# Follow all files, write into FIFO
cd "$localbasedir"
if $listen; then
    tail -f $allfiles | nc -l -p $port
else
    tail -f $allfiles | nc $remotehost $port
fi
