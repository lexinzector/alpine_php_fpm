ARG ARCH=
FROM ${ARCH}alpine:3.14

RUN cd ~; \
	apk update; \
	apk upgrade; \
	apk add bash nano mc wget net-tools pv zip unzip supervisor procps grep sudo; \
	rm -rf /var/cache/apk/*; \
	echo "export EDITOR=nano" > /etc/profile.d/editor_nano; \
	echo "Ok"

RUN cd ~; \
	apk update; \
	apk add php8 php8-fpm php8-imap php8-ftp php8-pspell php8-phar php8-pecl-imagick-dev php8-litespeed php8-pecl-vips php8-dba php8-exif php8-xsl php8-dev php8-gd php8-pcntl php8-fileinfo php8-pecl-uuid php8-pecl-event php8-calendar php8-pecl-apcu php8-pdo_mysql php8-mysqli php8-pgsql php8-common php8-posix php8-bz2 php8-pecl-redis php8-pecl-imagick php8-sysvmsg php8-pdo_odbc php8-snmp php8-sockets php8-doc php8-bcmath php8-pecl-memcache php8-pecl-xhprof php8-sysvshm php8-pecl-oauth php8-pecl-mongodb php8-zip php8-intl php8-enchant php8-pecl-protobuf php8-gettext php8-pecl-xdebug php8-ldap php8-tokenizer php8-ffi php8-embed php8-simplexml php8-pecl-yaml php8-pecl-mailparse php8-iconv php8-pecl-lzf php8-shmop php8-tideways_xhprof php8-dom php8-opcache php8-pecl-couchbase php8-curl php8-pecl-timezonedb php8-tidy php8-session php8-pecl-igbinary php8-xml php8-sysvsem php8-pecl-ast php8-pecl-mcrypt php8-cgi php8-pdo_sqlite php8-mysqlnd php8-pecl-memcached php8-pecl-msgpack php8-brotli php8-pecl-xhprof-assets php8-odbc php8-pecl-uploadprogress-doc php8-sqlite3 php8-soap php8-dbg php8-phpdbg php8-xmlreader php8-pecl-psr php8-gmp php8-ctype php8-openssl php8-pear php8-pdo php8-pecl-ssh2 php8-sodium php8-pdo_pgsql php8-pdo_dblib php8-pecl-maxminddb php8-mbstring php8-pecl-uploadprogress php8-xmlwriter curl nginx mysql-client; \
	rm -rf /var/cache/apk/*; \
	addgroup -g 1000 -S www; \
	adduser -D -H -S -G www -u 1000 www; \
	adduser nginx www; \
	chown -R www:www /var/log/nginx; \
	rm -rf /var/cache/apk/*; \
	echo 'Ok'
	
RUN cd ~; \
	sed -i 's|;date.timezone =.*|date.timezone = UTC|g' /etc/php8/php.ini; \
	sed -i 's|short_open_tag =.*|short_open_tag = On|g' /etc/php8/php.ini; \
	sed -i 's|display_errors =.*|display_errors = On|g' /etc/php8/php.ini; \
	sed -i 's|error_reporting =.*|display_errors = E_ALL|g' /etc/php8/php.ini; \
	sed -i 's|;error_log =.*|error_log = /var/log/php8/error.log|g' /etc/php8/php.ini; \
	sed -i 's|listen =.*|listen = /var/run/php-fpm.sock|g' /etc/php8/php-fpm.d/www.conf; \
	sed -i 's|;listen.owner =.*|listen.owner = www|g' /etc/php8/php-fpm.d/www.conf; \
	sed -i 's|;listen.group =.*|listen.group = www|g' /etc/php8/php-fpm.d/www.conf; \
	sed -i 's|;listen.mode =.*|listen.mode = 0660|g' /etc/php8/php-fpm.d/www.conf; \
	sed -i 's|user = .*|user = www|g' /etc/php8/php-fpm.d/www.conf; \
	sed -i 's|group = .*|group = www|g' /etc/php8/php-fpm.d/www.conf; \
	sed -i 's|;clear_env =.*|clear_env = no|g' /etc/php8/php-fpm.d/www.conf; \
	sed -i 's|;catch_workers_output =.*|catch_workers_output = yes|g' /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[error_log] = /var/log/php8/error.log' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[memory_limit] = 128M' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[post_max_size] = 128M' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[upload_max_filesize] = 128M' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[file_uploads] = on' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[upload_tmp_dir] = /tmp' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[precision] = 16' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[max_execution_time] = 30' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[session.save_path] = /data/php/session' >> /etc/php8/php-fpm.d/www.conf; \
	echo 'php_admin_value[soap.wsdl_cache_dir] = /data/php/wsdlcache' >> /etc/php8/php-fpm.d/www.conf; \
	ln -sf /proc/1/fd/1 /var/log/nginx/access.log; \
	ln -sf /proc/1/fd/2 /var/log/nginx/error.log; \
	ln -sf /proc/1/fd/2 /var/log/php8/error.log; \
	ln -s /usr/bin/php8 /usr/bin/php; \
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
