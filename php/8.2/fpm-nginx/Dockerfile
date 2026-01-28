FROM php:8.2-fpm-alpine3.22

# Prevent lag in CVE and other security resolutions and refactor run command to improve layer caching.
RUN apk --no-cache update \
  && apk upgrade --no-cache \
  && apk add --no-cache nginx~=1 supervisor~=4 \
  && chown -R www-data /run /var/lib/nginx /var/log/nginx
# Copy the PHP production configuration.
RUN cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"
COPY php.ini ${PHP_INI_DIR}/conf.d/zzz-dvsa-base.ini
COPY php-fpm.conf /usr/local/etc/php-fpm.d/zzz-www.conf

# Copy the nginx and supervisor configuration files.
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf
COPY supervisord /etc/supervisor/conf.d

EXPOSE 80

USER www-data

CMD ["/usr/bin/supervisord"]
# trigger build
