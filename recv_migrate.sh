#!/bin/bash

# Repeatedly receives files over netcat from a remote host.
# Each arrived file is written to the given local directory.

if [ -z $1 ] || [ -z $2 ]; then
    echo "Usage: recv_migrate.sh local-directory port [hostname]"
    exit 1
fi

localdir="$1"
port="$2"

listen=true
if ! [ -z "$3" ]; then
    listen=false
    remotehost="$3"
fi

function write_arrived_file() {
    localdir="$1"
    initialoutput="$2"
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
}

while true; do
    
    initialoutput="$localdir/../~nc_input.json"
    
    if $listen; then
        # Open the connection and listen until a full file arrived
        nc -l -p "$port" > "$initialoutput" 2> _errout_recv
    else
        # Connect to an existing remote connection
        nc "$remotehost" "$port" > "$initialoutput" 2> _errout_recv
    fi
    retval=$?
    if [ $retval == 0 ] && [ $(cat "$initialoutput"|wc -l) -gt 0 ]; then
        write_arrived_file "$localdir" "$initialoutput"
    else
        sleep 0.1
    fi
done
