#!/bin/bash

if [ "$#" -ne 6 ]; then
    echo "Illegal number of parameters"
    echo "Pass the Manager IP, Port#, Total Number of Players, Threshold, Index of current player, and List of players signing the message"
    exit 1
fi

MANAGER_IP="$1"
MANAGER_PORT="$2"
TOTAL_PLAYER_NUM="$3"
THRESHOLD="$4"
CUR_PLAYER_NUM="$5"
LIST_OF_PLAYERS="$6"

CMD="gg20_signing -p ${LIST_OF_PLAYERS} -d \"Hello World!\" --address http://${MANAGER_IP}:${MANAGER_PORT} \
    -l /logs/shares/${THRESHOLD}_${TOTAL_PLAYER_NUM}/share${CUR_PLAYER_NUM}.json \
    > /logs/shares/${THRESHOLD}_${TOTAL_PLAYER_NUM}/signing${CUR_PLAYER_NUM} \
    2> /logs/SIGN/signing_${TOTAL_PLAYER_NUM}_${THRESHOLD}_${CUR_PLAYER_NUM}_error.log"

date +%s.%N > /logs/SIGN/SIGN_${TOTAL_PLAYER_NUM}_${THRESHOLD} 
/bin/bash -c "${CMD}"
date +%s.%N >> /logs/SIGN/SIGN_${TOTAL_PLAYER_NUM}_${THRESHOLD}