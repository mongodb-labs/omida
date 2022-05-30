#!/usr/bin/env bash
set -ueo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DIR

if [[ "$#" -lt 2 ]]; then
    echo "A Docker image and Ops Manager version were not specified!"
    echo "Usage: ./start.sh mongodb/omida x.y.z"
    echo "   or: ./start.sh mongodb/omida latest"
    echo
    exit 1
fi

"$DIR"/start-appdb.sh
APPDB_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' appdb)

echo "Starting Ops Manager $2"
docker run \
    --env VERSION="$2" \
    --env APPDB_IP="$APPDB_IP" \
    --net=bridge \
    -p 9080:9080/tcp \
    -it "$1:$2"
