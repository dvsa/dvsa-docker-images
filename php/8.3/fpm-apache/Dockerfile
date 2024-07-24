FROM public.ecr.aws/docker/library/php:8.3-fpm-alpine3.20

RUN apk update
RUN apk upgrade --no-cache

RUN apk add --no-cache \
    jq \
    openrc
#     logrotate  - # may not be needed

############################################################
# Apache
############################################################

# Apache modules ('prefork' and  'status' are required but are included with Apache)
RUN apk add --no-cache php83-apache2

# Apache itself
RUN apk add --no-cache \
    apache2  \
    apache2-ctl

# (Default Virtual Host is created with Apache install)

# Apache service start script (to be invoked later)
COPY httpd-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/httpd-foreground

# On application image ensure that the entrypoint script or a CMD is invoking "httpd-foreground" # CMD ["httpd-foreground"]

############################################################
# PHP
############################################################
# Module pre-reqs
RUN apk add --no-cache \
    # required by soap
    libxml2-dev \
    # required by intl
    icu-dev \
    # required by ldap
    ldb-dev \
    libldap \
    openldap-dev \
    # required for memcached installed via pecl (and possibly used by other pecl modules)
    libmemcached-dev \
    libmemcached \
    autoconf \
    pkgconfig \
    g++ \
    zlib-dev \
    make \
    linux-headers


# Modules ('mbstring', 'mysqlnd', 'pdo' and 'xml' are required but included with PHP)
RUN docker-php-ext-install \
    bcmath \
    intl \
    ldap \
    opcache \
# pcntl is also known as the process extension
    pcntl \
    soap

RUN pecl install apcu xdebug memcached
RUN docker-php-ext-enable apcu xdebug memcached

# remove unneeded packages after pecl installs
RUN apk del make g++ autoconf pkgconfig
