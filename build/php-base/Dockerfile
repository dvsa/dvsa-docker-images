# Base image configuration for PHP 7.4
FROM php:7.4.33-fpm-alpine3.16

# Installing supervisor and NGINX
RUN apk add --no-cache supervisor nginx

# Supervisor config
COPY ./supervisord.conf /etc/supervisord.conf

# Configure php-fpm configs
COPY ./php-fpm/php-fpm.d/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./php-fpm/php-fpm.d/php-fpm.ini /usr/local/etc/php/php.ini

# Override nginx configs
COPY ./nginx.conf /etc/nginx/nginx.conf
# COPY ./nginx/conf.d/virtualserver.conf /etc/nginx/conf.d/virtualserver.conf

# Grant access of relevant directories to user `www-data`
RUN chmod 747 /var/log/ -R && \
    chmod 747 /run/ -R && \
    chmod 747 /var/lib/ -R && \
    chmod 747 /usr/bin/ -R

# Non-root user in docker
USER www-data

# Expose port 80 for nginx
EXPOSE 80

# Default command executed during container startup
ENTRYPOINT ["supervisord"]

# Default startup command when container is launched
CMD ["-c", "/etc/supervisord.conf", "-n"]