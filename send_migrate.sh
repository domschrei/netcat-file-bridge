#!/bin/bash

# Watches a given LOCAL directory.
# If a new file arrives, its content is sent via netcat.

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]; then
    echo "Usage: [script] local-directory remote-hostname remote-port"
    exit 1
fi

localdir="$1"
remotehost="$2"
port="$3"

while true; do

    for f in $(find "$localdir" -maxdepth 1 -type f); do

        case $HOST in ~*)
            # File begins with a tilde - ignore
            continue
        esac

        echo "Transferring $f ..."
        # Transfer the filename and then the content
        while ! ( ( basename $f ; cat $f ) | nc -q 0 "$remotehost" "$port" ); do
            echo "- retrying"
            sleep 0.1
        done
        echo "Transferred $f"
        rm "$f"
    done

    sleep 0.1
done
