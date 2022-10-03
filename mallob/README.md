
## Mallob Use Case

Consider the decentralized scheduling platform Mallob with this directory structure running on **machine M**:

```
.api/jobs.0/
    <job descriptions should be accessible e.g. from here>
    in/
        <drop JSON files describing jobs in here>
    out/
        <result JSON files appear here>
build/
    <executables>
logs/
    logdir-of-a-certain-run/
        0/
        1/
        ...
netcat-file-bridge/
    <this repository>
```

On **machine C**, we have the following directory structure:

```
jobdescriptions/
    <we want to make job descriptions available to Mallob from here>
jobsubmission/
    <we want to submit jobs to Mallob by dropping JSON files here>
jobresults/
    <we want to receive job results from Mallob here>
logoutput/
    <we want to watch Mallob's log output from here>
netcat-file-bridge/
    <this repository>
```

To achieve a full-featured client interface at machine C for the Mallob instance running on machine M, we need to set up four bridges: (a) a job descriptions bridge (C → M), (b) a job submission bridge (C → M), (c) a job results bridge (M → C), and (d) a log output bridge (M → C). 

The collection of scripts in this directory setup these bridges for you. 
* Edit `mallob/config.sh` to your liking
* (As needed) Set up port forwarding from C to M for the ports set in the config.
* Copy the repository with your edited configuration to both machines, just below the respective base directory as shown in the above example
* (Launch Mallob)
* FIRST execute `netcat-file-bridge/mallob/setup_interface_at_mallob.sh` from the base directory on machine M
* THEN execute `netcat-file-bridge/mallob/setup_interface_at_client.sh` from the base directory on machine C
* **Important** - After you are done, execute `netcat-file-bridge/teardown.sh` on *both* machines to kill the remaining background processes. If you do not follow this step, among other problems, subsequent connections will fail.

Given ports w, x, y, z, the scripts work as follows:

* (a) **Job descriptions:** Machine C is the sender and machine M is the receiver.  
On machine M, execute `recv_migrate.sh` mapped to `.api/jobs.0/` with port w and without a hostname.  
On machine C, execute `send_migrate.sh` mapped to `jobdescriptions/` with port w and with the hostname of M.
* (b) **Job submission:** Machine C is the sender and machine M is the receiver.  
On machine M, execute `recv_migrate.sh` mapped to `.api/jobs.0/in/` with port x and without a hostname.  
On machine C, execute `send_migrate.sh` mapped to `jobsubmission/` with port x and with the hostname of M.
* (c) **Job results retrieval:** Machine M is the sender and machine C is the receiver.  
On machine M, execute `send_migrate.sh` mapped to `.api/jobs.0/out/` with port y and without a hostname.  
On machine C, execute `recv_migrate.sh` mapped to `jobresults/` with port y and with the hostname of M.
* (d) **Log output:** Machine M is the sender and machine C is the receiver.  
On machine M, execute `send_track.sh` mapped to `logs/logdir-of-a-certain-run/` with port z and without a hostname.  
On machine C, execute `recv_track.sh` mapped to `logoutput/` with port z and with the hostname of M.

You should now be able to send jobs to Mallob by dropping job descriptions into `jobdescriptions/` and then the according job JSON files into `jobsubmission/` on machine C. The script ignores files beginning with `~`; so to avoid an I/O race condition, you can write your file bit by bit with a name that begins with a `~` and then move / rename the file to something without `~`. Likewise, you should receive results in the directory `jobresults`. Last but not least, due to bridge (d), the following directory structure is created on machine C:
```
logoutput/
    logdir-of-a-certain-run/
        0/
        1/
        ...
```
