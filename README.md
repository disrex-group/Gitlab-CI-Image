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

**Note about Puppeteer**: Due to npm 403 errors, Puppeteer is no longer pre-installed. 
If you need Puppeteer in your CI pipeline, install it at runtime:
```bash
npm install puppeteer --no-save
```

To use this image, you can specify the image tag in your  `.gitlab-ci.yml`  file. Here's an example:

## Using this Docker Image in GitLab CI

Images are published to GitHub Container Registry (GHCR). To use them in your `.gitlab-ci.yml`:

### Composer 2 (Default)
```yaml
image: ghcr.io/disrex-group/gitlab-ci:<tag>
```

### Composer 1
```yaml
image: ghcr.io/disrex-group/gitlab-ci-composer1:<tag>
```

### Available Tags

- `latest` - Latest PHP version without Node.js
- `latest-nodelatest` - Latest PHP + latest Node.js
- `8.4` - PHP 8.4 without Node.js
- `8.4-node22` - PHP 8.4 + Node.js 22
- `8.3-node20` - PHP 8.3 + Node.js 20
- `7.4-node14` - PHP 7.4 + Node.js 14
- And many more combinations...

All PHP versions from 7.4 to 8.x and Node versions from 14+ are automatically built.

**Note**: PHP 7.1-7.3 are no longer supported as they reached end-of-life and use archived Debian Buster repositories.

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

## Build Architecture & Automation

The CI/CD pipeline has been fully optimized for automatic version discovery and rate limit avoidance:

### 🚀 Key Features

- **Auto-discovery**: Automatically detects new PHP/Node versions from Docker Hub using `crane`
- **GHCR Mirroring**: All base images mirrored to GitHub Container Registry to avoid Docker Hub rate limits
- **Multi-arch Support**: Builds for both `linux/amd64` and `linux/arm64`
- **Zero Configuration**: New PHP/Node versions are automatically detected and built
- **Smart Caching**: Reuses base images and leverages GitHub Actions cache

### 📅 Workflow Schedule & Build Strategy

1. **Weekly Mirror** (`mirror-base-images.yml`)
   - Runs every Sunday at 1 AM UTC
   - Discovers and mirrors new PHP/Node/Composer images from Docker Hub to GHCR
   - Avoids Docker Hub rate limits for builds

2. **Build and Publish** (`build-and-publish.yml`)
   - **Weekly Full Build**: Every Monday at 3 AM UTC (after mirror)
   - **Automatic Trigger**: After mirror workflow completes
   - **Push to Master**: Builds latest versions only
   - **Manual Dispatch**: Three build modes available:
     - `latest-only`: Build only the latest PHP and last 2 Node versions
     - `full`: Build all available PHP and Node combinations
     - `custom`: Specify exact PHP and Node versions to build

### 🏗️ Build Architecture

The workflow uses GitHub matrix strategy with three parallel job types:
- **Base Images**: PHP images without Node.js (one per PHP version)
- **Node Variants**: PHP + Node.js combinations (PHP versions × Node versions)
- **Composer1 Legacy**: PHP + Node.js images with Composer v1 (PHP × Node versions)

**Smart Build Optimization**: The workflow automatically checks for existing images in the registry and skips rebuilding them unless:
- Force rebuild checkbox is selected in manual workflow dispatch
- Triggered by weekly schedule, mirror completion, or push to master
- Image doesn't exist in the registry yet

### 🔄 How Auto-Discovery Works

1. **Version Detection**: Crane scans Docker Hub for PHP 7.4-8.x and Node 14+ versions
2. **Smart OS Selection**: Automatically determines the correct base OS:
   - PHP 7.4: Debian Bullseye  
   - PHP 8.0: Debian Bullseye
   - PHP 8.1+: Debian Bookworm
3. **Automatic Builds**: New versions trigger builds without manual intervention
4. **No Manual Updates**: PHP 8.5, Node 24, etc. will be automatically added when released!


### Manual Build Trigger

You can manually trigger builds via GitHub Actions:

1. Go to Actions → "Build and Publish Images"
2. Click "Run workflow"
3. Select build type:
   - **latest-only**: Quick build of newest versions
   - **full**: Build all PHP/Node combinations
   - **custom**: Specify versions (e.g., PHP: "8.3,8.4" Node: "20,22")
4. Optional force rebuild checkboxes:
   - **Force rebuild base images**: Rebuild even if they exist in registry
   - **Force rebuild node images**: Rebuild even if they exist in registry
   - **Force rebuild composer1 images**: Rebuild even if they exist in registry
5. Click "Run workflow"

The build system automatically handles:
- Dependency ordering (base images → node variants → composer1)
- Parallel builds within each job type
- Multi-architecture support (amd64 + arm64)
- Intelligent caching and layer reuse

I hope this helps! Let me know if you have any further questions.
