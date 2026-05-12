FROM php:8.2-fpm-alpine3.23

# hadolint ignore=DL3018
RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache \
        python3 \
        py3-pip \
        jq \
        openrc \
        apache2 \
        apache2-ctl \
        build-base \
        apache2-proxy \
    && pip install --no-cache-dir --break-system-packages --upgrade "jaraco-context>=6.1.0" wheel>=0.46.2 \
    && find /usr/lib/python* -name "jaraco.context-*" ! -name "*6.1.0*" -type d -exec rm -rf {} + \
    && find /usr/lib/python* -name "jaraco_context-*" ! -name "*6.1.0*" -type d -exec rm -rf {} + \
    && apk del -f php82-apache2 build-base py3-pip || true \
    && rm -rf /var/cache/apk/*

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
