#!/usr/bin/env bash
set -ueo pipefail

mdb_version=
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --mdb-version) mdb_version="${2-}"; shift 2 ;;
        * ) echo "Invalid configuration option: '$1'"; exit 1 ;;
    esac
done

if [[ -z "$mdb_version" ]]; then
    echo "You must specify a MongoDB version to use!"
    echo "Usage: start-appdb.sh --mdb-version 5"
    echo
    exit 1
fi

echo
echo "Starting a container for the AppDB (mongo:$mdb_version)..."
if ! docker start appdb; then
    echo "Did not find a previously running container, or could not restart it."
    echo "Starting AppDB from scratch..."
    docker run --net=bridge --name appdb -p 27017:37017/tcp -d mongo:"$mdb_version"
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
