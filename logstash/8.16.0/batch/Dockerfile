FROM logstash:8.16.0

LABEL version="1.0"
LABEL description="Dockerfile with logstash with Sinatra and MySQL client for VOL"

USER root

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
    curl=7.68.0-1ubuntu2.24 \
    default-mysql-client=1.0.5ubuntu2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    gem install sinatra

USER 1000