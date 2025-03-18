ARG ARCH=""
FROM ${ARCH}alpine:3.8

RUN cd ~; \
	apk update --no-cache; \
	apk upgrade --no-cache; \
	apk add --no-cache bash nano mc wget net-tools pv zip unzip supervisor procps grep sudo; \
	rm -rf /var/cache/apk/*; \
	echo "export EDITOR=nano" > /etc/profile.d/editor_nano; \
	echo "Ok"

RUN cd ~; \
	apk add --no-cache php5 php5-fpm php5-json php5-openssl php5-pdo_mysql php5-curl php5-phar php5-bcmath php5-sockets php5-mysqli php5-soap php5-ctype php5-iconv php5-dom php5-gd php5-mysql php5-exif php5-zip php5-xml php5-xmlreader php5-opcache php5-apcu php5-mcrypt php5-intl php5-pdo_mysql php5-pdo_sqlite php5-sqlite3 php5-pgsql php5-cgi php5-embed php5-xmlrpc php5-dbg php5-sysvshm php5-imap php5-doc php5-common php5-calendar php5-pdo_dblib php5-dba php5-odbc php5-shmop php5-wddx php5-cli php5-suhosin php5-phpdbg php5-bz2 php5-sysvmsg php5-pspell php5-dev php5-ftp php5-gettext php5-mssql php5-pcntl php5-pear php5-pdo_pgsql php5-pdo php5-sysvsem php5-posix php5-xsl php5-ldap php5-pdo_odbc php5-enchant php5-gmp php5-snmp curl nginx mysql-client; \
	rm -rf /var/cache/apk/*; \
	addgroup -g 1000 -S www; \
	adduser -D -H -S -G www -u 1000 www; \
	adduser nginx www; \
	chown -R www:www /var/log/nginx; \
	rm -rf /var/cache/apk/*; \
	echo 'Ok'

RUN cd ~; \
	sed -i 's|;date.timezone =.*|date.timezone = UTC|g' /etc/php5/php.ini; \
	sed -i 's|short_open_tag =.*|short_open_tag = On|g' /etc/php5/php.ini; \
	sed -i 's|display_errors =.*|display_errors = On|g' /etc/php5/php.ini; \
	sed -i 's|error_reporting =.*|display_errors = E_ALL|g' /etc/php5/php.ini; \
	sed -i 's|listen =.*|listen = /var/run/php-fpm.sock|g' /etc/php5/php-fpm.conf; \
	sed -i 's|;listen.owner =.*|listen.owner = www|g' /etc/php5/php-fpm.conf; \
	sed -i 's|;listen.group =.*|listen.group = www|g' /etc/php5/php-fpm.conf; \
	sed -i 's|;listen.mode =.*|listen.mode = 0660|g' /etc/php5/php-fpm.conf; \
	sed -i 's|user = .*|user = www|g' /etc/php5/php-fpm.conf; \
	sed -i 's|group = .*|group = www|g' /etc/php5/php-fpm.conf; \
	sed -i 's|;clear_env =.*|clear_env = no|g' /etc/php5/php-fpm.conf; \
	sed -i 's|;catch_workers_output =.*|catch_workers_output = yes|g' /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[error_log] = /var/log/nginx/php_error.log' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[memory_limit] = 128M' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[post_max_size] = 128M' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[upload_max_filesize] = 128M' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[file_uploads] = on' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[upload_tmp_dir] = /tmp' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[precision] = 16' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[max_execution_time] = 30' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[session.save_path] = /data/php/session' >> /etc/php5/php-fpm.conf; \
	echo 'php_admin_value[soap.wsdl_cache_dir] = /data/php/wsdlcache' >> /etc/php5/php-fpm.conf; \
	ln -sf /proc/1/fd/1 /var/log/nginx/access.log; \
	ln -sf /proc/1/fd/2 /var/log/nginx/php_error.log; \
	ln -sf /proc/1/fd/2 /var/log/nginx/error.log; \
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

