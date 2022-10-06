FROM roraouf/gramine-base

# Copy multi-party-ecdsa in /usr/local/bin
COPY multi-party-ecdsa/gg20_keygen /usr/local/bin/gg20_keygen
COPY multi-party-ecdsa/gg20_sm_manager /usr/local/bin/gg20_sm_manager
COPY multi-party-ecdsa/gg20_sm_client /usr/local/bin/gg20_sm_client
COPY multi-party-ecdsa/gg20_signing /usr/local/bin/gg20_signing

RUN apt-get update \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash","-l","-c"]