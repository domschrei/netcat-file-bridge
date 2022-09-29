#!/bin/bash

set -e

source $(basename $0)/config.sh

# Send files for job submission
bash send_migrate.sh $client_job_submission_dir $mallob_hostname $port_m_jobsubmission &
pids="$pids $!"
# Receive job results
bash recv_migrate.sh $client_job_results_dir $port_c_jobresults &
pids="$pids $!"
# Receive log directory
bash recv_track.sh $client_overall_logdir $port_c_logoutput &
pids="$pids $!"

wait $pids
