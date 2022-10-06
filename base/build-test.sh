#!/bin/bash

docker-compose build gramine-base
docker-compose run gramine-base "/root/scripts/test-script.sh"
docker-compose down