FROM logstash:8.16.0

USER root

RUN apt-get -y --no-install-recommends install \ 
    curl=7.68.0 \
    default-mysql-client=1.0.5 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

  USER 1000