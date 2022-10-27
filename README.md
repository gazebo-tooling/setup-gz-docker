# setup-gz-docker

[![Build Docker image](https://github.com/gazebo-tooling/setup-gz-docker/workflows/Build%20Docker%20image/badge.svg)](https://github.com/gazebo-tooling/setup-gz-docker/actions?query=workflow%3A%22Build+Docker+image%22)

Repository to periodically build and upload docker containers for Gazebo dependencies.
Used to cache common binary dependencies to speed up Github Actions builds.

This currently uses Github Actions `on-schedule` to build hourly.


## Installed depdendencies

A set of base depdencies are installed for ease of CI/development use.
These include:
* build-essential + clang + cmake
* [`vcstool`](https://github.com/dirk-thomas/vcstool)
* [`colcon`](https://colcon.readthedocs.io/en/released/) 

As part of the build, this will fetch all package sources from a given [gazebodistro](https://github.com/gazebo-tooling/gazebodistro) collection file.
A collection is a yaml file intended to be used with [vcstool](https://github.com/dirk-thomas/vcstool).
An example of a collection is [Dome](https://github.com/gazebo-tooling/gazebodistro/blob/master/collection-dome.yaml).

It will then install dependencies from each package's `.github/ci/packages.apt` file.
A `packages.apt` file includes a list of binary `apt` depdencies, one per line.
An example `packages.apt` file is in [gz-common](https://github.com/gazebosim/gz-common/blob/ign-common3/.github/ci/packages.apt)


## Packages produced

The periodic action currently pushes successful containers to the [Github Container Registry](https://docs.github.com/en/free-pro-team@latest/packages/guides/about-github-container-registry)

The images currently produced are listed on the [gazebo-tooling packages index](https://github.com/orgs/gazebo-tooling/packages/container/package/gz-ubuntu).

These include:

* `ghcr.io/gazebo-tooling/gz-ubuntu:bionic` - Base bionic development image with no Gazebo-collection specific binaries
* `ghcr.io/gazebo-tooling/gz-ubuntu:focal` - Base focal development image with no Gazebo-collection specific binaries
* `ghcr.io/gazebo-tooling/gz-ubuntu:citadel-bionic` - Bionic image with Citadel dependencies 
* `ghcr.io/gazebo-tooling/gz-ubuntu:dome-focal` - Focal image with Dome dependencies 
* `ghcr.io/gazebo-tooling/gz-ubuntu:edifice-focal` - Focal image with Edifice dependencies 

