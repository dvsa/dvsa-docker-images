FROM amazoncorretto:8-alpine3.21

ENV APACHE_VERSION=2.4.62-r0 \
    APACHE_USER=httpd

LABEL title="apache-corretto-alpine"
LABEL version="1.0"
LABEL organisation="DVSA"
LABEL description="Base Alpine image with Amazon Corretto 8 and Apache HTTP Server."

RUN apk update && apk upgrade && \
    apk add --no-cache apache2=${APACHE_VERSION} && \
    rm -rf /var/cache/apk/*

RUN addgroup -S ${APACHE_USER} && adduser -S -G ${APACHE_USER} ${APACHE_USER}

RUN chown -R ${APACHE_USER}:${APACHE_USER} /var/www /etc/apache2 /var/run/apache2 /var/log/apache2

USER ${APACHE_USER}

EXPOSE 80

ENTRYPOINT ["httpd", "-D", "FOREGROUND"]
