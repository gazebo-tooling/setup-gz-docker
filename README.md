# setup-ign-docker

[![Build Docker image](https://github.com/ignition-tooling/setup-ign-docker/workflows/Build%20Docker%20image/badge.svg)](https://github.com/ignition-tooling/setup-ign-docker/actions?query=workflow%3A%22Build+Docker+image%22)

Repository to periodically build and upload docker containers for Ignition dependencies.
Used to cache common binary dependencies to speed up Github Actions builds.

This currently uses Github Actions `on-schedule` to build hourly.


## Installed depdendencies

A set of base depdencies are installed for ease of CI/development use.
These include:
* build-essential + clang + cmake
* [`vcstool`](https://github.com/dirk-thomas/vcstool)
* [`colcon`](https://colcon.readthedocs.io/en/released/) 

As part of the build, this will fetch all package sources from a given [gazebodistro](https://github.com/ignition-tooling/gazebodistro) collection file.
A collection is a yaml file intended to be used with [vcstool](https://github.com/dirk-thomas/vcstool).
An example of a collection is [Ignition Dome](https://github.com/ignition-tooling/gazebodistro/blob/master/collection-dome.yaml).

It will then install dependencies from each package's `.github/ci/packages.apt` file.
A `packages.apt` file includes a list of binary `apt` depdencies, one per line.
An example `packages.apt` file is in [ign-common](https://github.com/ignitionrobotics/ign-common/blob/ign-common3/.github/ci/packages.apt)


## Packages produced

The periodic action currently pushes successful containers to the [Github Container Registry](https://docs.github.com/en/free-pro-team@latest/packages/guides/about-github-container-registry)

The images currently produced are listed on the [ignition-tooling packages index](https://github.com/orgs/ignition-tooling/packages/container/package/ign-ubuntu).

These include:

* `ghcr.io/ignition-tooling/ign-ubuntu:bionic` - Base bionic development image with no Ignition-distribution specific binaries
* `ghcr.io/ignition-tooling/ign-ubuntu:focal` - Base focal development image with no Ignition-distribution specific binaries
* `ghcr.io/ignition-tooling/ign-ubuntu:citadel-bionic` - Bionic image with Ignition Citadel dependencies 
* `ghcr.io/ignition-tooling/ign-ubuntu:dome-focal` - Focal image with Ignition Dome dependencies 
* `ghcr.io/ignition-tooling/ign-ubuntu:edifice-focal` - Focal image with Ignition Edifice dependencies 

