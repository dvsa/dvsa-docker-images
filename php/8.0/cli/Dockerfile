FROM php:8.0-fpm-alpine3.16

# Add supervisord
RUN apk add --no-cache supervisor~=4
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure PHP
RUN cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"
COPY php.ini ${PHP_INI_DIR}/conf.d/000-dvsa-base.ini

EXPOSE 80

USER www-data
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
