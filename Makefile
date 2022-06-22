PACKAGE_NAME=mongodb/omida
MDB_VERSION=5
VERSION=5.0.10
# NOTE: Package takes precedence; if specified, IT WILL be used regardless of what VERSION is set to
#       However, VERSION does dictate the resulting Docker image's tag name
PACKAGE=
JDK_ARM64_BINARY=https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.15%2B10/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.15_10.tar.gz

default: build

.PHONY: clean
clean:
	@echo "Removing existing images..."
	-docker rmi -f "$(PACKAGE_NAME):$(VERSION)"
	-docker rm -f appdb
	-docker rm -f "ops-manager-$(VERSION)"
	@echo

.PHONY: build
export JDK_ARM64_BINARY
build:
	@echo "Building image..."
	@./build/build.sh --tag "$(PACKAGE_NAME)" --version "$(VERSION)" --mdb-version "$(MDB_VERSION)" --package "$(PACKAGE)"
	@echo

.PHONY: run
run:
	@echo "Running image..."
	@./build/start.sh --tag "$(PACKAGE_NAME)" --version "$(VERSION)" --mdb-version "$(MDB_VERSION)"
	@echo

.PHONY: build-all
export JDK_ARM64_BINARY
build-all:
	@echo "Building images for all supported platforms (currently x64 and arm64/v8)..."
	@./build/build-all.sh --tag "$(PACKAGE_NAME)" --version "$(VERSION)" --mdb-version "$(MDB_VERSION)" --package "$(PACKAGE)"
	@echo
