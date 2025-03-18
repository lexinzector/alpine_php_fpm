ARG ARCH=
FROM ${ARCH}alpine:3.14

RUN cd ~; \
	apk update --no-cache; \
	apk upgrade --no-cache; \
	apk add --no-cache bash nano mc wget net-tools pv zip unzip supervisor procps grep sudo; \
	rm -rf /var/cache/apk/*; \
	echo "export EDITOR=nano" > /etc/profile.d/editor_nano; \
	echo "Ok"

RUN cd ~; \
	apk add --no-cache php7 php7-fpm php7-intl php7-openssl php7-dba php7-sqlite3 php7-pear php7-tokenizer php7-phpdbg php7-pecl-imagick-dev php7-pecl-protobuf php7-litespeed php7-gmp php7-phalcon php7-pecl-maxminddb php7-pdo_mysql php7-sodium php7-pcntl php7-common php7-pecl-oauth php7-xsl php7-pecl-mailparse php7-pecl-gmagick php7-pecl-imagick php7-mysqlnd php7-enchant php7-pecl-uuid php7-pspell php7-pecl-ast php7-pecl-redis php7-snmp php7-doc php7-tideways_xhprof php7-pecl-uploadprogress-doc php7-fileinfo php7-mbstring php7-pecl-lzf php7-pecl-amqp php7-pecl-yaml php7-pecl-memcache php7-pecl-timezonedb php7-dev php7-pecl-psr php7-xmlrpc php7-embed php7-xmlreader php7-pdo_sqlite php7-exif php7-pecl-msgpack php7-opcache php7-ldap php7-posix php7-session php7-gd php7-pecl-xdebug php7-pecl-mongodb php7-gettext php7-pecl-couchbase php7-json php7-xml php7-iconv php7-sysvshm php7-curl php7-shmop php7-odbc php7-pecl-uploadprogress php7-phar php7-pdo_pgsql php7-imap php7-pecl-apcu php7-pdo_dblib php7-pgsql php7-pdo_odbc php7-pecl-igbinary php7-pecl-xhprof php7-zip php7-cgi php7-ctype php7-pecl-mcrypt php7-bcmath php7-calendar php7-tidy php7-dom php7-sockets php7-pecl-zmq php7-pecl-event php7-pecl-vips php7-pecl-memcached php7-brotli php7-dbg php7-soap php7-sysvmsg php7-pecl-ssh2 php7-ffi php7-ftp php7-sysvsem php7-pdo php7-static php7-bz2 php7-mysqli php7-pecl-xhprof-assets php7-simplexml php7-xmlwriter curl nginx mysql-client; \
	rm -rf /var/cache/apk/*; \
	addgroup -g 1000 -S www; \
	adduser -D -H -S -G www -u 1000 www; \
	adduser nginx www; \
	chown -R www:www /var/log/nginx; \
	rm -rf /var/cache/apk/*; \
	echo 'Ok'
	
RUN cd ~; \
	sed -i 's|;date.timezone =.*|date.timezone = UTC|g' /etc/php7/php.ini; \
	sed -i 's|short_open_tag =.*|short_open_tag = On|g' /etc/php7/php.ini; \
	sed -i 's|display_errors =.*|display_errors = On|g' /etc/php7/php.ini; \
	sed -i 's|error_reporting =.*|display_errors = E_ALL|g' /etc/php7/php.ini; \
	sed -i 's|;error_log =.*|error_log = /var/log/php7/error.log|g' /etc/php7/php.ini; \
	sed -i 's|listen =.*|listen = /var/run/php-fpm.sock|g' /etc/php7/php-fpm.d/www.conf; \
	sed -i 's|;listen.owner =.*|listen.owner = www|g' /etc/php7/php-fpm.d/www.conf; \
	sed -i 's|;listen.group =.*|listen.group = www|g' /etc/php7/php-fpm.d/www.conf; \
	sed -i 's|;listen.mode =.*|listen.mode = 0660|g' /etc/php7/php-fpm.d/www.conf; \
	sed -i 's|user = .*|user = www|g' /etc/php7/php-fpm.d/www.conf; \
	sed -i 's|group = .*|group = www|g' /etc/php7/php-fpm.d/www.conf; \
	sed -i 's|;clear_env =.*|clear_env = no|g' /etc/php7/php-fpm.d/www.conf; \
	sed -i 's|;catch_workers_output =.*|catch_workers_output = yes|g' /etc/php7/php-fpm.d/www.conf; \
	echo 'php_admin_value[error_log] = /var/log/php7/error.log' >> /etc/php7/php-fpm.d/www.conf; \
	echo 'php_admin_value[memory_limit] = 128M' >> /etc/php7/php-fpm.d/www.conf; \
	echo 'php_admin_value[post_max_size] = 128M' >> /etc/php7/php-fpm.d/www.conf; \
	echo 'php_admin_value[upload_max_filesize] = 128M' >> /etc/php7/php-fpm.d/www.conf; \
	echo 'php_admin_value[file_uploads] = on' >> /etc/php7/php-fpm.d/www.conf; \
	echo 'php_admin_value[upload_tmp_dir] = /tmp' >> /etc/php7/php-fpm.d/www.conf; \
	echo 'php_admin_value[precision] = 16' >> /etc/php7/php-fpm.d/www.conf; \
	echo 'php_admin_value[max_execution_time] = 30' >> /etc/php7/php-fpm.d/www.conf; \
	echo 'php_admin_value[session.save_path] = /data/php/session' >> /etc/php7/php-fpm.d/www.conf; \
	echo 'php_admin_value[soap.wsdl_cache_dir] = /data/php/wsdlcache' >> /etc/php7/php-fpm.d/www.conf; \
	ln -sf /proc/1/fd/1 /var/log/nginx/access.log; \
	ln -sf /proc/1/fd/2 /var/log/nginx/error.log; \
	ln -sf /proc/1/fd/2 /var/log/php7/error.log; \
	echo 'Ok'
	
ADD files /src/files
RUN cd ~; \
	rm -f /etc/nginx/conf.d/default.conf; \
	cp -rf /src/files/etc/* /etc/; \
	cp -rf /src/files/root/* /root/; \
	cp -rf /src/files/usr/* /usr/; \
	cp -rf /src/files/var/* /var/; \
	rm -rf /src/files; \
	chmod +x /root/run.sh; \
	echo 'Ok'

CMD ["/root/run.sh"]
