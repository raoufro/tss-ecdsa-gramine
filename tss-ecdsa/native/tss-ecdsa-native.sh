#!/bin/bash

TSS_COORDINATOR_IPV4=10.5.0.2
TSS_COORDINATOR_PORT=8000

TOTAL_PLAYERS=5

echo "Extracting multi-party-ecdsa executable ..."
tar xzvf ../multi-party-ecdsa.tar.gz

echo "Initialize the structure of Logs, DKG, and TSS shares ..."
rm -rf ./logs/*
mkdir -p ./logs/{DKG,SIGN,shares}

echo "Build Images ..."
docker-compose build
docker-compose down

for (( num_player=3; num_player<=$TOTAL_PLAYERS; num_player++ )); do
    threshold=$((($num_player * 2) / 3))
    echo -e "\n\n\n"
    echo "*** Number of players = ${num_player}, Threshold = ${threshold} ***"

    echo "########## Remove logs and shared keys ##########"
    mkdir -p ./logs/shares/"${threshold}_${num_player}"

    echo "########## Start distributed key generation ##########"
    docker-compose run --detach tss-coordinator "/root/scripts/tss-manager-script.sh ${TSS_COORDINATOR_IPV4}"
    for (( i=1; i<=$num_player; i++)); do
        echo "Player${i} participates in DKG ..."
        if [ $i -eq 1 ]; then
            docker-compose run --detach tss-player${i} "/root/scripts/tss-player-keygen-timed.sh \
                ${TSS_COORDINATOR_IPV4} ${TSS_COORDINATOR_PORT} ${num_player} ${threshold} ${i}"
        else
            sleep 1 # To Keep the order of DKG
            docker-compose run --detach tss-player${i} "/root/scripts/tss-player-keygen.sh \
                ${TSS_COORDINATOR_IPV4} ${TSS_COORDINATOR_PORT} ${num_player} ${threshold} ${i}"
        fi
    done
    sleep 10

    echo "########## Stop All Services ##########"
    docker-compose down > /dev/null 2>&1

    list_of_players=""
    for (( i=1; i<$threshold; i++)); do
        list_of_players=${list_of_players}${i}","
    done
    list_of_players=${list_of_players}${threshold}

    echo "########## Start Multi-party ECDSA ##########"
    docker-compose run --detach tss-coordinator "/root/scripts/tss-manager-script.sh ${TSS_COORDINATOR_IPV4}"
    for (( i=1; i<=$threshold; i++)); do
        echo "Player${i} is signing the message ..."
        if [ $i -eq 1 ]; then
            docker-compose run --detach tss-player${i} "/root/scripts/tss-player-sign-timed.sh \
                ${TSS_COORDINATOR_IPV4} ${TSS_COORDINATOR_PORT} ${num_player} ${threshold} ${i} ${list_of_players}" > /dev/null 2>&1
        else
            sleep 1 #To keep the order of siging
            docker-compose run --detach tss-player${i} "/root/scripts/tss-player-sign.sh \
                ${TSS_COORDINATOR_IPV4} ${TSS_COORDINATOR_PORT} ${num_player} ${threshold} ${i} ${list_of_players}" > /dev/null 2>&1
        fi
    done
    sleep 10

    echo "########## Stop All Services ##########"
    docker-compose down > /dev/null 2>&1
    
    echo "########## Print the Signing Result ##########"
    for (( i=1; i<=$threshold; i++)); do
        echo "Player${i} signature is ..."
        cat ./logs/shares/"${threshold}_${num_player}"/signing${i}
    done
    sleep 10
done
