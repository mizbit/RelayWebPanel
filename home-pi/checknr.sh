#!/bin/bash

# Check if gedit is running
# -x flag only match processes whose name (or command line if -f is
# specified) exactly match the pattern. 

if pgrep -x "nrservice" > /dev/null
then
    echo "Running"
else
    nrclientcmd -d benteveo -u admin -p bichofeo &>/dev/null
#    echo "Stopped"
fi
