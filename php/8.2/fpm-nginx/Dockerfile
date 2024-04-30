FROM php:8.2-fpm-alpine3.19

# Add supervisord.
RUN apk add --no-cache supervisor~=4

# Add nginx.
RUN apk add --no-cache nginx~=1 \
  && chown -R www-data /run /var/lib/nginx /var/log/nginx

# Copy the PHP production configuration.
RUN cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"

# Copy the configuration files.
COPY nginx.conf /etc/nginx/nginx.conf
COPY php.ini ${PHP_INI_DIR}/conf.d/zzz-dvsa-base.ini
COPY www.conf /usr/local/etc/php-fpm.d/zzz-www.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

USER www-data

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
