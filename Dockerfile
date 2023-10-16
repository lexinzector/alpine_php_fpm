ARG ARCH=
FROM bayrell/alpine_php_fpm:8.0-2${ARCH}

ARG APT_MIRROR

RUN cd ~; \
	apk update; \
	apt upgrade; \
	apk add php8-tokenizer; \
	echo 'Ok'
