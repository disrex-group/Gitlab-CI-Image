ARG ENV_SOURCE_IMAGE=ghcr.io/disrex-group/gitlab-ci
ARG PHP_VERSION
ARG NODE_VERSION
ARG REGISTRY_BASE=ghcr.io/disrex-group/gitlab-ci-base-images

# Determine OS release based on Node version
FROM ${REGISTRY_BASE}/node:${NODE_VERSION}-bullseye AS node-source
# Install global packages (puppeteer removed due to npm 403)
RUN npm install -g grunt-cli gulp requirejs terser uglify-js && \
    mv /opt/yarn* /opt/yarn

# Start from our PHP base image
FROM ${ENV_SOURCE_IMAGE}:${PHP_VERSION}
USER root

# Copy Node.js and npm from node source
COPY --from=node-source /usr/local/include/node /usr/local/include/node
COPY --from=node-source /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node-source /opt /opt
COPY --from=node-source /usr/local/bin/node /usr/local/bin/node

# Create symlinks for all Node tools
RUN ln -s /usr/local/bin/node /usr/local/bin/nodejs && \
    ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm && \
    ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx && \
    ln -s /usr/local/lib/node_modules/requirejs/bin/r.js /usr/local/bin/requirejs && \
    ln -s /usr/local/lib/node_modules/requirejs/bin/r.js /usr/local/bin/r.js && \
    ln -s /usr/local/lib/node_modules/terser/bin/terser /usr/local/bin/terser && \
    ln -s /usr/local/lib/node_modules/uglify-js/bin/uglifyjs /usr/local/bin/uglifyjs && \
    ln -s /usr/local/lib/node_modules/gulp/bin/gulp.js /usr/local/bin/gulp && \
    ln -s /usr/local/lib/node_modules/grunt-cli/bin/grunt /usr/local/bin/grunt && \
    ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn && \
    ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg

ENV PATH="${PATH}:/usr/local/lib/node_modules/.bin"
ENV NODE_PATH="/usr/local/lib/node_modules"

# Note: Puppeteer removed due to npm 403 error
# Install at runtime with: npm install puppeteer --no-save