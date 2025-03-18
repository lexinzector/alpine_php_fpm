ARG ARCH=
FROM ${ARCH}alpine:3.20

RUN cd ~; \
	apk update --no-cache; \
	apk upgrade --no-cache; \
	apk add --no-cache bash nano mc wget curl net-tools python3 pv zip unzip procps grep sudo util-linux tzdata; \
	rm -rf /var/cache/apk/*; \
	echo "export EDITOR=nano" > /etc/profile.d/editor_nano; \
	echo "Ok"

RUN cd ~; \
	apk add --no-cache php83 php83-fpm php83-bcmath php83-bz2 php83-calendar php83-cgi php83-common php83-ctype php83-curl php83-dba php83-dbg php83-dom php83-embed php83-enchant php83-exif php83-ffi php83-fileinfo php83-ftp php83-gd php83-gettext php83-gmp php83-iconv php83-imap php83-intl php83-ldap php83-litespeed php83-mbstring php83-mysqli php83-mysqlnd php83-odbc php83-opcache php83-openssl php83-pcntl php83-pdo php83-pdo_dblib php83-pdo_mysql php83-pdo_odbc php83-pdo_pgsql php83-pdo_sqlite php83-pear php83-pecl-amqp php83-pecl-apcu php83-pecl-ast php83-pecl-brotli php83-pecl-couchbase php83-pecl-decimal php83-pecl-ds php83-pecl-event php83-pecl-grpc php83-pecl-igbinary php83-pecl-imagick php83-pecl-luasandbox php83-pecl-lzf php83-pecl-mailparse php83-pecl-maxminddb php83-pecl-mcrypt php83-pecl-memcache php83-pecl-memcached php83-pecl-mongodb php83-pecl-msgpack php83-pecl-opentelemetry php83-pecl-pcov php83-pecl-protobuf php83-pecl-psr php83-pecl-rdkafka php83-pecl-redis php83-pecl-smbclient php83-pecl-ssh2 php83-pecl-swoole php83-pecl-timezonedb php83-pecl-uploadprogress php83-pecl-uuid php83-pecl-vips php83-pecl-xdebug php83-pecl-xhprof php83-pecl-xhprof-assets php83-pecl-xlswriter php83-pecl-yaml php83-pecl-zstd php83-pgsql php83-phar php83-phpdbg php83-posix php83-pspell php83-session php83-shmop php83-simplexml php83-snmp php83-soap php83-sockets php83-sodium php83-spx php83-sqlite3 php83-sysvmsg php83-sysvsem php83-sysvshm php83-tidy php83-tokenizer php83-xml php83-xmlreader php83-xmlwriter php83-xsl php83-zip  cronie nginx mysql-client; \
	rm -rf /var/cache/apk/*; \
	addgroup -g 800 -S www; \
	adduser -D -H -S -G www -u 800 www; \
	adduser nginx www; \
	rm -rf /var/cache/apk/*; \
	echo 'Ok'

RUN cd ~; \
	sed -i 's|;date.timezone =.*|date.timezone = UTC|g' /etc/php83/php.ini; \
	sed -i 's|short_open_tag =.*|short_open_tag = On|g' /etc/php83/php.ini; \
	sed -i 's|display_errors =.*|display_errors = On|g' /etc/php83/php.ini; \
	sed -i 's|error_reporting =.*|display_errors = E_ALL|g' /etc/php83/php.ini; \
	sed -i 's|;error_log =.*|error_log = /dev/stderr|g' /etc/php83/php.ini; \
	sed -i 's|listen =.*|listen = /var/run/php-fpm.sock|g' /etc/php83/php-fpm.d/www.conf; \
	sed -i 's|;listen.owner =.*|listen.owner = nginx|g' /etc/php83/php-fpm.d/www.conf; \
	sed -i 's|;listen.group =.*|listen.group = www|g' /etc/php83/php-fpm.d/www.conf; \
	sed -i 's|;listen.mode =.*|listen.mode = 0660|g' /etc/php83/php-fpm.d/www.conf; \
	sed -i 's|user = .*|user = www|g' /etc/php83/php-fpm.d/www.conf; \
	sed -i 's|group = .*|group = www|g' /etc/php83/php-fpm.d/www.conf; \
	sed -i 's|;clear_env =.*|clear_env = no|g' /etc/php83/php-fpm.d/www.conf; \
	sed -i 's|;catch_workers_output =.*|catch_workers_output = yes|g' /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[error_log] = /dev/stderr' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[memory_limit] = 128M' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[post_max_size] = 128M' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[upload_max_filesize] = 128M' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[file_uploads] = on' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[upload_tmp_dir] = /tmp' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[precision] = 16' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[max_execution_time] = 30' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[session.save_path] = /data/php/session' >> /etc/php83/php-fpm.d/www.conf; \
	echo 'php_admin_value[soap.wsdl_cache_dir] = /data/php/wsdlcache' >> /etc/php83/php-fpm.d/www.conf; \
	ln -sf /dev/stdout /var/log/nginx/access.log; \
	ln -sf /dev/stderr /var/log/nginx/error.log; \
	ln -sf /dev/stderr /var/log/php83/error.log; \
	echo 'Ok'

RUN cd ~; \
	mkdir -p /data/home; \
	chmod 700 /data/home; \
	addgroup -g 1000 user; \
	adduser -D -G user -u 1000 -h /data/home -s /bin/bash user; \
	adduser user wheel; \
	echo "Ok"

ADD files /
RUN cd ~; \
	rm -f /etc/nginx/conf.d/default.conf; \
	rm -f /etc/nginx/fastcgi.conf; \
	mkdir -p /data; \
	chmod +x /root/main.py; \
	chmod +x /root/run.sh; \
	chmod +x /root/entrypoint.sh; \
	echo 'Ok'

USER user
ENTRYPOINT ["/root/entrypoint.sh"]
CMD ["/root/run.sh"]
