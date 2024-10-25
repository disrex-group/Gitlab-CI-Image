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
- GD
- Intl
- Imagick
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
- Puppeteer
- RequireJS (r.js)
- Terser
- UglifyJS

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

## Updating PHP and Node.js Versions in CI Workflows

### Introduction

Our CI workflows are configured to support multiple versions of PHP and Node.js. To ensure flexibility and up-to-date testing environments, these versions can be updated or extended as needed.

### File Location

The versions are defined in the `constants.php` file located at `.github/workflows/php-matrix/constants.php`.

### Editing Instructions

1. **Open `constants.php`**: Locate and open the `constants.php` file in your preferred code editor.

2. **Update PHP Versions**:
    - **Add New PHP Versions**: Append new versions to the `PHP_VERSIONS` array.
    - **Update Latest PHP Version**: Modify `PHP_LATEST` if adding a newer version.
    - **Specify OS Release**: Add the corresponding OS release for the new PHP version in `PHP_VERSIONS_OS_RELEASE`.

3. **Update Node.js Versions**:
    - **Add New Node.js Versions**: Append new versions to the `NODE_VERSIONS` array.
    - **Update Latest Node.js Version**: Adjust `NODE_LATEST` if adding a newer version.
    - **Specify OS Release**: Add the corresponding OS release for the new Node.js version in `NODE_VERSIONS_OS_RELEASE`.

4. **Handle Experimental/Non-Stable Versions**: For experimental or unstable versions, especially for PHP, add them to `EXPERIMENTAL_PHP_VERSIONS` or `NOT_STABLE_XDEBUG_PHP_VERSIONS`.

5. **Save and Commit**: After editing, save the file, commit, and push your changes to the repository.

6. **Test Your Changes**: Ensure GitHub Actions workflows function correctly with the new versions.

7. **Documentation**: Update any related documentation to reflect the new supported versions.

### Example

Here is an example of how to add PHP 8.3 and Node.js 22:

```php
<?php

const PHP_LATEST = '8.3';
const PHP_VERSIONS = ['7.1', '7.2', '7.3', '7.4', '8.0', '8.1', '8.2', '8.3'];
const PHP_VERSIONS_OS_RELEASE = [
    // existing entries
    '8.3' => 'bookworm', // Replace with the correct OS release for PHP 8.3
];

const NODE_LATEST = '22';
const NODE_VERSIONS = ['10', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22'];
const NODE_VERSIONS_OS_RELEASE = [
    // existing entries
    '22' => 'bookworm', // Replace with the correct OS release for Node.js 22
];

const EXPERIMENTAL_PHP_VERSIONS = [];
const NOT_STABLE_XDEBUG_PHP_VERSIONS = ['7.0', '7.1', '7.2', '7.3', '7.4'];
```

### Note

When adding new versions, ensure the corresponding OS release is accurate. These releases are key for the correct functioning of the CI workflows.

Please note that this image is specifically tailored for GitLab CI usage and may not work as expected outside of the GitLab CI environment.

I hope this helps! Let me know if you have any further questions.
