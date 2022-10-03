#!/bin/bash

# Must be a valid, addressable host in the client's network
mallob_hostname=localhost # machine M

# Must be available ports on machine M and C
port_jobdescriptions=8900
port_jobsubmission=8901
port_jobresults=8902
port_logoutput=8903

if [ $1 == client ]; then
    # Directories on machine C, relative to where the script is called from
    client_job_descriptions_dir=jobdescriptions/
    client_job_submission_dir=jobsubmission/
    client_job_results_dir=jobresults/
    client_overall_logdir=logoutput/

    mkdir -p $client_job_descriptions_dir $client_job_submission_dir $client_job_results_dir $client_overall_logdir
fi

if [ $1 == mallob ]; then
    # Directories on machine M, relative to where the script is called from
    mallob_job_descriptions_dir=.api/jobs.0/
    mallob_job_submission_dir=.api/jobs.0/in/
    mallob_job_results_dir=.api/jobs.0/out/
    mallob_overall_logdir=logs/
    mallob_this_run_logdir="$(ls -t $mallob_overall_logdir|head -1)/" # latest log directory
fi
