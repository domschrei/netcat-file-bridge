#!/bin/bash

# Repeatedly receives files over netcat from a remote host.
# Each arrived file is written to the given local directory.

if [ -z $1 ] || [ -z $2 ]; then
    echo "Usage: [script] local-directory local-port"
    exit 1
fi

localdir="$1"
port="$2"

while true; do
    
    initialoutput="$localdir/../~nc_input.json"
    
    nc -l -p $port > "$initialoutput" 2> _errout
    retval=$?
    if [ $retval == 0 ]; then
        # First read the original file name
        filebasename=$(head -1 "$initialoutput")
        echo "Received $initialoutput, filename $filebasename"
        prelimdestination="$localdir/../~$filebasename"
        finaldestination="$localdir/$filebasename"
        # Write the file except for its first line to the preliminary destination
        tail -n +2 "$initialoutput" > "$prelimdestination"
        # Move the file to its actual destination
        mv "$prelimdestination" "$finaldestination"
        echo "Wrote to $finaldestination"
    else
        echo "Interrupted or error"
        sleep 1
    fi
done
