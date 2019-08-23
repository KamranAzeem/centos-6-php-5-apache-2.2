FROM centos:6

EXPOSE 80

CMD ["/usr/sbin/httpd", "-D" , "FOREGROUND" , "-E" , "/proc/self/fd/1"]

RUN  yum -y install httpd \
        php php-xml php-common php-pdo php-gd php-mysql php-pspell php-soap php-cli \
        php-devel php-imap php-mbstring php-pear  pcre pcre-devel \
        ImageMagick ImageMagick-devel gcc make  \
     && printf '\n' | pecl  install --force --onlyreqdeps imagick-3.1.2 \
     && sync \
     && echo "extension=imagick.so" > /etc/php.d/imagick.ini \
     && mkdir /etc/httpd/sites-enabled  /var/www/vhosts \
     && chown apache:apache  /etc/httpd/sites-enabled  /var/www/vhosts   \
     && echo "NameVirtualHost *:80" >> /etc/httpd/conf/httpd.conf \
     && echo "Include sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf \
     && rm -f /etc/httpd/conf.d/ssl.conf \
     && ln -sf /proc/self/fd/1 /var/log/httpd/access_log    \
     && ln -sf /proc/self/fd/1 /var/log/httpd/error_log     \
     && ln -sf /proc/self/fd/1 /var/log/httpd/php_errors.log


COPY 00-default.conf /etc/httpd/sites-enabled/
COPY index.html     /var/www/html/index.html

# Optionally, we can copy-in our custom httpd.conf and php.ini files
# COPY httpd.conf     /etc/httpd/conf/httpd.conf
# COPY php.ini	 /etc/php.ini

