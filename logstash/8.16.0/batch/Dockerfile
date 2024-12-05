FROM logstash:8.16.0

RUN apt-get -y --no-install-recommends install \ 
    curl=8.11.0 \
    default-mysql-client=1.0.7 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*