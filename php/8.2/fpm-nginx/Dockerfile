FROM php:8.2-fpm-alpine3.23

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
