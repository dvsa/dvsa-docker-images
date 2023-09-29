# Add metadata to the image



FROM php:7.4.33-fpm-alpine as production

#php:7.4.0-fpm-alpine
# php:8.0-fpm-alpine

LABEL maintainer="shaun.hare@dvsa.gov.uk"
LABEL description="PHP Alpine base image with dependency packages"
LABEL Name="vol-php-fpm:7.4.33-alpine-fpm"
LABEL Version="0.1"

RUN apk add --no-cache \
        bash \
        autoconf \
        g++ \
        make \
        git \
        icu-dev \
        libmcrypt-dev \
        libpng-dev \
        libzip-dev \
        zlib-dev \
        python3 \
        py3-pip && \
        pip3 install --upgrade awscli && rm -rf '/var/cache/apk/*' \
    && docker-php-ext-install \
        bcmath \
        gd \
        intl \
        opcache \
        pdo_mysql \
        zip \
        pdo_mysql \
        intl 


RUN pecl install apcu apcu_bc igbinary mcrypt stats-2.0.3
RUN docker-php-ext-enable apcu igbinary mcrypt stats

RUN pecl install -D 'enable-redis-igbinary="yes" enable-redis-lzf="no" enable-redis-zstd="no"' redis
RUN docker-php-ext-enable redis

# Tweak apcu extension settings\
RUN echo 'extension=apc' >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini && \
    echo 'apc.enabled = 1' >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini && \
    echo 'apc.mmap_file_mask = /tmp/apc.XXXXXX' >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini && \
    # Tweak date settings
    sed -i 's/;date.timezone =/date.timezone = "Europe\/London"/g' /usr/local/etc/php/php.ini-production && \
    # Tweak igbinary extension settings
    echo 'session.serialize_handler = igbinary' >> /usr/local/etc/php/conf.d/docker-php-ext-igbinary.ini && \
    echo 'session.save_handler = redis' >> /usr/local/etc/php/php.ini-production && \
    # Set session.save_path for default \
    sed -i "s#.*session.save_path = .*#session.save_path = \"tcp://redis:6379\"#" /usr/local/etc/php/php.ini-production && \
    echo 'php_value[session.save_handler] = redis' >> /usr/local/etc/php-fpm.d/www.conf && \
    echo 'php_value[session.save_path] = "tcp://redis:6379"' >> /usr/local/etc/php-fpm.d/www.conf

FROM production as development

RUN apk add --no-cache $PHPIZE_DEPS \
    && pecl install xdebug-3.1.5 \
    && docker-php-ext-enable xdebug

COPY docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini


