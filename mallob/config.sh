#!/bin/bash

# Must be valid, addressable hosts in the current network
mallob_hostname=localhost # machine M
client_hostname=localhost # machine C

# Must be available ports on machine M / C
port_m_jobsubmission=8901
port_c_jobresults=8902
port_c_logoutput=8903

if [ $1 == client ]; then
    # Directories on machine C, relative to where the script is called from
    client_job_submission_dir=jobsubmission/
    client_job_results_dir=jobresults/
    client_overall_logdir=logoutput/
fi

if [ $1 == mallob ]; then
    # Directories on machine M, relative to where the script is called from
    mallob_job_submission_dir=.api/jobs.0/in/
    mallob_job_results_dir=.api/jobs.0/out/
    mallob_overall_logdir=logs/
    mallob_this_run_logdir="$(ls -t $mallob_overall_logdir|head -1)/" # latest log directory
fi
