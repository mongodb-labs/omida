# OMiDa (OpsManager in Docker/arm64)

> **WARNING: THIS Dockerfile is HIGHLY EXPERIMENTAL**
> **IT IS NOT A PRODUCTION IMAGE.**
> **USE AT YOUR OWN RISK!**

## Notes / Warnings

- this image downloads JDK11/arm64 (aarch64), and the specified Ops Manager version
- as part of the startup process, it also runs a `mongo:5` container for the AppDB, exposed on port `27017`; this does not use authentication, aka **INSECURE**!
- the install process starts up Ops Manager during build time, and pregenerates `/etc.mongodb-mms/gen.key`, aka **INSECURE**!
- it is meant to use as a simple local repro of any given OM version; **it is NOT suited for PRODUCTION use!!!**
- this image **DOES NOT** start a Backup Daemon

## Prerequisites

- Docker

## Build the image

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
