# Base image configuration for PHP 7.4.33
FROM php:7.4-fpm-alpine3.16

# Installing supervisor and NGINX
# Grant access of relevant directories to user `www-data`
RUN apk add --no-cache supervisor nginx && \
    chown www-data: /run/ \
                    /var/lib/nginx \
                    /usr/local/var/log -R && \
    chown www-data: /var/log/nginx

# Supervisor config
COPY ./supervisord.conf /etc/supervisord.conf

# Configure php-fpm configs
COPY ./php-fpm.conf ${PHP_INI_DIR}-fpm.d/www.conf
COPY ./php-fpm.ini ${PHP_INI_DIR}/php.ini

# Override nginx configs
COPY ./nginx.conf /etc/nginx/nginx.conf

# Non-root user in docker
USER www-data

# Expose port 80 for nginx
EXPOSE 80

# Default startup command when container is launched
CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]