FROM php:8.6-fpm-alpine3.24

# hadolint ignore=DL3018
RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache \
        nginx~=1 \
        supervisor~=4 \
        python3 \
        py3-pip \
    && chown -R www-data /run /var/lib/nginx /var/log/nginx \
    && pip install --no-cache-dir --break-system-packages --upgrade "wheel>=0.46.2" "jaraco-context>=6.1.0" \
    && find /usr -name "wheel-*.dist-info" ! -name "wheel-0.46.2.dist-info" -type d -exec rm -rf {} + \
    && find /usr -name "jaraco*context-*.dist-info" ! -name "*6.1.0*" -type d -exec rm -rf {} + \
    && rm -rf /usr/lib/python*/site-packages/wheel-0.45.1.dist-info \
    && apk del py3-pip \
    && rm -rf /var/cache/apk/*

# The upstream 8.6 images no longer compile mbstring in: they only enabled it so
# that PECL could use it, and PECL was dropped in 8.6. Install it again so the
# image ships the same extensions as 8.2 to 8.5. oniguruma provides mb_ereg*.
# https://github.com/docker-library/php/pull/1654
# hadolint ignore=DL3018
RUN apk add --no-cache oniguruma \
    && apk add --no-cache --virtual .mbstring-build-deps oniguruma-dev \
    && docker-php-ext-install mbstring \
    && apk del .mbstring-build-deps

# Copy the PHP production configuration.
RUN cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"

# Copy the nginx configuration files.
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the php configuration files.
COPY php.ini ${PHP_INI_DIR}/conf.d/zzz-dvsa-base.ini
COPY php-fpm.conf /usr/local/etc/php-fpm.d/zzz-www.conf

# Copy the supervisor configuration files.
COPY supervisord.conf /etc/supervisord.conf
COPY supervisord /etc/supervisor/conf.d

EXPOSE 80

USER www-data

CMD ["/usr/bin/supervisord"]
