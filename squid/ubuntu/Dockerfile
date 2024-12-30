FROM ubuntu:plucky-20241124

ENV SQUID_VERSION=6.10-1ubuntu1 \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_USER=proxy 

# Install squid    
RUN apt-get update \
 && apt-get install -y squid=${SQUID_VERSION} \
 && rm -rf /var/lib/apt/lists/*

# Create required directories and set permissions
RUN mkdir -p ${SQUID_LOG_DIR} \
 && chmod -R 720 ${SQUID_LOG_DIR} \
 && chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR} \
 && mkdir -p ${SQUID_CACHE_DIR} \ 
 && chmod -R 720 ${SQUID_CACHE_DIR} \
 && chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR}

# Initialise squid cache
RUN squid -N -f /etc/squid/squid.conf -z

# Set non root user
# A user called proxy is automatically created when installing squid
USER ${SQUID_USER}

EXPOSE 3128/tcp

CMD ["squid", "-NYC", "-f", "/etc/squid/squid.conf"]