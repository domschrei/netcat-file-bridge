#!/bin/bash

# Reads a stream of lines, qualified by their file name, from netcat
# and writes each line into the corresponding file in a local directory.

if [ -z $1 ] || [ -z $2 ]; then
    echo "Usage: [script] local-directory port [remote-host]"
    exit 1
fi

localdir="$1"
port="$2"

listen=true
if ! [ -z "$3" ]; then
    listen=false
    remotehost="$3"
fi

if $listen; then
    nc_cmd="nc -l -p $port"
else
    nc_cmd="nc $remotehost $port"
fi

# Lines advertising a new file of origin ("==> FILENAME <==") are filtered
# and the respective file is initialized, if not already done before.
# Other non-empty lines are written to the current file of origin.
$nc_cmd | sed -u 's/"/\\"/g' | awk '{sw=0} /^==>.*<==$/ {out=$2; sw=1; if (dirs[out] != 1) {print "create " out; system("mkdir -p '$localdir'/$(dirname " out "); touch '$localdir'/" out); dirs[out] = 1}} sw==0 && $0 != "" {system("echo \""$0"\" >> '$localdir'/"out)}'
