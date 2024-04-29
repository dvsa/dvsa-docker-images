FROM php:8.2-cli-alpine3.19

# Copy the PHP production configuration.
RUN cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini" \
  && chown root:www-data "${PHP_INI_DIR}/php.ini"

# Copy the configuration files.
COPY --chown=root:www-data --chmod=440 php.ini ${PHP_INI_DIR}/conf.d/zzz-dvsa-base.ini

USER www-data
