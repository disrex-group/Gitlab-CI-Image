ARG PHP_VERSION
ARG OS_RELEASE

FROM ${ENV_SOURCE_IMAGE:-php}:${PHP_VERSION}-cli-${OS_RELEASE:-bullseye}
USER root
ARG PHP_VERSION

# Similar issue with other node commands : https://github.com/ariya/phantomjs/issues/15449
ENV OPENSSL_CONF=/etc/ssl/

# Install helpful utilities
RUN set -eux; \
    mkdir -p /root/.composer; \
    apt-get update -y; \
    export OPENSSL_CONF=/etc/ssl/; \
    apt-get install -y --no-install-recommends \
    libicu-dev \
    libpng-dev \
    libzip-dev \
    rsync \
    openssh-client \
    zip \
    unzip \
    libmcrypt-dev \
    libxml2-dev \
    libxslt-dev \
    git \
    gnupg2 \
    fontconfig \
    libfontconfig1 \
    libfontconfig1-dev \
    libfontconfig \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libc6 \
    libcairo2 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    fonts-liberation \
    ca-certificates \
    libnss3 \
    lsb-release \
    xdg-utils \
    libgbm1 \
    libx11-xcb1 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    libasound2

# If PHP = 7.0 | debs are archived so use those
RUN if [ "${PHP_VERSION}" = "7.0" ]; \
    then printf "deb http://archive.debian.org/debian/ stretch main\ndeb-src http://archive.debian.org/debian/ stretch main" > /etc/apt/sources.list; \
    apt-get update -y; \
    apt-get install -y --no-install-recommends \
    python \
    python-pip; fi

# If PHP >= 7.1
RUN if [ "$(printf "7.1\n${PHP_VERSION}" | sort -g | head -n1 | awk -F"." '{print $1"."$2}')" = "7.1" ]; \
    then apt-get install -y --no-install-recommends python3 python3-pip python2; \
    if [ ! -f "/usr/bin/pip" ]; then ln -s /usr/bin/pip3 /usr/bin/pip; ln -s /usr/bin/python3 /usr/bin/python; fi; fi

# PHP Extension Installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install PHP Extensions required by Magento OS, Adobe Commerce, and the UCT (pcntl)
RUN chmod +x /usr/local/bin/install-php-extensions && install-php-extensions \
    apcu \
    amqp \
    bcmath \
    calendar \
    exif \
    ftp \
    gd \
    intl \
    imap \
    mysqli \
    pcntl \
    pdo_mysql \
    redis \
    soap \
    sockets \
    sodium \
    xsl \
    zip

# If PHP < 8.3 install imagick
RUN if [ "$(printf "8.3\n${PHP_VERSION}" | sort -g | head -n1)" != "8.3" ]; \
    then install-php-extensions imagick; fi

# If PHP < 8.2 install mcrypt
RUN if [ "$(printf "8.2\n${PHP_VERSION}" | sort -g | head -n1)" != "8.2" ]; \
    then install-php-extensions mcrypt; fi

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /root/.composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# clean up apt packages and temporary files
RUN set -eux; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists

RUN export PATH=$PATH:/usr/bin

