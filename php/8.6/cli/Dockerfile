FROM php:8.6-cli-alpine3.24

RUN apk update --no-cache \
    && apk upgrade --no-cache

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
RUN cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini" \
    && chown www-data "${PHP_INI_DIR}/php.ini"

# Copy the configuration files.
COPY php.ini ${PHP_INI_DIR}/conf.d/zzz-dvsa-base.ini

USER www-data
