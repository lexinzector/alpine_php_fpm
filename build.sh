#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")
BASE_PATH=$(dirname "$SCRIPT_PATH")

RETVAL=0
VERSION=7.4
SUBVERSION=12
IMAGE="alpine_php_fpm"
TAG=$(date '+%Y%m%d_%H%M%S')

REGISTRY="docker.io/lexinzector"

# Функция сборки и пуша конкретной архитектуры
build_and_push() {
    local PLATFORM=$1
    local ARCH=$2
    local FULL_TAG="$REGISTRY/$IMAGE:$VERSION-$SUBVERSION-$ARCH"

    echo "Building for $PLATFORM ($ARCH)..."
    docker buildx build --platform "$PLATFORM" -t "$FULL_TAG" --file Dockerfile . --push

    echo "Adding $ARCH to manifest..."
    docker buildx imagetools create --tag "$FULL_TAG" "$FULL_TAG"
}

# Функция создания окончательного манифеста
create_manifest() {
    echo "Creating and pushing multi-arch manifest..."
    docker buildx imagetools create \
        -t "$REGISTRY/$IMAGE:$VERSION-$SUBVERSION" \
        "$REGISTRY/$IMAGE:$VERSION-$SUBVERSION-amd64" \
        "$REGISTRY/$IMAGE:$VERSION-$SUBVERSION-arm64v8" \
        "$REGISTRY/$IMAGE:$VERSION-$SUBVERSION-arm32v7"

    docker buildx imagetools create \
        -t "$REGISTRY/$IMAGE:$VERSION" \
        "$REGISTRY/$IMAGE:$VERSION-$SUBVERSION-amd64" \
        "$REGISTRY/$IMAGE:$VERSION-$SUBVERSION-arm64v8" \
        "$REGISTRY/$IMAGE:$VERSION-$SUBVERSION-arm32v7"
}

case "$1" in

    test)
        docker buildx build --platform linux/amd64 \
            -t "$REGISTRY/$IMAGE:$VERSION-$SUBVERSION-$TAG" \
            --file Dockerfile .
    ;;

    amd64)
        build_and_push "linux/amd64" "amd64"
    ;;

    arm64v8)
        build_and_push "linux/arm64/v8" "arm64v8"
    ;;

    arm32v7)
        build_and_push "linux/arm/v7" "arm32v7"
    ;;

    all)
        $0 amd64
        $0 arm64v8
        $0 arm32v7
        create_manifest
    ;;

    *)
        echo "Usage: $0 {amd64|arm64v8|arm32v7|all|test}"
        RETVAL=1
    ;;

esac

exit $RETVAL
