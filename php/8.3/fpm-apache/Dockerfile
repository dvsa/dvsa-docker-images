FROM public.ecr.aws/docker/library/php:8.3-fpm-alpine3.20

RUN apk upgrade --no-cache && \
    apk add --no-cache \
        jq=1.6-r1 \
        openrc=0.43.4-r0 \
        apache2=2.4.51-r0 \
        apache2-ctl=2.4.51-r0 \
        apache2-proxy=2.4.51-r0 && \
    apk del php83-apache2 && \
    rm /var/cache/apk/*

# (Default Virtual Host is created with Apache install)

# Disable prefork and enable event
RUN sed -ri -e 's!^LoadModule mpm_prefork_module modules/mod_mpm_prefork.so!#LoadModule mpm_prefork_module modules/mod_mpm_prefork.so!g' /etc/apache2/httpd.conf && \
    sed -ri -e 's!^#LoadModule mpm_event_module modules/mod_mpm_event.so!LoadModule mpm_event_module modules/mod_mpm_event.so!g' /etc/apache2/httpd.conf && \
    sed -ri -e 's!^#LoadModule expires_module modules/mod_expires.so!LoadModule expires_module modules/mod_expires.so!g' /etc/apache2/httpd.conf && \
    sed -ri -e 's!^#LoadModule rewrite_module modules/mod_rewrite.so!LoadModule rewrite_module modules/mod_rewrite.so!g' /etc/apache2/httpd.conf

# Copy Apache FPM proxy config
COPY ./php-fpm-proxy.conf /etc/apache2/conf.d/php-fpm-proxy.conf

# Apache Config file
COPY ./httpd-sysconfig /etc/sysconfig/httpd

# Apache service start script
COPY httpd-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/httpd-foreground

# on application image ensure that the entrypoint script or a CMD is invoking "httpd-foreground" # CMD ["httpd-foreground"]

############################################################
# PHP
############################################################
# Module pre-reqs
RUN apk upgrade --no-cache && \
    apk add --no-cache \
        libxml2-dev=2.9.12-r1 \
        icu-dev=69.1-r3 \
        ldb-dev=2.4.1-r0 \
        libldap=2.4.59-r1 \
        openldap-dev=2.4.59-r1 \
        libmemcached-dev=1.0.18-r1 \
        libmemcached=1.0.18-r1 \
        autoconf=2.71-r3 \
        pkgconfig=0.29.2-r0 \
        g++=10.3.1_git20210424-r2 \
        zlib-dev=1.2.11-r3 \
        make=4.3-r0 \
        linux-headers=5.10.75-r0 && \
    docker-php-ext-install \
        bcmath \
        intl \
        ldap \
        opcache \
        pcntl \
        soap && \
    pecl install apcu xdebug memcached && \
    docker-php-ext-enable apcu xdebug memcached && \
    apk del make g++ autoconf pkgconfig

# Change default listen port from 80 to 8080
# RUN sed -i 's|Listen 80|Listen 8080|g' /etc/apache2/httpd.conf
EXPOSE 80

# TODO - This should exist at the API level dockerfile
# RUN sed -i 's|ErrorLog logs/error.log|ErrorLog /dev/stderr|g' /etc/apache2/httpd.conf