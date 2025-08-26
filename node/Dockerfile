ARG ENV_SOURCE_IMAGE=ghcr.io/disrex-group/gitlab-ci
ARG PHP_VERSION
ARG OS_RELEASE
ARG NODE_VERSION
ARG REGISTRY_BASE=ghcr.io/disrex-group/gitlab-ci-base-images

FROM ${REGISTRY_BASE}/node:${NODE_VERSION}-${OS_RELEASE:-bullseye} AS node
# Removed puppeteer due to npm 403 error - can be installed at runtime if needed
RUN npm install -g grunt-cli gulp requirejs terser uglify-js
RUN mv /opt/yarn* /opt/yarn

FROM ${ENV_SOURCE_IMAGE}:${PHP_VERSION}
USER root

# Copy Node to PHP
COPY --from=node /usr/local/include/node /usr/local/include/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /opt /opt
COPY --from=node /usr/local/bin/node /usr/local/bin/node

# Copy PhantomJS (try GHCR mirror first, fallback to Docker Hub)
COPY --from=ghcr.io/disrex-group/gitlab-ci-base-images/phantomjs:latest /build/phantomjs/bin/phantomjs /usr/local/bin/phantomjs 2>/dev/null || \
COPY --from=rollupdev/phantomjs:latest /build/phantomjs/bin/phantomjs /usr/local/bin/phantomjs 2>/dev/null || true

RUN ln -s /usr/local/bin/node /usr/local/bin/nodejs \
    && ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -s /usr/local/lib/node_modules/requirejs/bin/r.js /usr/local/bin/requirejs \
    && ln -s /usr/local/lib/node_modules/requirejs/bin/r.js /usr/local/bin/r.js \
    && ln -s /usr/local/lib/node_modules/terser/bin/terser /usr/local/bin/terser \
    && ln -s /usr/local/lib/node_modules/terser/bin/uglifyjs /usr/local/bin/uglifyjs \
    && ln -s /usr/local/lib/node_modules/gulp/bin/gulp.js /usr/local/bin/gulp \
    && ln -s /usr/local/lib/node_modules/grunt-cli/bin/grunt /usr/local/bin/grunt \
    && ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
    && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg

ENV PATH="${PATH}:/usr/local/lib/node_modules/bin"
ENV NODE_PATH="/usr/local/lib/node_modules"

# Note: Puppeteer removed due to npm 403 error
# Can be installed at runtime with: npm install puppeteer --no-save