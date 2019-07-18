FROM centos:6

EXPOSE 80

CMD ["/usr/sbin/httpd", "-D" , "FOREGROUND" , "-E" , "/proc/self/fd/1"]

RUN  yum -y install httpd \
        php php-xml php-common php-pdo php-gd php-mysql php-pspell php-soap php-cli php-devel php-imap php-mbstring php-pear \
     && mkdir /etc/httpd/sites-enabled  /var/www/vhosts \
     && chown apache:apache /var/www/vhosts \
     && ln -sf /proc/self/fd/1 /var/log/httpd/access_log    \
     && ln -sf /proc/self/fd/1 /var/log/httpd/error_log     \
     && ln -sf /proc/self/fd/1 /var/log/httpd/php_errors.log

COPY 00-default.conf /etc/httpd/sites-enabled/
COPY index.html    /var/www/html

