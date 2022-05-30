PACKAGE_NAME=mongodb/omida
VERSION=5.0.10
JDK_ARM64_BINARY=https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.15%2B10/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.15_10.tar.gz

default: build

.PHONY: clean
clean:
	@echo "Removing existing images..."
	-docker rmi -f $(PACKAGE_NAME):$(VERSION)
	-docker rm -f appdb
	@echo

.PHONY: build
export JDK_ARM64_BINARY
build:
	@echo "Building image..."
	@./build/build.sh $(PACKAGE_NAME) $(VERSION)
	@echo

.PHONY: run
run:
	@echo "Running image..."
	@./build/start.sh $(PACKAGE_NAME) $(VERSION)
	@echo

.PHONY: build
export JDK_ARM64_BINARY
build-all:
	@echo "Building images for all supported platforms (currently x64 and arm64/v8)..."
	@./build/build.sh $(PACKAGE_NAME) $(VERSION) all
	@echo
