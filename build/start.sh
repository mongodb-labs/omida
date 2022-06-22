#!/usr/bin/env bash
set -ueo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DIR

tag=
version=
mdb_version=
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --tag) tag="${2-}"; shift 2 ;;
        --version) version="${2-}"; shift 2 ;;
        --mdb-version) mdb_version="${2-}"; shift 2 ;;
        * ) echo "Invalid configuration option: '$1'"; return 1 ;;
    esac
done

if [[ -z "$tag" ]]; then
    echo "You must specify a tag!"
    echo "Usage: start.sh --tag mongodb/omid x.y.z"
    echo
    exit 1
fi
if [[ -z "$version" ]]; then
    echo "You must specify a version!"
    echo "Usage: start.sh --version x.y.z"
    echo
    exit 1
fi
if [[ -z "$mdb_version" ]]; then
    echo "You must specify a MongoDB version to use!"
    echo "Usage: start.sh --mdb_version 5"
    echo
    exit 1
fi

"$DIR"/start-appdb.sh "$mdb_version"
APPDB_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' appdb)

echo "Starting Ops Manager $version"
docker rm -f "ops-manager-$version"
docker run \
    --name ops-manager-"$version" \
    --env VERSION="$version" \
    --env APPDB_IP="$APPDB_IP" \
    --net=bridge \
    -p 9080:9080/tcp \
    -it "$tag:$version"
