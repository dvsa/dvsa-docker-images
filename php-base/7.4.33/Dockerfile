# Base image configuration for PHP 7.4.33
FROM php:7.4.33-fpm-alpine3.16

# Installing supervisor and NGINX
RUN apk add --no-cache supervisor nginx

# Supervisor config
COPY ./supervisord.conf /etc/supervisord.conf

# Configure php-fpm configs
COPY ./php-fpm/php-fpm.d/php-fpm.conf ${PHP_INI_DIR}/php-fpm.d/www.conf
COPY ./php-fpm/php-fpm.d/php-fpm.ini-production ${PHP_INI_DIR}/php/php.ini

# Override nginx configs
COPY ./nginx.conf /etc/nginx/nginx.conf

# Grant access of relevant directories to user `www-data`
RUN chown www-data: /var/log/ \
                    /run/ \
                    /var/lib/ \
                    /usr/local/var -R

RUN chmod 700 /var/log/ \
              /run/ \
              /var/lib/ \
              /usr/local/var -R

# Non-root user in docker
USER www-data

# Expose port 80 for nginx
EXPOSE 80

# Default command executed during container startup
ENTRYPOINT ["/bin/sh"]

# Default startup command when container is launched
CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]