FROM alpine:3.21.0

ENV SQUID_VERSION=6.12-r0 \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_CONF_DIR=/etc/squid/conf.d \
    ENTRYPOINT=/usr/local/bin/entrypoint.sh \
    SQUID_USER=squid

LABEL title="squid-alpine"
LABEL version="1.0"
LABEL organisation="DVSA"
LABEL description="Builds Alpine Squid base image that does not include bespoke Squid.conf file. This file should be added to /etc/squid/conf.d/ directory"

# Copy required scripts. The squid-alpine.conf should be mounted to /etc/squid/conf.d/squid.conf at container runtime.
COPY entrypoint.sh ${ENTRYPOINT}

# Install Squid
RUN apk update \
 && apk --no-cache add squid=${SQUID_VERSION} \
# Create required directories and set permissions
 && mkdir -p ${SQUID_LOG_DIR} ${SQUID_CACHE_DIR} ${SQUID_CONF_DIR} \
 && chmod -R 755 ${SQUID_LOG_DIR} ${SQUID_CACHE_DIR} ${SQUID_CONF_DIR} ${ENTRYPOINT} \
 && chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR} ${SQUID_CACHE_DIR} ${SQUID_CONF_DIR} ${ENTRYPOINT} \
# Reference squid-alpine.conf in default squid.conf
 && sed -i '1s;^;include /etc/squid/conf.d/*.conf\n;' /etc/squid/squid.conf

# Set non root user
# When Squid is installed a user called squid is automatically created 
USER ${SQUID_USER}

EXPOSE 3128/tcp

# Cannot use entrypoint env var without flagging hadolint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]