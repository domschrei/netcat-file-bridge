#!/bin/bash

set -e

bridgebasedir="$(dirname $0)/.."
source $bridgebasedir/mallob/config.sh client

# Send files for job submission
$bridgebasedir/send_migrate.sh $client_job_submission_dir $port_m_jobsubmission $mallob_hostname &
pids="$pids $!"
# Receive job results
$bridgebasedir/recv_migrate.sh $client_job_results_dir $port_c_jobresults $mallob_hostname &
pids="$pids $!"
# Receive log directory
$bridgebasedir/recv_track.sh $client_overall_logdir $port_c_logoutput $mallob_hostname &
pids="$pids $!"

wait $pids
