ARG ENV_SOURCE_IMAGE
ARG PHP_VERSION

FROM ${ENV_SOURCE_IMAGE}:${PHP_VERSION}
USER root

RUN rm /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /root/.composer
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer

RUN export PATH=$PATH:/usr/bin

