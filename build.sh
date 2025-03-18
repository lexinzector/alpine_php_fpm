#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")
BASE_PATH=$(dirname "$SCRIPT_PATH")

RETVAL=0
VERSION=5.6
SUBVERSION=3
IMAGE_NAME="alpine_php_fpm"
TAG=$(date '+%Y%m%d_%H%M%S')
REGISTRY="docker.io/lexinzector"

build_and_push() {
    local PLATFORM=$1
    local ARCH=$2
    local ARCH_ARG=""

    # ARCH для Alpine (amd64 не требует префикса)
    if [[ "$ARCH" == "arm64v8" || "$ARCH" == "arm32v6" ]]; then
        ARCH_ARG="${ARCH}/"
    fi

    local FULL_TAG="$REGISTRY/$IMAGE_NAME:$VERSION-$SUBVERSION-$ARCH"

    echo "Building for $PLATFORM ($ARCH)..."
    docker buildx build --platform "$PLATFORM" -t "$FULL_TAG" --file Dockerfile . --build-arg ARCH="$ARCH_ARG" --push
}

create_manifest() {
    echo "Creating and pushing multi-arch manifest..."
    docker buildx imagetools create -t "$REGISTRY/$IMAGE_NAME:$VERSION-$SUBVERSION" \
        "$REGISTRY/$IMAGE_NAME:$VERSION-$SUBVERSION-amd64" \
        "$REGISTRY/$IMAGE_NAME:$VERSION-$SUBVERSION-arm64v8" \
        "$REGISTRY/$IMAGE_NAME:$VERSION-$SUBVERSION-arm32v6"

    docker buildx imagetools create -t "$REGISTRY/$IMAGE_NAME:$VERSION" \
        "$REGISTRY/$IMAGE_NAME:$VERSION-$SUBVERSION-amd64" \
        "$REGISTRY/$IMAGE_NAME:$VERSION-$SUBVERSION-arm64v8" \
        "$REGISTRY/$IMAGE_NAME:$VERSION-$SUBVERSION-arm32v6"
}

case "$1" in

    test)
        docker buildx build --platform linux/amd64 \
            -t "$REGISTRY/$IMAGE_NAME:$VERSION-$SUBVERSION-$TAG" \
            --file Dockerfile .
    ;;

    amd64)
        build_and_push "linux/amd64" "amd64"
    ;;

    arm64v8)
        build_and_push "linux/arm64/v8" "arm64v8"
    ;;

    arm32v6)
        build_and_push "linux/arm/v6" "arm32v6"
    ;;

    manifest)
        create_manifest
    ;;

    all)
        $0 amd64
        $0 arm64v8
        $0 arm32v6
        $0 manifest
    ;;

    *)
        echo "Usage: $0 {amd64|arm64v8|arm32v6|manifest|all|test}"
        RETVAL=1
    ;;

esac

exit $RETVAL
