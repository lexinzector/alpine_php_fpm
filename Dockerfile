ARG ARCH=
FROM bayrell/alpine_php_fpm:8.3-1${ARCH}

ARG APT_MIRROR

RUN cd ~; \
	apk update; \
	apt upgrade; \
	apk add php8-tokenizer; \
	echo 'Ok'

RUN echo "* * * * * cd /var/www/html/api && php artisan schedule:run >> /dev/null 2>&1" >> /etc/crontabs/root
