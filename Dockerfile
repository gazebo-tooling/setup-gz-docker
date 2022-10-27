# Base Linux distribution used to build the Docker image
#
# The script has been tested against:
# - ubuntu:bionic
# - ubuntu:focal
# - ubuntu:xenial
#
# Do not pass directly "X:Y" to BASE_IMAGE_NAME, only pass the image name.
# The version must be specified separately in BASE_IMAGE_TAG.
#
# This script will not work with non-APT based Linux distributions.
ARG BASE_IMAGE_NAME

# Base Linux distribution version (one of "bionic", "focal", "xenial")
ARG BASE_IMAGE_TAG

FROM "${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}"

# Commit ID this image is based upon
ARG VCS_REF

# The Ignition distribution being targeted by this image
ARG GZ_DISTRO

# Additional APT packages to be installed
ARG EXTRA_APT_PACKAGES

# See http://label-schema.org/rc1/ for label documentation
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="gazebo-tooling/setup-gz-docker"
LABEL org.label-schema.description="Gazebo GitHub Action CI base image"
LABEL org.label-schema.url="https://github.com/gazebo-tooling/setup-gz-docker"
LABEL org.label-schema.vcs-url="https://github.com/gazebo-tooling/setup-gz-docker.git"
LABEL org.label-schema.vcs-ref="${VCS_REF}"
LABEL org.label-schema.vendor="gazebosim.org"
LABEL org.opencontainers.image.source="https://github.com/gazebo-tooling/setup-gz-docker"

COPY setup-gz.sh /tmp/setup-gz.sh
RUN /tmp/setup-ign.sh "${GZ_DISTRO}" && rm -f /tmp/setup-gz.sh
ENV LANG en_US.UTF-8
RUN for i in $(echo ${EXTRA_APT_PACKAGES} | tr ',' ' '); do \
  apt-get install --yes --no-install-recommends "$i"; \
done
