#!/bin/bash

# Watches all files in a given directory and sends new lines,
# qualified by their filename, to a netcat destination.

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ] || [ -z $4 ]; then
    echo "Usage: [script] local-base-dir mirrored-sub-dir remote-hostname remote-port"
    exit 1
fi

localbasedir="$1"
mirroredsubdir="$2"
remotehost="$3"
port="$4"

# Setup FIFO, connected to netcat, into which we pipe all lines
fifofile="_watchtree_submit_fifo"
rm $fifofile 2>/dev/null
mkfifo $fifofile
cat $fifofile | nc $remotehost $port &

# Gather all files which should be watched
allfiles=$(cd "$localbasedir" && find "$mirroredsubdir" -type f | tr '\n' ' ')
echo "Watching (relative to $localbasedir): $allfiles"

# Follow all files, write into FIFO
( cd "$localbasedir" && tail -f $allfiles ) > $fifofile
