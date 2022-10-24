#!/bin/bash
# This script must be executed from the base directory of the netcat-file-bridge repository.
# It opens an SSH shell which forwards a number of required ports from a local host
# over an intermediate machine to an internal machine.

source mallob/config.sh client
source credentials.sh

port_webinterface=12346
port_api=12347

# This is a quadruple port forwarding over two hops,
# from localhost to i10login and then to i10pc138.
ssh -tt -A \
-L ${port_jobdescriptions}:localhost:${port_jobdescriptions} \
-L ${port_jobsubmission}:localhost:${port_jobsubmission} \
-L ${port_jobresults}:localhost:${port_jobresults} \
-L ${port_logoutput}:localhost:${port_logoutput} \
-L ${port_webinterface}:localhost:${port_webinterface} \
-L ${port_api}:localhost:${port_api} \
${user}@${loginnode} \
ssh -tt -A \
-L ${port_jobdescriptions}:localhost:${port_jobdescriptions} \
-L ${port_jobsubmission}:localhost:${port_jobsubmission} \
-L ${port_jobresults}:localhost:${port_jobresults} \
-L ${port_logoutput}:localhost:${port_logoutput} \
${destination}

# While the resulting shell is open, the four configured ports
# should be usable. Try:
# (@ i10pc138)  nc -l -p ${port_jobsubmission}
# (@ localhost) cat | nc localhost ${port_jobsubmission}

# Note that while the bridges are running, there will be periodic error output
# in this shell (because unsuccessful connection attempt are made). This is not an error.
# However, due to this annoying output you should open a different SSH shell for interactive commands
# and just leave this one open as long as necessary without interacting with it.
# In the end, press Ctrl+C in this shell after all bridges have terminated and you can
# logout normally by typing "exit".
