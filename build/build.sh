#!/usr/bin/env bash
set -ueo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DIR

tag=
version=
mdb_version=
package=
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --tag) tag="${2-}"; shift 2 ;;
        --version) version="${2-}"; shift 2 ;;
        --mdb-version) mdb_version="${2-}"; shift 2 ;;
        --package) package="${2-}"; shift 2 ;;
        * ) echo "Invalid configuration option: '$1'"; return 1 ;;
    esac
done

if [[ -z "$tag" ]]; then
    echo "You must specify a tag!"
    echo "Usage: build.sh --tag mongodb/omid x.y.z"
    echo
    exit 1
fi
if [[ -z "$version" ]]; then
    echo "You must specify a version!"
    echo "Usage: build.sh --version x.y.z"
    echo
    exit 1
fi
if [[ -z "$mdb_version" ]]; then
    echo "You must specify a MongoDB version to use!"
    echo "Usage: build.sh --mdb_version 5"
    echo
    exit 1
fi

"$DIR"/start-appdb.sh --mdb-version "$mdb_version"
APPDB_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' appdb)

echo "Building the container for the local target architecture..."
echo
docker build \
    --build-arg VERSION="$version" \
    --build-arg PACKAGE="$package" \
    --build-arg APPDB_IP="$APPDB_IP" \
    --build-arg JDK_ARM64_BINARY="$JDK_ARM64_BINARY" \
    --tag "$tag:$version" \
    --tag "$tag:latest" \
    .
