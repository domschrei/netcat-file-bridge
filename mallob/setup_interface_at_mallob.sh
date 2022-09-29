#!/bin/bash

set -e

source $(basename $0)/config.sh

# Receive files for job submission
bash recv_migrate.sh $mallob_job_submission_dir $port_m_jobsubmission &
pids="$pids $!"
# Send job results
bash send_migrate.sh $mallob_job_results_dir $client_hostname $port_c_jobresults &
pids="$pids $!"
# Send log directory
bash send_track.sh $mallob_overall_logdir $mallob_this_run_logdir $client_hostname $port_c_logoutput &
pids="$pids $!"

wait $pids
