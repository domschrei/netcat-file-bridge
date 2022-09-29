
# netcat-file-bridge

This tool allows to mirror certain files from one machine to another, using the Unix utility `netcat`.

## Use Cases

There are two use cases for this tool:

* **Migrate**: From time to time, some application on machine A writes a text file to a certain directory. This tool reads each such file, deletes it, and then sends it to a certain target directory on machine B.
* **Track**: There is a number of (existing) text files within a certain directory on machine A, possibly organized as a hierarchical structure with some levels of subdirectories. Each of the files may be appended to at any time. This tool tracks the output to each file and mirrors it to an analogous directory structure within a certain directory on machine B.

## Toolbox

The tool consists of the following four scripts:

* `send_migrate.sh`: The **sender-side** script for **migrating files**. Provide three arguments: (1) the local directory (relative to the calling path) which should be watched, (2) the hostname of the destination machine, and (3) the port used at the destination machine.
* `recv_migrate.sh`: The **receiver-side** script for **migrating files**. Provide two arguments: (1) the destination directory to write incoming files to, and (2) the port at which to listen.
* `send_track.sh`: The **sender-side** script for **tracking files**. Provide four arguments: (1) the local directory (relative to the calling path) which contains the directory to listen to, (2) the subdirectory within the directory from (1) which contains the files to be followed, (3) the hostname of the destination machine, and (4) the port used at the destination machine.
* `recv_track.sh`: The **receiver-side** script for **tracking files**. Provide two arguments: (1) the destination directory in which the tracked directory structure should be mirrored, and (2) the port at which to listen.

## Example: Mallob

As a very natural example that is simple to understand for everyone and totally not the only use case for which we wrote this tool, consider the decentralized scheduling platform Mallob with this directory structure running on **machine M** (hostname `$HOSTNAME_M`):

```
.api/jobs.0/
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

On **machine C** (hostname `$HOSTNAME_C`), we have the following directory structure:

```
jobsubmission/
    <we want to submit jobs to Mallob by dropping JSON files here>
jobresults/
    <we want to receive job results from Mallob here>
logoutput/
    <we want to watch Mallob's log output from here>
netcat-file-bridge/
    <this repository>
```

<hr/>

Before explaining the details, note that we provide scripts in the directory `mallob/` which setup this entire Mallob interface for you.
* Edit `mallob/config.sh` to your liking
* Copy the repository with your edited configuration to both machines, just below the respective base directory as shown in the above example
* FIRST execute `netcat-file-bridge/mallob/setup_interface_at_client.sh` from the base directory on the client machine
* THEN execute `netcat-file-bridge/mallob/setup_interface_at_mallob.sh` from the base directory on the Mallob machine

<hr/>

To achieve a full-featured client interface at machine C for the Mallob instance running on machine M, we set up three bridges: (a) a job submission bridge, (b) a job results bridge, and (c) a log output bridge. This works as follows (assuming ports 8901, 8902, and 8903 are available):

* (a) **Job submission:** Machine C is the sender and machine M is the receiver.  
On machine M, execute: `netcat-file-bridge/recv_migrate.sh .api/jobs.0/in/ 8901`  
On machine C, execute: `netcat-file-bridge/send_migrate.sh jobsubmission/ $HOSTNAME_M 8901`
* (b) **Job results retrieval:** Machine M is the sender and machine C is the receiver.  
On machine C, execute: `netcat-file-bridge/recv_migrate.sh jobresults/ 8902`  
On machine M, execute: `netcat-file-bridge/send_migrate.sh .api/jobs.0/out/ $HOSTNAME_C 8902`
* (c) **Log output:** Machine M is the sender and machine C is the receiver.  
On machine C, execute: `netcat-file-bridge/recv_track.sh logoutput/ 8903`  
On machine M, execute: `netcat-file-bridge/send_track.sh logs/ logdir-of-a-certain-run/ $HOSTNAME_C 8903`

You should now be able to send jobs to Mallob by dropping files into `jobsubmission/` on machine C. The script ignores files beginning with `~`; so to avoid an I/O race condition, you can write your file bit by bit with a name that begins with a `~` and then move / rename the file to something without `~`. Likewise, you should receive results in the directory `jobresults`. Last but not least, due to bridge (c), the following directory structure is created on machine C:
```
logoutput/
    logdir-of-a-certain-run/
        0/
        1/
        ...
```
