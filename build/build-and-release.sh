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

"$DIR"/start-appdb.sh
APPDB_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' appdb)

echo "Using docker buildx to build all platforms..."
echo "If this step fails, try running 'docker buildx create --use' and then re-running the build step"
echo

docker buildx build \
    --platform linux/arm64/v8,linux/amd64 \
    --push \
    --build-arg VERSION="$2" \
    --build-arg PACKAGE="$3" \
    --build-arg APPDB_IP="$APPDB_IP" \
    --build-arg JDK_ARM64_BINARY="$JDK_ARM64_BINARY" \
    --tag "$1:$2" \
    --tag "$1:latest" \
    .
