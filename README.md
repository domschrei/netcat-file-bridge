
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

## Application

This tool was implemented for a specific application - please see the README under `mallob/`.
