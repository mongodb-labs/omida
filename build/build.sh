#!/usr/bin/env bash
set -ueo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DIR

if [[ "$#" -lt 2 ]]; then
    echo "A Docker image and Ops Manager version were not specified!"
    echo "Usage: build.sh mongodb/omid x.y.z"
    echo
    exit 1
fi

"$DIR"/start-appdb.sh "$3"
APPDB_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' appdb)

echo "Building the container for the local target architecture..."
echo
docker build \
    --build-arg VERSION="$2" \
    --build-arg PACKAGE="$4" \
    --build-arg APPDB_IP="$APPDB_IP" \
    --build-arg JDK_ARM64_BINARY="$JDK_ARM64_BINARY" \
    --tag "$1:$2" \
    --tag "$1:latest" \
    .
