#!/bin/bash

pids=$(ps aux|grep -E "[s]end_migrate|recv_migrate|send_track|recv_track"|awk '{print $2}'|tr '\n' ' ')
kill $pids 2>/dev/null
killall nc 2>/dev/null
sleep 1
kill -9 $pids 2>/dev/null
killall -9 nc 2>/dev/null
