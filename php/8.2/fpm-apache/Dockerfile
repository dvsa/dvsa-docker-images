FROM php:8.2-fpm-alpine3.24

# hadolint ignore=DL3018
RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache \
        python3 \
        py3-pip \
        jq \
        openrc \
        apache2 \
        apache2-ctl \
        build-base \
        apache2-proxy \
    && pip install --no-cache-dir --break-system-packages --upgrade "wheel>=0.46.2" "jaraco-context>=6.1.0" \
    && find /usr -name "wheel-*.dist-info" ! -name "wheel-0.46.2.dist-info" -type d -exec rm -rf {} + \
    && find /usr -name "jaraco*context-*.dist-info" ! -name "*6.1.0*" -type d -exec rm -rf {} + \
    && rm -rf /usr/lib/python*/site-packages/wheel-0.45.1.dist-info \
    && apk del -f php82-apache2 build-base py3-pip || true \
    && rm -rf /var/cache/apk/*

# TEMPORARY: rebuild PHP from source with the 2026-10-21 security release until the
# upstream php:8.2-*-alpine3.24 image ships it (docker-library/php#1694). It reuses the
# base image's own configure flags, and is a no-op once the base is already at or past
# PHP_HOTFIX_VERSION. Remove this block once upstream catches up.
ARG PHP_HOTFIX_VERSION=8.2.35
ARG PHP_HOTFIX_SHA256=5737b98601fe5ab1b8c5db0c82ed3158acb9283ed3081ffe2faffb9ac81455e6

# hadolint ignore=DL3003,DL3018,DL4006,SC2086
RUN set -eux; \
    if php -r 'exit(version_compare(PHP_VERSION, getenv("PHP_HOTFIX_VERSION"), ">=") ? 0 : 1);'; then \
        echo "PHP $(php -r 'echo PHP_VERSION;') >= ${PHP_HOTFIX_VERSION}, skipping rebuild"; \
        exit 0; \
    fi; \
    configureOptions="$(php-config --configure-options | tr ' ' '\n' | grep '^--')"; \
    apk add --no-cache --virtual .hotfix-deps \
        $PHPIZE_DEPS \
        argon2-dev \
        coreutils \
        curl-dev \
        gnu-libiconv-dev \
        gnupg \
        libsodium-dev \
        libxml2-dev \
        linux-headers \
        oniguruma-dev \
        openssl-dev \
        readline-dev \
        sqlite-dev; \
    cd /usr/src; \
    curl -fsSL -o php.tar.xz "https://www.php.net/distributions/php-${PHP_HOTFIX_VERSION}.tar.xz"; \
    curl -fsSL -o php.tar.xz.asc "https://www.php.net/distributions/php-${PHP_HOTFIX_VERSION}.tar.xz.asc"; \
    echo "${PHP_HOTFIX_SHA256} *php.tar.xz" | sha256sum -c -; \
    GNUPGHOME="$(mktemp -d)"; \
    export GNUPGHOME; \
    for key in $GPG_KEYS; do \
        gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
    done; \
    gpg --batch --verify php.tar.xz.asc php.tar.xz; \
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME"; \
    rm -vf /usr/include/iconv.h; \
    export \
        CFLAGS="$PHP_CFLAGS" \
        CPPFLAGS="$PHP_CPPFLAGS" \
        LDFLAGS="$PHP_LDFLAGS" \
        PHP_BUILD_PROVIDER='https://github.com/docker-library/php' \
        PHP_UNAME='Linux - Docker'; \
    docker-php-source extract; \
    cd /usr/src/php; \
    ./configure $configureOptions; \
    make -j "$(nproc)"; \
    find . -type f -name '*.a' -delete; \
    make install; \
    find /usr/local -type f -perm '/0111' -exec sh -euxc 'strip --strip-all "$@" || :' -- '{}' +; \
    make clean; \
    cp -v php.ini-* "$PHP_INI_DIR/"; \
    cd /; \
    docker-php-source delete; \
    apk del --no-network .hotfix-deps; \
    php --version | grep -F "PHP ${PHP_HOTFIX_VERSION} "

# (Default Virtual Host is created with Apache install)
# Disable prefork and enable event
RUN sed -ri -e 's!^LoadModule mpm_prefork_module modules/mod_mpm_prefork.so!#LoadModule mpm_prefork_module modules/mod_mpm_prefork.so!g' /etc/apache2/httpd.conf && \
    sed -ri -e 's!^#LoadModule mpm_event_module modules/mod_mpm_event.so!LoadModule mpm_event_module modules/mod_mpm_event.so!g' /etc/apache2/httpd.conf && \
    sed -ri -e 's!^#LoadModule expires_module modules/mod_expires.so!LoadModule expires_module modules/mod_expires.so!g' /etc/apache2/httpd.conf && \
    sed -ri -e 's!^#LoadModule rewrite_module modules/mod_rewrite.so!LoadModule rewrite_module modules/mod_rewrite.so!g' /etc/apache2/httpd.conf

# Copy Apache FPM proxy config
COPY ./php-fpm-proxy.conf /etc/apache2/conf.d/php-fpm-proxy.conf

# Apache Config file
COPY ./httpd-sysconfig /etc/sysconfig/httpd

# Apache service start script
COPY httpd-foreground /usr/local/bin/

RUN chmod +x /usr/local/bin/httpd-foreground
