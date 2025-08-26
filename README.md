# Gitlab Ci Pipeline Image With and Without NodeJS

This Docker image is designed to be used in GitLab CI pipelines. It contains the necessary tools and dependencies for building and testing your project.

This Docker image contains:

- PHP
- Composer
- Node.js
- NPM
- Yarn
- PhantomJS

It has the following PHP extensions installed:

- APCu
- AMQP
- BCMath
- Calendar
- Exif
- FTP
- GD
- Intl
- Imagick (for PHP < 8.3)
- IMAP
- MySQLi
- PCNTL
- PDO MySQL
- Redis
- SOAP
- Sockets
- Sodium
- XSL
- ZIP
- Mcrypt (for PHP < 8.2)

The following Node modules are preinstalled with this image:
- Gulp
- Grunt CLI
- RequireJS (r.js)
- Terser
- UglifyJS
- n (Node.js version manager - allows switching Node versions with `switch-node <version>`)

**Note about Puppeteer**: Due to npm 403 errors, Puppeteer is no longer pre-installed. 
If you need Puppeteer in your CI pipeline, install it at runtime:
```bash
npm install puppeteer --no-save
```

To use this image, you can specify the image tag in your  `.gitlab-ci.yml`  file. Here's an example:

## Using this Docker Image in GitLab CI

### Determining Node.js Version

If you are uncertain about the Node.js version used for generating packages:
- **Check `package-lock.json`**: Look for the `"@types/node"` package in your `package-lock.json`. This can give you an indication of the Node.js version used.
- **If Absent in `package-lock.json`**: Check the `.env.roll` local stack configuration for the Node.js version.
- **Default Assumption**: If neither is present, it's likely Node.js 14 was used, as this was the only version installed in the old GitLab CI image.

### Composer 2
image: `disrex/gitlab-ci:<tag>`
Replace  `<tag>`  with the desired version of the image. The available tags are:

-  `latest` : This tag includes latest PHP version without Node.js
-  `latest-nodelatest` : This tag includes latest PHP version and latest Node.js version available
-  `7.4` : This tag includes PHP 7.4 without Node.js
-  `7.4-node10` : This tag includes PHP 7.4 + Node.js version 10.x
-  `8.1-node14` : This tag includes PHP 8.1 + Node.js version 14.x

### Composer 1
image: `disrex/gitlab-ci-composer1:<tag>`
Replace  `<tag>`  with the desired version of the image. The available tags are:

-  `latest` : This tag includes latest PHP version without Node.js
-  `latest-nodelatest` : This tag includes latest PHP version and latest Node.js version available
-  `7.4` : This tag includes PHP 7.4 without Node.js
-  `7.4-node10` : This tag includes PHP 7.4 + Node.js version 10.x
-  `8.1-node14` : This tag includes PHP 8.1 + Node.js version 14.x

Choose the appropriate tag based on your project's requirements. If you're not sure which tag to use, you can start with  `latest`  as it includes the latest versions of Node.js and Composer.

In your GitLab CI pipeline, you can then run commands using the tools available in the image. For example:
```yaml
stages:
  - build

build:
  stage: build
  script:
    - composer install
    - yarn install
    - grunt watch
```
This example shows a simple build stage that runs Composer install, Yarn install, and Grunt watch commands.

Remember to adjust the commands according to your project's needs.

## Automatic Version Updates

The CI/CD pipeline automatically discovers and builds new PHP and Node.js versions as they are released on Docker Hub. There's no need to manually update configuration files.

### How It Works

- **Daily Discovery**: The pipeline checks Docker Hub daily for new versions
- **Automatic Detection**: When PHP 8.5 or Node 24 is released, it's automatically detected
- **Smart OS Selection**: Automatically determines the correct OS base (buster/bullseye/bookworm)
- **Zero Configuration**: No manual intervention required

### Manual Override

If you need to build specific versions, you can trigger the workflow manually:
1. Go to Actions → "Build Docker Images"
2. Click "Run workflow"
3. Optionally specify PHP/Node versions (comma-separated)
4. Click "Run workflow"

Please note that this image is specifically tailored for GitLab CI usage and may not work as expected outside of the GitLab CI environment.

## Build Optimization & Auto-Discovery

The build process has been optimized to:
- **Auto-discover new PHP/Node versions** from Docker Hub using crane
- **Mirror base images to GHCR** to avoid Docker Hub rate limits
- **Build PHP base images once** and reuse them for Node.js variants
- **Smart builds** - only rebuild when new versions are detected
- Use the `n` package for Node.js version management
- Remove puppeteer from base installation (can be installed at runtime)
- Improve build caching with GitHub Actions cache

### How Auto-Discovery Works

1. **Daily scans** - The workflow runs daily to check Docker Hub for new PHP/Node versions
2. **Automatic mirroring** - New base images are automatically mirrored to GHCR
3. **Smart rebuilds** - Only builds images when new versions are detected
4. **No manual updates** - No need to manually update version lists when PHP 8.5 or Node 24 releases!

### Switching Node.js Versions

Images with Node.js include the `n` version manager. You can switch Node versions at runtime:
```bash
# Check current version
switch-node

# Switch to a different version
switch-node 20
switch-node 16.20.0
```

### Building Images

Images are automatically built via GitHub Actions when:
- Code is pushed to the `master` branch
- A pull request is created (builds minimal set for testing)
- Scheduled monthly builds (full build of all combinations)
- Manual workflow dispatch (can choose full or minimal build)

For feature branches, builds are skipped by default to save resources. Use the "Run workflow" button in GitHub Actions to manually trigger a build if needed.

I hope this helps! Let me know if you have any further questions.
