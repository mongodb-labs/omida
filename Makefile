PACKAGE_NAME=mongodb/omida
MDB_VERSION=5
VERSION=6.0.0-rc4
# NOTE: Package takes precedence; if specified, IT WILL be used regardless of what VERSION is set to
PACKAGE=
JDK_ARM64_BINARY=https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.15%2B10/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.15_10.tar.gz

default: build

.PHONY: clean
clean:
	@echo "Removing existing images..."
	-docker rmi -f $(PACKAGE_NAME):$(VERSION)
	-docker rm -f appdb
	-docker rm -f ops-manager-$(VERSION)
	@echo

.PHONY: build
export JDK_ARM64_BINARY
build:
	@echo "Building image..."
	@./build/build.sh $(PACKAGE_NAME) $(VERSION) $(MDB_VERSION) $(PACKAGE)
	@echo

.PHONY: run
run:
	@echo "Running image..."
	@./build/start.sh $(PACKAGE_NAME) $(VERSION) $(MDB_VERSION)
	@echo

.PHONY: build-and-release
export JDK_ARM64_BINARY
build-and-release:
	@echo "Building images for all supported platforms (currently x64 and arm64/v8)..."
	@./build/build-and-release.sh $(PACKAGE_NAME) $(VERSION) $(PACKAGE)
	@echo
