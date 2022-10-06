# Description
This is a bunch of test scripts to setup/run multi-party ecdsa on Gramine.

## Requirements
- docker
- docker-compose
- SGX drivers and related packages

## How to run it

- To build the base container having gramine and required packages
```
cd base
./build-test.sh
```

- To build the container having executables of multi-party ECDSA
```
cd tss-ecdsa/native
./tss-ecdsa-native.sh
```
Note: You can change TOTAL_PLAYERS variable in the script up to 9 if you need.

- To run the container having gramine and multi-party ECDSA
```
cd tss-ecdsa/pure
./tss-ecdsa-pure.sh
```
Note: You can change TOTAL_PLAYERS variable in the script up to 9 if you need.
