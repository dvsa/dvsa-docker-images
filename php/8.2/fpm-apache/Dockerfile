FROM php:8.2-fpm-alpine3.20

# hadolint ignore=DL3018
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
        jq \
        openrc \
        apache2 \
        apache2-ctl \
        build-base \
        apache2-proxy && \
    apk del php82-apache2 && \
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
