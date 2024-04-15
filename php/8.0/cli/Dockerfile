FROM php:8.0-fpm-alpine3.16

# Configure PHP
RUN cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"
COPY php.ini ${PHP_INI_DIR}/conf.d/000-dvsa-base.ini

EXPOSE 80

USER www-data
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
