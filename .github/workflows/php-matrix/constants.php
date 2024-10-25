<?php

const PHP_LATEST = '8.3';

/*
* Don't include older builds because these are already build and not going to be updated from official repo
* If there is something changed in our Dockerfile and you want to build all versions then define it as follows:
* const PHP_VERSIONS = ['7.1', '7.2', '7.3', '7.4', '8.0', '8.1', '8.2'];
*/
const PHP_VERSIONS = ['7.1', '7.2', '7.3', '7.4', '8.0', '8.1', '8.2', '8.3'];
const PHP_VERSIONS_OS_RELEASE = [
    '7.1' => 'buster',
    '7.2' => 'buster',
    '7.3' => 'bullseye',
    '7.4' => 'bullseye',
    '8.0' => 'bullseye',
    '8.1' => 'bookworm',
    '8.2' => 'bookworm',
    '8.3' => 'bookworm'
];
const NODE_LATEST = '21';
const NODE_VERSIONS = ['14', '15', '16', '17', '18', '19', '20', '21', '22', '23'];
const NODE_VERSIONS_OS_RELEASE = [
    '14' => 'bullseye',
    '15' => 'buster',
    '16' => 'bullseye',
    '17' => 'bullseye',
    '18' => 'bullseye',
    '19' => 'bullseye',
    '20' => 'bookworm',
    '21' => 'bookworm',
];
const EXPERIMENTAL_PHP_VERSIONS = [];
const NOT_STABLE_XDEBUG_PHP_VERSIONS = ['7.0', '7.1', '7.2', '7.3', '7.4'];
