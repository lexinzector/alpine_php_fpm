#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0
VERSION=8.3
SUBVERSION=2
IMAGE="alpine_php_fpm"
TAG=`date '+%Y%m%d_%H%M%S'`

case "$1" in
	
	test)
		docker build ./ -t lexinzector/$IMAGE:$VERSION-$SUBVERSION-$TAG \
			--file Dockerfile
	;;
	
	amd64)
		export DOCKER_DEFAULT_PLATFORM=linux/amd64
		docker build ./ -t lexinzector/$IMAGE:$VERSION-$SUBVERSION-amd64 \
			--file Dockerfile --build-arg ARCH=amd64/
	;;
	
	arm64v8)
		export DOCKER_DEFAULT_PLATFORM=linux/arm64/v8
		docker build ./ -t lexinzector/$IMAGE:$VERSION-$SUBVERSION-arm64v8 \
			--file Dockerfile --build-arg ARCH=arm64v8/
	;;
	
	arm32v7)
		export DOCKER_DEFAULT_PLATFORM=linux/arm/v7
		docker build ./ -t lexinzector/$IMAGE:$VERSION-$SUBVERSION-arm32v7 \
			--file Dockerfile --build-arg ARCH=arm32v7/
	;;
	
	manifest)
		rm -rf ~/.docker/manifests/docker.io_lexinzector_$IMAGE_NAME-*
		
		docker tag lexinzector/$IMAGE:$VERSION-$SUBVERSION-amd64 lexinzector/$IMAGE:$VERSION-amd64
		docker tag lexinzector/$IMAGE:$VERSION-$SUBVERSION-arm64v8 lexinzector/$IMAGE:$VERSION-arm64v8
		docker tag lexinzector/$IMAGE:$VERSION-$SUBVERSION-arm32v7 lexinzector/$IMAGE:$VERSION-arm32v7
		
		docker push lexinzector/$IMAGE:$VERSION-$SUBVERSION-amd64
		docker push lexinzector/$IMAGE:$VERSION-$SUBVERSION-arm64v8
		docker push lexinzector/$IMAGE:$VERSION-$SUBVERSION-arm32v7
		
		docker push lexinzector/$IMAGE:$VERSION-amd64
		docker push lexinzector/$IMAGE:$VERSION-arm64v8
		docker push lexinzector/$IMAGE:$VERSION-arm32v7
		
		docker manifest create lexinzector/$IMAGE:$VERSION-$SUBVERSION \
			--amend lexinzector/$IMAGE:$VERSION-$SUBVERSION-amd64 \
			--amend lexinzector/$IMAGE:$VERSION-$SUBVERSION-arm64v8 \
			--amend lexinzector/$IMAGE:$VERSION-$SUBVERSION-arm32v7
		docker manifest push lexinzector/$IMAGE:$VERSION-$SUBVERSION
		
		docker manifest create lexinzector/$IMAGE:$VERSION \
			--amend lexinzector/$IMAGE:$VERSION-amd64 \
			--amend lexinzector/$IMAGE:$VERSION-arm64v8 \
			--amend lexinzector/$IMAGE:$VERSION-arm32v7
		docker manifest push lexinzector/$IMAGE:$VERSION
	;;
	
	all)
		$0 amd64
		$0 arm64v8
		$0 arm32v7
		$0 manifest
	;;
	
	*)
		echo "Usage: $0 {amd64|arm64v8|arm32v7|manifest|all|test}"
		RETVAL=1

esac

exit $RETVAL

