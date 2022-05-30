# OMiDa (OpsManager in Docker/arm64)

> **WARNING: THIS DOCKER IMAGE IS NOT FOR PRODUCTION USAGE !!!**
> <br/>**USE AT YOUR OWN RISK!**

## Introduction

- This project is meant to help users try out particular Ops Manager versions (configurable in the [Makefile](./Makefile)); **it is NOT suited for PRODUCTION use!!!**
- When targeting _arm64_ (aarch64), the build process replaces the original x64 JDK11
- You may need to update the JDK link for newer OM versions
- Ops Manager needs a running MongoDB to serve as an AppDB; the `build` and `run` phases will start a `mongo:5` container, exposed to the host on port `38017`; this does not use authentication, a.k.a. it is **INSECURE**!
- During build, Ops Manager is started, which pregenerates `/etc/mongodb-mms/gen.key`, a.k.a. it is **INSECURE**!
- This image **DOES NOT** start a Backup Daemon
- This is image is targeted at _arm64_ but also builds and runs on the `x86_64` architecture.
- **DO NOT USE in PRODUCTION !!!**

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (tested on `4.8.2 (79419)`)

## Building the image

```shell
# Checkout this repo and build the image
git clone git@github.com:mongodb-labs/omida.git
cd omida
make clean build

# Start the AppDB and Ops Manager
make run

# Wait for the Ops Manager service to start at http://localhost:9080/
# Enjoy!
```

## Build-time benchmarks

- tests were performed locally, over WiFi
- these timings are mostly informative, are are not to be seen as guarantees!

### x86_64 (Apple 2.4 GHz 8-Core Intel Core i9, 2019)
- `make clean build`: 1:36m
- `make run` (cold start): 3:44m
- `make run`: 1:46m

### arm64 (Apple M1 Max, 2021)
- `make clean build`: 0:45m
- `make run` (cold start): 2:50m
- `make run`: 1:20m

## Building a different Ops Manager version

- edit the [Makefile](./Makefile)
- set `VERSION=[your desired version]`
- if building on `arm64`, you might also need to update `JDK_ARM64_BINARY`
- Rebuild the image `docker clean build`

# Troubleshooting

## AppDB does not start

Occasionally, you may run out of space, especially if you `make clean build` all the time.
In that case, run `make clean && docker volume prune` to clean up space.

Additionally, try deleting the MongoDB docker image (`docker rmi mongo:5`), which will fail but identify
previously started containers, associated with this image.
