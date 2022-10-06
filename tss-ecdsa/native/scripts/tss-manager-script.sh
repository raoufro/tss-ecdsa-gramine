#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "Pass the IP address on which the TSS manager runs"
    exit 1
fi

MANAGER_IP="$1"

CMD="ROCKET_ADDRESS=${MANAGER_IP} gg20_sm_manager"

/bin/bash -c "${CMD}"