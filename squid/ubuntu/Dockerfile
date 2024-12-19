FROM ubuntu:plucky-20241124

ENV SQUID_VERSION=6.10-1ubuntu1 \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_USER=squid

RUN groupadd -r ${SQUID_USER} && useradd -r -g ${SQUID_USER} ${SQUID_USER}

#Setup non root user
#USER ${SQUID_USER}

RUN apt-get update \
 && apt-get install -y squid=${SQUID_VERSION}* \
 && rm -rf /var/lib/apt/lists/*

#Combine with RUN task above to optimise layer or use entry point bash script 
RUN mkdir -p ${SQUID_LOG_DIR} \
 && chmod -R 755 ${SQUID_LOG_DIR} \
 && chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR} \
 && mkdir -p ${SQUID_CACHE_DIR} \ 
 && chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR}

# RUN which squid

EXPOSE 3128/tcp

#CMD [ "/usr/local/squid/sbin/squid" ]
CMD [ "/usr/sbin/squid" ]