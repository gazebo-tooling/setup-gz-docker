#!/bin/bash
set -euxo pipefail

readonly GZ_DISTRO=$1
EXCLUDE_APT="libignition|libsdformat|python3-ignition"

apt-get update
apt-get install --no-install-recommends --quiet --yes \
    sudo

groupadd -r gzbuild
useradd --no-log-init --create-home -r -g gzbuild gzbuild
echo "gzbuild ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo 'Etc/UTC' > /etc/timezone

apt-get update

apt-get install --no-install-recommends --quiet --yes \
    curl gnupg2 locales lsb-release wget

export UBUNTU_VERSION=`lsb_release -cs`
locale-gen en_US en_US.UTF-8
export LANG=en_US.UTF-8

ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

apt-get install --no-install-recommends --quiet --yes tzdata

wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
echo  "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable $UBUNTU_VERSION main" > /etc/apt/sources.list.d/gazebo-stable.list

apt-get update

DEBIAN_FRONTEND=noninteractive \
apt-get install --no-install-recommends --quiet --yes \
  build-essential \
  clang \
  cmake \
  git \
  lcov \
  libasio-dev \
  libc++-dev \
  libc++abi-dev \
  libssl-dev \
  libtinyxml2-dev \
  python3-dev \
  python3-pip \
  python3-setuptools \
  python3-wheel

pip3 install --upgrade \
  argcomplete \
  catkin_pkg \
  colcon-common-extensions \
  coverage \
  cryptography \
  empy \
  flake8-blind-except \
  flake8-builtins \
  flake8-class-newline \
  flake8-comprehensions \
  flake8-deprecated \
  flake8-docstrings \
  flake8-import-order \
  flake8-quotes \
  ifcfg \
  lark-parser \
  mock \
  mypy \
  nose \
  pep8 \
  pydocstyle \
  pyparsing \
  pytest \
  pytest-cov \
  pytest-mock \
  pytest-repeat \
  pytest-rerunfailures \
  pytest-runner \
  setuptools \
  vcstool \
  wheel

if [ "$GZ_DISTRO" != "none" ]; then
  mkdir -p workspace/src
  cd workspace
  wget https://raw.githubusercontent.com/gazebo-tooling/gazebodistro/master/collection-$GZ_DISTRO.yaml
  vcs import src < collection-$GZ_DISTRO.yaml

  ALL_PACKAGES=$( \
    sort -u $(find . -iname 'packages-'$UBUNTU_VERSION'.apt' -o -iname 'packages.apt') | grep -Ev $EXCLUDE_APT | tr '\n' ' ')

  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends --quiet --yes \
    $ALL_PACKAGES

  cd .. && rm -rf workspace
fi

rm -rf "/var/lib/apt/lists/*"
