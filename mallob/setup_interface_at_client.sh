#!/bin/bash

set -e

bridgebasedir="$(dirname $0)/.."
source $bridgebasedir/mallob/config.sh client

# Send files for job submission
$bridgebasedir/send_migrate.sh $client_job_submission_dir $port_jobsubmission $mallob_hostname > _client_log_jobsubmission 2>&1 &
pids="$pids $!"
# Receive job results
$bridgebasedir/recv_migrate.sh $client_job_results_dir $port_jobresults $mallob_hostname > _client_log_jobresults 2>&1 &
pids="$pids $!"
# Receive log directory
$bridgebasedir/recv_track.sh $client_overall_logdir $port_logoutput $mallob_hostname > _client_log_logoutput 2>&1 &
pids="$pids $!"

echo "Launched subprocesses, PIDS $pids"
sleep 0.5
