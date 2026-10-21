FROM php:8.4-cli-alpine3.24

RUN apk update --no-cache \
    && apk upgrade --no-cache

# TEMPORARY: rebuild PHP from source with the 2026-10-21 security release until the
# upstream php:8.4-*-alpine3.24 image ships it (docker-library/php#1694). It reuses the
# base image's own configure flags, and is a no-op once the base is already at or past
# PHP_HOTFIX_VERSION. Remove this block once upstream catches up.
ARG PHP_HOTFIX_VERSION=8.4.27
ARG PHP_HOTFIX_SHA256=dcf93923b0e38e0d5252b25b796520b5a47761a08b3488b6d0b5d1115764d3f0

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

# Copy the PHP production configuration.
RUN cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini" \
    && chown www-data "${PHP_INI_DIR}/php.ini"

# Copy the configuration files.
COPY php.ini ${PHP_INI_DIR}/conf.d/zzz-dvsa-base.ini

USER www-data
