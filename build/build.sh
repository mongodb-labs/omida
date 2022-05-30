#!/usr/bin/env bash
set -ueo pipefail

if [[ "$#" -lt 2 ]]; then
    echo "A Docker image and Ops Manager version were not specified!"
    echo "Usage: build.sh mongodb/omid x.y.z"
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

if [[ -n "${3+x}" ]]; then
    echo "Using docker buildx to build all platforms..."
    echo "If this step fails, try running 'docker buildx create --use' and then re-running the build step"
    echo

    docker buildx build \
        --platform linux/arm64/v8,linux/amd64 \
        --build-arg VERSION="$2" \
        --build-arg APPDB_IP="$APPDB_IP" \
        --build-arg JDK_ARM64_BINARY="$JDK_ARM64_BINARY" \
        --tag "$1:$2" \
        --tag "$1:latest" \
        .
else
    echo "Building the container for the local target architecture..."
    echo
    docker build \
        --build-arg VERSION="$2" \
        --build-arg APPDB_IP="$APPDB_IP" \
        --build-arg JDK_ARM64_BINARY="$JDK_ARM64_BINARY" \
        --tag "$1:$2" \
        --tag "$1:latest" \
        .
fi
