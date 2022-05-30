FROM ubuntu:20.04

USER root
WORKDIR /root
EXPOSE 9080/tcp

RUN apt-get update \
     && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        iproute2 \
        jq \
        netcat \
        net-tools \
        ssh \
        vim \
     && apt-get clean -y \
     && update-ca-certificates

# Specify Ops Manager version
ARG VERSION
RUN test -n "$VERSION" || (echo "Ops Manager VERSION must be set (e.g., '5.0.10')" && false)

# Specify AppDB IP
ARG APPDB_IP
RUN test -n "$APPDB_IP" || (echo "APPDB_IP must be set (e.g., '172.17.0.1')" && false)

# Copy the setup scripts
COPY scripts /root/scripts

# This step takes the longest out of the build process, since it downloads about ~1.5GB
# It is separated here to allow fast rebuilds if OM configuration needs to be changed.
ARG TARGETARCH
ARG JDK_ARM64_BINARY
RUN /root/scripts/download-om-tgz.sh --version "$VERSION"

# Configure Ops Manager (edit the script for any config changes, then run `make clean build`)
RUN    /root/scripts/configure-om.sh --appdb "$APPDB_IP"

# Startup command
CMD    /root/mongodb-mms/bin/start-mongodb-mms --enc-key-path /etc/mongodb-mms/gen.key \
    && tail -n 1000 -F /root/mongodb-mms/etc/mongodb-mms/data/logs/mms0-startup.log /root/mongodb-mms/etc/mongodb-mms/data/logs/mms0.log
