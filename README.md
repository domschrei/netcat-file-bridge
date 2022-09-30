
# netcat-file-bridge

This tool allows to mirror certain files from one machine to another, using the Unix utility `netcat`.

## Use Cases

There are two use cases for this tool:

* **Migrate**: From time to time, some application on machine A writes a text file to a certain directory. This tool reads each such file, deletes it, and then sends it to a certain target directory on machine B.
* **Track**: There is a number of (existing) text files within a certain directory on machine A, possibly organized as a hierarchical structure with some levels of subdirectories. Each of the files may be appended to at any time. This tool tracks the output to each file and mirrors it to an analogous directory structure within a certain directory on machine B.

## Toolbox

The tool consists of the following four scripts:

* `send_migrate.sh`: The **sender-side** script for **migrating files**. Arguments: (1) the local directory (relative to the calling path) which should be watched, (2) the port to use, and optionally (3) the destination hostname at which to join a connection. If (3) is not provided, the sender opens a connection itself and the receiver needs to join it.
* `recv_migrate.sh`: The **receiver-side** script for **migrating files**. Arguments: (1) the destination directory to write incoming files to, (2) the port to use, and optionally (3) the destination hostname at which to join a connection. If (3) is not provided, the receiver opens a connection itself and the sender needs to join it.
* `send_track.sh`: The **sender-side** script for **tracking files**. Arguments: (1) the local directory (relative to the calling path) which contains the directory to listen to, (2) the subdirectory within the directory from (1) which contains the files to be followed, (3) the port to use, and optionally (4) the destination machine. If (4) is not provided, the sender opens a connection itself and the receiver needs to join it.
* `recv_track.sh`: The **receiver-side** script for **tracking files**. Arguments: (1) the destination directory in which the tracked directory structure should be mirrored, (2) the port at which to listen, and optionally (3) the destination machine. If (3) is not provided, the receiver opens a connection itself and the sender needs to join it.

To reiterate: If you want run a matching pair of `send_*.sh` and `recv_*.sh` on two ends, then you need to give exactly one of them the hostname of the other while omitting the hostname in the other script.

## Application

This tool was implemented for a specific application - please see the README under `mallob/`.
