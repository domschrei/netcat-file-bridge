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

$nc_cmd | awk '{sw=0} /^==>.*<==$/ {out=$2; sw=1; if (dirs[out] != 1) {print "create dir for " out; system("mkdir -p '$localdir'/$(dirname " out ")"); dirs[out] = 1}} sw==0 && $0 != "" {system("echo \""$0"\" >> '$localdir'/"out)}'
