FROM amazoncorretto:8-alpine3.21

LABEL title="corretto-alpine"
LABEL version="1.0"
LABEL organisation="DVSA"
LABEL description="Base Alpine image with Amazon Corretto 8."

RUN apk --no-check-certificate update && apk --no-check-certificate upgrade && rm -rf /var/cache/apk/*

CMD ["sh"]
