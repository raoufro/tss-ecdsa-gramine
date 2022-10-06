#!/bin/bash

if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    echo "Pass the Manager IP, Port#, Total Number of Players, Threshold, and Index of current player"
    exit 1
fi

MANAGER_IP="$1"
MANAGER_PORT="$2"
TOTAL_PLAYER_NUM="$3"
THRESHOLD="$4"
CUR_PLAYER_NUM="$5"

CMD="gg20_keygen -t $(($THRESHOLD-1)) -n ${TOTAL_PLAYER_NUM} -i ${CUR_PLAYER_NUM} --address http://${MANAGER_IP}:${MANAGER_PORT}/ \
    --output /logs/shares/${THRESHOLD}_${TOTAL_PLAYER_NUM}/share${CUR_PLAYER_NUM}.json \
    2> /logs/DKG/DKG_${TOTAL_PLAYER_NUM}_${CUR_PLAYER_NUM}_error.log"

date +%s.%N > /logs/DKG/DKG_${TOTAL_PLAYER_NUM}
/bin/bash -c "${CMD}"
date +%s.%N >> /logs/DKG/DKG_${TOTAL_PLAYER_NUM}
