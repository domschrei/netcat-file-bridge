#!/bash

# Repeatedly receives files over netcat from a remote host.
# Each arrived file is written to the given local directory.

if [ -z $1 ] || [ -z $2 ]; then
    echo "Usage: [script] local-directory local-port"
    exit 1
fi

localdir="$1"
port="$2"

fileid=1

while true; do
    
    output="$localdir/~nc_input_$fileid.json"
    finaloutput="$localdir/nc_input_$fileid.json"
    
    nc -l -p $port -w 1 > "$output" 2> _errout
    retval=$?
    if cat _errout|grep -q "timed out" ; then
        rm "$output"
    elif [ $retval == 0 ]; then
        echo "Received $output"
        mv "$output" "$finaloutput"
        echo "Wrote to $finaloutput"
        fileid=$((fileid+1))
    else
        echo "Interrupted or error"
        exit 0
    fi
done
