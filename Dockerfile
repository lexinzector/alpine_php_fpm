ARG ARCH=
FROM bayrell/alpine_php_fpm:7.4.10${ARCH}

ARG APT_MIRROR

RUN cd ~; \
	apk update; \
	apt upgrade; \
	apk add php7-tokenizer; \
	echo 'Ok'
