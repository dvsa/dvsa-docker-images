FROM php:8.2-cli-alpine3.19

# Configure PHP
RUN cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"
COPY php.ini ${PHP_INI_DIR}/conf.d/000-dvsa-base.ini

USER www-data
