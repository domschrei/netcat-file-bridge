#!/bin/bash

# Watches a given LOCAL directory.
# If a new file arrives, its content is sent via netcat.

if [ -z $1 ] || [ -z $2 ]; then
    echo "Usage: send_migrate.sh local-directory port [hostname]"
    exit 1
fi

localdir="$1"
port="$2"

listen=true
if ! [ -z "$3" ]; then
    listen=false
    remotehost="$3"
fi

while true; do

    for f in $(find "$localdir" -maxdepth 1 -type f); do

        case $HOST in ~*)
            # File begins with a tilde - ignore
            continue
        esac

        echo "Transferring $f ..."
        # Transfer the filename and then the content
        if $listen; then
            nc_cmd="nc -l -q 0 $port"
        else
            nc_cmd="nc -q 0 $remotehost $port"
        fi
        # Transfer file via joining an existing connection
        while ! ( ( basename $f ; cat $f ) | nc -q 0 "$remotehost" "$port" ); do
            echo "- retrying"
            sleep 0.1
        done
        echo "Transferred $f"
        rm "$f"
    done

    sleep 0.1
done
