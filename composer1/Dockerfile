ARG ENV_SOURCE_IMAGE=ghcr.io/disrex-group/gitlab-ci
ARG PHP_VERSION
ARG NODE_VERSION
ARG REGISTRY_BASE=ghcr.io/disrex-group/gitlab-ci-base-images

# Pull composer 1 image to copy from
FROM ${REGISTRY_BASE}/composer:1 AS composer1-source

# Start from our PHP + Node image
FROM ${ENV_SOURCE_IMAGE}:${PHP_VERSION}-node${NODE_VERSION}
USER root

RUN rm /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /root/.composer
COPY --from=composer1-source /usr/bin/composer /usr/bin/composer

RUN export PATH=$PATH:/usr/bin

