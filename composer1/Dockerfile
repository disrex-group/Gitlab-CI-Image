ARG ENV_SOURCE_IMAGE=ghcr.io/disrex-group/gitlab-ci
ARG PHP_VERSION
ARG NODE_VERSION
ARG REGISTRY_BASE=ghcr.io/disrex-group/gitlab-ci-base-images

FROM ${ENV_SOURCE_IMAGE}:${PHP_VERSION}-node${NODE_VERSION}
USER root

RUN rm /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /root/.composer
COPY --from=${REGISTRY_BASE}/composer:1 /usr/bin/composer /usr/bin/composer

RUN export PATH=$PATH:/usr/bin

