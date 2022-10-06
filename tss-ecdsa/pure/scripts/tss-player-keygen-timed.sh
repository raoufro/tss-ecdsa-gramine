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

ARCH_LIBDIR=/lib/$(gcc -dumpmachine)
GRAMINE_LOG_LEVEL="debug"
SGX_DEBUG="false"

gramine_sgx_setup() {
    gramine-sgx-gen-private-key /root/gramine-config/enclave-key.pem
    
    gramine-manifest \
		-Dlog_level=${GRAMINE_LOG_LEVEL} \
		-Dexecdir=$(dirname $(which bash)) \
		-Darch_libdir=${ARCH_LIBDIR} \
        -Dsgx_debug=${SGX_DEBUG} \
		/root/gramine-config/manifest.template /root/gramine-config/gg20_keygen.manifest

    gramine-sgx-sign \
        --key /root/gramine-config/enclave-key.pem \
		--manifest /root/gramine-config/gg20_keygen.manifest \
		--output /root/gramine-config/gg20_keygen.manifest.sgx

    gramine-sgx-get-token --output /root/gramine-config/gg20_keygen.token --sig /root/gramine-config/gg20_keygen.sig
}

gramine_sgx_setup || exit 1

date +%s.%N > /logs/DKG/DKG_${TOTAL_PLAYER_NUM}
gramine-sgx /root/gramine-config/gg20_keygen -c "${CMD}"
date +%s.%N >> /logs/DKG/DKG_${TOTAL_PLAYER_NUM}