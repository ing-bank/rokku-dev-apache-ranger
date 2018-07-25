[![Build Status](https://travis-ci.org/nielsdenissen/ranger-for-gargoyle.svg?branch=master)](https://travis-ci.org/nielsdenissen/ranger-for-gargoyle)
[![](https://images.microbadger.com/badges/image/nielsdenissen/ranger-admin:master.svg)](https://microbadger.com/images/nielsdenissen/ranger-admin:master)(ranger-admin)
[![](https://images.microbadger.com/badges/image/nielsdenissen/ranger-postgres:master.svg)](https://microbadger.com/images/nielsdenissen/ranger-postgres:master)(ranger-postgres)


# Ranger for Gargoyle

*Based off the following GitHub repo: https://github.com/coheigea/testcases/tree/master/apache/docker/ranger*

This is a project for **TESTING** purposes. Currently the changes made to the default images listed above are:
- Add Ranger s3 plugin (see dependencies below)
- Add service definition/service/policy at runtime for s3
- Set logging of ranger service to debug (you can find the logs in the container here: `/opt/ranger-1.0.0-admin/ews/logs/ranger-admin-*-.log`)

## How to run

- Optional: `docker-compose build` (otherwise it will use the images available on docker-hub)
- `docker-compose up`

## Dependencies

- s3 plugin for Ranger: https://github.com/bolkedebruin/rangers3plugin.git

## TODO

- Create specific ResourceMatchers in ranger for buckets/pseudopaths/objects (currently we only support paths using the existing RangerPathResourceMatcher)
