# php-5.3-apache-2.2 on centos 6

## Build image:
```
docker build -t local/centos:6-php-5.3-apache-2.2-v-1.0 .
```

## About this image:
This image is created to migrate some legacy websites from one server to a server in AWS. Changing the version of Apache , or PHP was not an option. So an exact copy of the setup being run on the current server is made in the form of docker image.

This image has some restrictions in terms of Apache **prefork** processes, and PHP limits 
* In Apache `httpd.conf` very few Prefork processes are setup/started to take in user requests/traffic
* In Apache `httpd.conf` very few / minimum modules are loaded  
* In PHP's `php.ini` max memory allocated to php scripts is just 32 MB
* In PHP's `php.ini` file uploads are disabled

These settings are setup this way because the websites we want to serve through this image are very old/legacy websites, which may have buggy code / vulnerabilities. I want to make sure that no new content is added to these websites. As a precaution, their web-roots are loaded as **read only** through docker-compose to prevent anything being written to the disk. 

If you want to use different settings, please build your own image by using your own httpd.conf and php.ini files. 

The most important sections of httpd.conf (in this image) are as follows:

```
[kamran@kworkhorse centos-6-php-5.3-apache-2.2]$ grep -v \# httpd.conf  | grep -v ^$

. . . [snipped] ...

<IfModule prefork.c>
StartServers     2
ServerLimit      8
MinSpareServers    2
MaxSpareServers    2
MaxClients       64
MaxRequestsPerChild  16
</IfModule>

. . . [snipped] ...

Listen 80


. . . [snipped] ...

NameVirtualHost *:80
Include sites-enabled/*.conf

[kamran@kworkhorse centos-6-php-5.3-apache-2.2]$ 


```

The most important settings in php.ini (in this image) are as follows:
```
[kamran@kworkhorse centos-6-php-5.3-apache-2.2]$ grep -v \; php.ini  | grep -v ^$

[PHP]

. . . [snipped] ...

safe_mode = Off
disable_functions = show_source, system, shell_exec, passthru, exec, phpinfo, popen, proc_open, escapeshellcmd, pcntl_exec, init_set, pclose
max_execution_time = 30     
max_input_time = 60
memory_limit = 32M
error_reporting = E_ALL & ~E_DEPRECATED
display_errors = Off
display_startup_errors = Off
log_errors = On
log_errors_max_len = 1024
ignore_repeated_errors = Off
ignore_repeated_source = Off
report_memleaks = On
track_errors = Off
html_errors = Off
error_log = /var/log/httpd/php_errors.log
variables_order = "GPCS"
request_order = "GP"
register_globals = Off
register_long_arrays = Off
register_argc_argv = Off
auto_globals_jit = On
post_max_size = 1M

. . . [snipped] ...

file_uploads = Off
upload_tmp_dir = /tmp
upload_max_filesize = 1M

[Date]
date.timezone = "Europe/Oslo"

. . . [snipped] ...

[kamran@kworkhorse centos-6-php-5.3-apache-2.2]$ 
```


