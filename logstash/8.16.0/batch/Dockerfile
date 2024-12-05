FROM logstash:8.16.0

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install \ 
    curl=8.11.0 \
    default-mysql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*