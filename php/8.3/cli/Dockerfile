FROM php:8.3-cli-alpine3.20

# Copy the PHP production configuration.
RUN cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini" \
  && chown www-data "${PHP_INI_DIR}/php.ini"

# Copy the configuration files.
COPY php.ini ${PHP_INI_DIR}/conf.d/zzz-dvsa-base.ini

USER www-data
# trigger build
