FROM amazoncorretto:8-alpine3.21

ENV APP_USER=dropwizard \
    APP_GROUP=dropwizardgroup \
    APP_HOME=/opt/dropwizard

LABEL title="corretto-alpine-dropwizard"
LABEL version="1.0"
LABEL organisation="DVSA"
LABEL description="Base Alpine image with Amazon Corretto 8 for running Dropwizard applications."

RUN apk update && apk upgrade && rm -rf /var/cache/apk/*

RUN addgroup -S ${APP_GROUP} && adduser -S ${APP_USER} -G ${APP_GROUP}

WORKDIR ${APP_HOME}
RUN chown -R ${APP_USER}:${APP_GROUP} ${APP_HOME} /var/log /var/cache

USER ${APP_USER}

EXPOSE 8080 8081

CMD ["sh"]
