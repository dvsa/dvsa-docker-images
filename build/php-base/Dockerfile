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

# Configure nginx and PHP configuration for supervisord
COPY ./supervisord.conf /etc/supervisord.conf

# Expose port 80 for nginx
EXPOSE 80

# Default command executed during container startup
ENTRYPOINT ["/bin/sh"]

# Default startup command when container is launched
CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]