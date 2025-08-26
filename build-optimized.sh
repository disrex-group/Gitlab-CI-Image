#!/bin/bash

# Build script for optimized GitLab CI Docker images
# Usage: ./build-optimized.sh [PHP_VERSION] [NODE_VERSION]

set -e

# Default values
DEFAULT_PHP_VERSION="8.4"
DEFAULT_NODE_VERSION="18"
REGISTRY="disrex/gitlab-ci"

# Use provided arguments or defaults
PHP_VERSION="${1:-$DEFAULT_PHP_VERSION}"
NODE_VERSION="${2:-$DEFAULT_NODE_VERSION}"

# Determine OS release based on PHP version
get_os_release() {
    case "$1" in
        7.1|7.2)
            echo "buster"
            ;;
        7.3|7.4|8.0)
            echo "bullseye"
            ;;
        *)
            echo "bookworm"
            ;;
    esac
}

OS_RELEASE=$(get_os_release "$PHP_VERSION")

echo "Building image with:"
echo "  PHP Version: $PHP_VERSION"
echo "  Node Version: $NODE_VERSION"
echo "  OS Release: $OS_RELEASE"
echo ""

# Build base PHP image (cached across Node.js versions)
BASE_TAG="${REGISTRY}:${PHP_VERSION}-base"
echo "Building base PHP image: $BASE_TAG"
docker build \
    --target php-base \
    --build-arg PHP_VERSION="$PHP_VERSION" \
    --build-arg OS_RELEASE="$OS_RELEASE" \
    --cache-from "$BASE_TAG" \
    -t "$BASE_TAG" \
    -f Dockerfile.optimized \
    .

# Build final image with Node.js
if [ "$NODE_VERSION" = "none" ]; then
    FINAL_TAG="${REGISTRY}:${PHP_VERSION}"
else
    FINAL_TAG="${REGISTRY}:${PHP_VERSION}-node${NODE_VERSION}"
fi

echo "Building final image: $FINAL_TAG"
docker build \
    --build-arg PHP_VERSION="$PHP_VERSION" \
    --build-arg OS_RELEASE="$OS_RELEASE" \
    --build-arg NODE_VERSION="$NODE_VERSION" \
    --cache-from "$BASE_TAG" \
    --cache-from "$FINAL_TAG" \
    -t "$FINAL_TAG" \
    -f Dockerfile.optimized \
    .

echo ""
echo "Build complete!"
echo "Tagged as: $FINAL_TAG"
echo ""
echo "To push to registry:"
echo "  docker push $FINAL_TAG"
echo ""
echo "To switch Node.js versions inside container:"
echo "  docker run -it $FINAL_TAG switch-node <version>"