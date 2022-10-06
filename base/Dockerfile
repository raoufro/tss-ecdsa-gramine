FROM ubuntu:20.04

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                # Core Utils
                coreutils \
                git \
                wget \
                build-essential \
                libssl-dev \
                libprotobuf-dev \
                autoconf \
                libtool \
                ca-certificates \
                automake \
                curl \
                gnupg\
                # Convinience
                vim \
                less \
                # Networking
                libuv1-dev \
                iproute2 \
                inetutils-ping \
                net-tools \
                uml-utilities \
                socat \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

RUN curl -fsSLo /usr/share/keyrings/gramine-keyring.gpg https://packages.gramineproject.io/gramine-keyring.gpg \
        && echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/gramine-keyring.gpg] https://packages.gramineproject.io/ focal main' | tee /etc/apt/sources.list.d/gramine.list

RUN curl -fsSL https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | apt-key add - \
        && echo 'deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu focal main' | tee /etc/apt/sources.list.d/intel-sgx.list

# Install Gramine Executables
RUN apt-get update \
        && apt-get install -y --no-install-recommends gramine \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
