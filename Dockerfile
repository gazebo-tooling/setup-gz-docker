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

# The ROS distribution being targeted by this image
ARG IGN_DISTRO

# Additional APT packages to be installed
#
# This is used to build Docker images incorporating various ROS, or ROS 2
# distributions. E.g. "ros-melodic-desktop ros-eloquent-desktop"
ARG EXTRA_APT_PACKAGES

# See http://label-schema.org/rc1/ for label documentation
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="ignition-tooling/setup-ign-docker"
LABEL org.label-schema.description="IGN GitHub Action CI base image"
LABEL org.label-schema.url="https://github.com/ignition-tooling/setup-ign-docker"
LABEL org.label-schema.vcs-url="https://github.com/ignition-tooling/setup-ign-docker.git"
LABEL org.label-schema.vcs-ref="${VCS_REF}"
LABEL org.label-schema.vendor="IgnitionRobotics.org"

COPY setup-ign.sh /tmp/setup-ign.sh
RUN /tmp/setup-ign.sh "${IGN_DISTRO}" && rm -f /tmp/setup-ign.sh
ENV LANG en_US.UTF-8
RUN for i in $(echo ${EXTRA_APT_PACKAGES} | tr ',' ' '); do \
        apt-get install --yes --no-install-recommends "$i"; \
    done
USER ignbuild
