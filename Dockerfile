ARG ARCH=
FROM bayrell/alpine_php_fpm:7.4-10${ARCH}

ARG APT_MIRROR

RUN cd ~; \
	apk update; \
	apt upgrade; \
	apk add php7-tokenizer; \
	echo 'Ok'

RUN cd ~; \
	apk --no-cache add \
	autoconf \
	build-base \
	geoip \
	geoip-dev; \
	echo 'Ok'

RUN cd ~; \
	mkdir -p /usr/share/GeoIP && cd /usr/share/GeoIP/; \
	wget https://dl.miyuru.lk/geoip/maxmind/city/maxmind.dat.gz -O GeoLiteCity.dat.gz; \
	gzip -d GeoLiteCity.dat.gz; \
	mv maxmind.dat GeoLiteCity.dat; \
	wget https://dl.miyuru.lk/geoip/maxmind/country/maxmind.dat.gz -O GeoIP.dat.gz; \
	gzip -d GeoIP.dat.gz; \
	mv maxmind.dat GeoIP.dat; \
	echo 'Ok'

RUN cd ~; \
	pecl install geoip-1.1.1; \
	echo 'Ok'

RUN cd ~; \
	docker-php-ext-enable geoip; \
	echo 'Ok'
