FROM amazoncorretto:8-alpine3.21

ENV APP_USER=appUser \
    APP_GROUP=appGroup \
    APP_HOME=/opt/application

LABEL title="corretto-alpine"
LABEL version="1.0"
LABEL organisation="DVSA"
LABEL description="Base Alpine image with Amazon Corretto 8."

RUN apk update && apk upgrade && rm -rf /var/cache/apk/*

RUN addgroup -S ${APP_GROUP} && adduser -S ${APP_USER} -G ${APP_GROUP}

WORKDIR ${APP_HOME}
RUN chown -R ${APP_USER}:${APP_GROUP} ${APP_HOME} /var/log /var/cache

USER ${APP_USER}

EXPOSE 8080 8081

CMD ["sh"]
