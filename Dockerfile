FROM ubuntu:14.04

LABEL Author="Virink <virink@outlook.com>"
LABEL Blog="https://www.virzz.com"

ENV LANG=C.UTF-8 DEBIAN_FRONTEND=noninteractive

COPY files /tmp/

RUN sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu\//http:\/\/mirrors.tuna.tsinghua.edu.cn\/ubuntu\//g' /etc/apt/sources.list && \
	sed -i '/security/d' /etc/apt/sources.list && \
	apt-get update -y && \
	apt-get -yqq install zip mariadb-server apache2 php5 libapache2-mod-php5 php5-mysql \
	php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache && \
	# config
	sed -i 's/Options Indexes FollowSymLinks/Options None/' /etc/apache2/apache2.conf && \
	sed -i '/\[mysqld\]/asecure_file_priv = "/"' /etc/mysql/my.cnf && \
	/etc/init.d/apache2 start && \
	# mysql
	rm -rf /var/lib/mysql && \
	mysql_install_db --user=mysql --datadir=/var/lib/mysql && \
	sh -c 'mysqld_safe &' && \
	sleep 5s  && \
	mysqladmin -uroot password "4785c38b1a65aac9" && \
	mysql -e "source /tmp/db.sql;" -uroot -p4785c38b1a65aac9 && \
	mysql -u root -p4785c38b1a65aac9 -e "show databases;" && \
	# /var/www/html
	rm -rf /var/www/html/ && \
	unzip -oq /tmp/html.zip -d /var/www/  && \
	echo '<?php\n\t$flag="flag{wdb2018_truncation_sql_inject}";\n?>' > /var/www/html/flag_8946e1ff1ee3e40f.php && \
	# /home/www
	mkdir /home/www/ && \
	chmod -R 777 /home/www/ && \
	echo "www:x:500:500:www:/home/www:/bin/bash" >> /etc/passwd  && \
	echo "Y2QgL3RtcC8KdW56aXAgaHRtbC56aXAKcm0gLWYgaHRtbC56aXAKY3AgLXIgaHRtbCAvdmFyL3d3dy8KY2QgL3Zhci93d3cvaHRtbC8Kcm0gLWYgLkRTX1N0b3JlCnNlcnZpY2UgYXBhY2hlMiBzdGFydAo=" |base64 -d > /home/www/.bash_history  && \
	# /tmp/html
	unzip -oq /tmp/tmp_html.zip -d /tmp && \
	chmod -R 777 /tmp/html/ && \
	# docker-php-entrypoint
	mv /tmp/docker-php-entrypoint /usr/bin/docker-php-entrypoint && \
	chmod +x /usr/bin/docker-php-entrypoint && \
	# clear
	rm -f /tmp/db.sql && \
	rm -f /tmp/*.zip && \
	rm -rf /etc/apt/*

EXPOSE 80

CMD ["/bin/sh", "-c", "docker-php-entrypoint"]