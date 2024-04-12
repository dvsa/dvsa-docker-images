FROM php:8.0-fpm-alpine3.16

# Add supervisord - Trigger CI.
RUN apk add --no-cache supervisor~=4
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add nginx
RUN apk add --no-cache nginx~=1 \
    && chown -R www-data:www-data /run /var/lib/nginx /var/log/nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Configure PHP
RUN cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"
COPY php.ini ${PHP_INI_DIR}/conf.d/000-dvsa-base.ini

# Configure PHP-FPM
COPY www.conf /usr/local/etc/php-fpm.d/zzz-www.conf

EXPOSE 80

USER www-data
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
