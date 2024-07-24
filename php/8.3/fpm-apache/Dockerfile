FROM public.ecr.aws/docker/library/php:8.3-fpm-alpine3.20

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache jq openrc apache2 apache2-ctl && \
    apk del php83-apache2 && \
    apk add apache2-proxy

# (Default Virtual Host is created with Apache install)

# Disable prefork and enable event
RUN sed -ri -e 's!^LoadModule mpm_prefork_module modules/mod_mpm_prefork.so!#LoadModule mpm_prefork_module modules/mod_mpm_prefork.so!g' /etc/apache2/httpd.conf && \
    sed -ri -e 's!^#LoadModule mpm_event_module modules/mod_mpm_event.so!LoadModule mpm_event_module modules/mod_mpm_event.so!g' /etc/apache2/httpd.conf && \
    sed -ri -e 's!^#LoadModule expires_module modules/mod_expires.so!LoadModule expires_module modules/mod_expires.so!g' /etc/apache2/httpd.conf && \
    sed -ri -e 's!^#LoadModule rewrite_module modules/mod_rewrite.so!LoadModule rewrite_module modules/mod_rewrite.so!g' /etc/apache2/httpd.conf && 

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
RUN apk add --no-cache \
    # Required by soap
    libxml2-dev \
    # Required by intl
    icu-dev \
    # Required by ldap
    ldb-dev \
    libldap \
    openldap-dev \
    # Required for memcached installed via pecl (and possibly used by other pecl modules)
    libmemcached-dev \
    libmemcached \
    autoconf \
    pkgconfig \
    g++ \
    zlib-dev \
    make \
    linux-headers && \
    # Modules ('mysqlnd', 'mbstring', 'pdo' and 'xml' are required but included with PHP)
    docker-php-ext-install \
    bcmath \
    intl \
    ldap \
    opcache \
    # PCNTL is also known as the process extension
    pcntl \
    soap && \
    pecl install apcu xdebug memcached && \
    docker-php-ext-enable apcu xdebug memcached && \
    # Finally, remove unneeded packages after pecl installs
    apk del make g++ autoconf pkgconfig

# Change default listen port from 80 to 8080
# RUN sed -i 's|Listen 80|Listen 8080|g' /etc/apache2/httpd.conf
EXPOSE 80

# TODO - This should exist at the API level dockerfile
# RUN sed -i 's|ErrorLog logs/error.log|ErrorLog /dev/stderr|g' /etc/apache2/httpd.conf