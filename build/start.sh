#!/usr/bin/env bash
set -ueo pipefail

if [[ "$#" -lt 2 ]]; then
    echo "A Docker image and Ops Manager version were not specified!"
    echo "Usage: ./start.sh mongodb/omida x.y.z"
    echo "   or: ./start.sh mongodb/omida latest"
    echo
    exit 1
fi

echo
echo "Starting a container for the AppDB"
if ! docker start appdb; then
    echo "Could not start the previous container; deleting and starting from scratch..."
    docker rm -f appdb
    docker run --net=bridge --name appdb -p 27017:27017 -d mongo:5
fi

APPDB_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' appdb)
echo "AppDB runnning at ${APPDB_IP}"
echo

echo "Starting Ops Manager $2"
docker run \
    --env VERSION="$2" \
    --env APPDB_IP="$APPDB_IP" \
    --net=bridge \
    -p 9080:9080/tcp \
    -it "$1:$2"
