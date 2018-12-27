#!/bin/bash
sleep 1

mkdir /home/www/
sed -i '/\[mysqld\]/asecure_file_priv = "/"' /etc/mysql/my.cnf && \
/etc/init.d/apache2 start && \
find /var/lib/mysql -type f -exec touch {} \; && \
service mysql start
rm -rf /var/www/html/
unzip /root/html.zip -d /var/www/
echo "www:x:500:500:www:/home/www:/bin/bash" >> /etc/passwd
echo "Y2QgL3RtcC8KdW56aXAgaHRtbC56aXAKcm0gLWYgaHRtbC56aXAKY3AgLXIgaHRtbCAvdmFyL3d3dy8KY2QgL3Zhci93d3cvaHRtbC8Kcm0gLWYgLkRTX1N0b3JlCnNlcnZpY2UgYXBhY2hlMiBzdGFydAo=" |base64 -d > /home/www/.bash_history
chmod -R 777 /home/www/
unzip /tmp/tmp_html.zip -d /tmp
chmod -R 777 /tmp/html/
echo -e '<?php\n\t$flag="flag{wdb2018_truncation_sql_inject}";\n?>' > /var/www/html/flag_8946e1ff1ee3e40f.php
mysqladmin -u root password "4785c38b1a65aac9"
mysql -uroot -p4785c38b1a65aac9 < /tmp/db.sql
rm -f /tmp/db.sql
rm -f /tmp/tmp_html.zip
/bin/bash
