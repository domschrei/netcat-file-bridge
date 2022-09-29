#!/bash

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
        if [ -f "$f" ]; then

            case $HOST in ~*)
                # File begins with a tilde - ignore
                continue
            esac

            echo "Transferring $f ..."
            cat $f | nc -q 0 "$remotehost" "$port"
            echo "Transferred $f"
            rm "$f"
        fi
    done

    sleep 0.1
done
