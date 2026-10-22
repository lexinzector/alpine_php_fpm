ARG ARCH=
FROM ${ARCH}alpine:3.24

RUN cd ~; \
	apk update --no-cache; \
	apk upgrade --no-cache; \
	apk add --no-cache bash nano mc wget net-tools python3 pv zip unzip supervisor procps grep sudo util-linux tzdata; \
	rm -rf /var/cache/apk/*; \
	echo "export EDITOR=nano" > /etc/profile.d/editor_nano; \
	echo "Ok"

RUN cd ~; \
	apk add --no-cache php85 php85-fpm php85-bcmath php85-bz2 php85-calendar php85-cgi php85-common php85-ctype php85-curl php85-dba php85-dbg php85-dom php85-embed php85-enchant php85-exif php85-ffi php85-fileinfo php85-ftp php85-gd php85-gettext php85-gmp php85-iconv php85-imap php85-intl php85-ldap php85-litespeed php85-mbstring php85-mysqli php85-mysqlnd php85-odbc php85-opcache php85-openssl php85-pcntl php85-pdo php85-pdo_dblib php85-pdo_mysql php85-pdo_odbc php85-pdo_pgsql php85-pdo_sqlite php85-pear php85-pecl-amqp php85-pecl-apcu php85-pecl-ast php85-pecl-brotli php85-pecl-couchbase php85-pecl-decimal php85-pecl-ds php85-pecl-event php85-pecl-grpc php85-pecl-igbinary php85-pecl-imagick php85-pecl-luasandbox php85-pecl-lzf php85-pecl-mailparse php85-pecl-maxminddb php85-pecl-mcrypt php85-pecl-memcache php85-pecl-memcached php85-pecl-mongodb php85-pecl-msgpack php85-pecl-opentelemetry php85-pecl-pcov php85-pecl-protobuf php85-pecl-psr php85-pecl-rdkafka php85-pecl-redis php85-pecl-smbclient php85-pecl-ssh2 php85-pecl-swoole php85-pecl-timezonedb php85-pecl-uploadprogress php85-pecl-uuid php85-pecl-vips php85-pecl-xdebug php85-pecl-xhprof php85-pecl-xhprof-assets php85-pecl-xlswriter php85-pecl-yaml php85-pecl-zstd php85-pgsql php85-phar php85-phpdbg php85-posix php85-pspell php85-session php85-shmop php85-simplexml php85-snmp php85-soap php85-sockets php85-sodium php85-spx php85-sqlite3 php85-sysvmsg php85-sysvsem php85-sysvshm php85-tidy php85-tokenizer php85-xml php85-xmlreader php85-xmlwriter php85-xsl php85-zip curl nginx mysql-client; \
	rm -rf /var/cache/apk/*; \
	addgroup -g 800 -S www; \
	adduser -D -H -S -G www -u 800 www; \
	adduser nginx www; \
	chown -R www:www /var/log/nginx; \
	rm -rf /var/cache/apk/*; \
	echo 'Ok'

RUN cd ~; \
	sed -i 's|;date.timezone =.*|date.timezone = UTC|g' /etc/php85/php.ini; \
	sed -i 's|short_open_tag =.*|short_open_tag = On|g' /etc/php85/php.ini; \
	sed -i 's|display_errors =.*|display_errors = On|g' /etc/php85/php.ini; \
	sed -i 's|error_reporting =.*|error_reporting = E_ALL|g' /etc/php85/php.ini; \
	sed -i 's|;error_log =.*|error_log = /dev/stderr|g' /etc/php85/php.ini; \
	sed -i 's|listen =.*|listen = /var/run/php-fpm.sock|g' /etc/php85/php-fpm.d/www.conf; \
	sed -i 's|;listen.owner =.*|listen.owner = nginx|g' /etc/php85/php-fpm.d/www.conf; \
	sed -i 's|;listen.group =.*|listen.group = www|g' /etc/php85/php-fpm.d/www.conf; \
	sed -i 's|;listen.mode =.*|listen.mode = 0660|g' /etc/php85/php-fpm.d/www.conf; \
	sed -i 's|user = .*|user = www|g' /etc/php85/php-fpm.d/www.conf; \
	sed -i 's|group = .*|group = www|g' /etc/php85/php-fpm.d/www.conf; \
	sed -i 's|;clear_env =.*|clear_env = no|g' /etc/php85/php-fpm.d/www.conf; \
	sed -i 's|;catch_workers_output =.*|catch_workers_output = yes|g' /etc/php85/php-fpm.d/www.conf; \
	sed -i 's/^pm.max_children\s*=.*/pm.max_children = 20/' /etc/php85/php-fpm.d/www.conf; \
	sed -i 's/^pm.start_servers\s*=.*/pm.start_servers = 5/' /etc/php85/php-fpm.d/www.conf; \
	sed -i 's/^pm.min_spare_servers\s*=.*/pm.min_spare_servers = 5/' /etc/php85/php-fpm.d/www.conf; \
	sed -i 's/^pm.max_spare_servers\s*=.*/pm.max_spare_servers = 10/' /etc/php85/php-fpm.d/www.conf; \
	echo 'php_admin_value[error_log] = /dev/stderr' >> /etc/php85/php-fpm.d/www.conf; \
	echo 'php_admin_value[memory_limit] = 128M' >> /etc/php85/php-fpm.d/www.conf; \
	echo 'php_admin_value[post_max_size] = 128M' >> /etc/php85/php-fpm.d/www.conf; \
	echo 'php_admin_value[upload_max_filesize] = 128M' >> /etc/php85/php-fpm.d/www.conf; \
	echo 'php_admin_value[file_uploads] = on' >> /etc/php85/php-fpm.d/www.conf; \
	echo 'php_admin_value[upload_tmp_dir] = /tmp' >> /etc/php85/php-fpm.d/www.conf; \
	echo 'php_admin_value[precision] = 16' >> /etc/php85/php-fpm.d/www.conf; \
	echo 'php_admin_value[max_execution_time] = 30' >> /etc/php85/php-fpm.d/www.conf; \
	echo 'php_admin_value[session.save_path] = /data/php/session' >> /etc/php85/php-fpm.d/www.conf; \
	echo 'php_admin_value[soap.wsdl_cache_dir] = /data/php/wsdlcache' >> /etc/php85/php-fpm.d/www.conf; \
	ln -sf /proc/1/fd/1 /var/log/nginx/access.log; \
	ln -sf /proc/1/fd/2 /var/log/nginx/error.log; \
	ln -sf /proc/1/fd/2 /var/log/php85/error.log; \
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
