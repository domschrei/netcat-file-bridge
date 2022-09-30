#!/bin/bash

set -e

bridgebasedir="$(dirname $0)/.."
source $bridgebasedir/mallob/config.sh mallob

# Receive files for job submission
$bridgebasedir/recv_migrate.sh $mallob_job_submission_dir $port_jobsubmission > _mallob_log_jobsubmission 2>&1 &
pids="$pids $!"
# Send job results
$bridgebasedir/send_migrate.sh $mallob_job_results_dir $port_jobresults > _mallob_log_jobresults 2>&1 &
pids="$pids $!"
# Send log directory
$bridgebasedir/send_track.sh $mallob_overall_logdir $mallob_this_run_logdir $port_logoutput > _mallob_log_logoutput 2>&1 &
pids="$pids $!"

echo "Launched subprocesses, PIDS $pids"
sleep 0.5
