#!/usr/bin/env bash
set -ueo pipefail

if [[ "$#" -lt 1 ]]; then
    echo "You must specify a MongoDB version as the first parameter!"
    echo "Usage: ./start-appdb.sh 5"
    echo
    exit 1
fi

echo
echo "Starting a container for the AppDB (mongo:$1)..."
if ! docker start appdb; then
    echo "Did not find a previously running container, or could not restart it."
    echo "Starting AppDB from scratch..."
    docker run --net=bridge --name appdb -p 27017:37017/tcp -d mongo:"$1"
fi

APPDB_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' appdb)

if [[ -z "$APPDB_IP" ]]; then
    echo
    echo "The AppDB is not running, cannot proceed..."
    echo
    exit 1
else
    echo "The AppDB is running at ${APPDB_IP}"
    echo
fi
