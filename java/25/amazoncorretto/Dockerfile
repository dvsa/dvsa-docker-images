ARG JAVA_VERSION=25
ARG ALPINE_VERSION=3.23

FROM amazoncorretto:${JAVA_VERSION}-alpine${ALPINE_VERSION}

ARG JAVA_VERSION

LABEL title="corretto-alpine"
LABEL version="1.0"
LABEL organisation="DVSA"
LABEL description="Base Alpine image with Amazon Corretto ${JAVA_VERSION}."

ENV APP_USER=appUser \
    APP_GROUP=appGroup \
    APP_HOME=/opt/dvsa

RUN set -eux; \
    apk update && apk upgrade --no-cache && rm -rf /var/cache/apk/*; \
    addgroup -S "$APP_GROUP"; \
    adduser -S "$APP_USER" -G "$APP_GROUP"; \
    mkdir -p "$APP_HOME" && chown "$APP_USER:$APP_GROUP" "$APP_HOME"

WORKDIR ${APP_HOME}

USER ${APP_USER}

CMD ["sh"]
