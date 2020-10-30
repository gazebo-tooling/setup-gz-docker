#!/bin/bash
set -euxo pipefail

readonly IGN_DISTRO=$1

EXCLUDE_APT="libignition|libsdformat"

apt-get update
apt-get install --no-install-recommends --quiet --yes sudo

groupadd -r ignbuild
useradd --no-log-init --create-home -r -g ignbuild ignbuild
echo "ignbuild ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

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
	colcon-bash==0.4.2 \
	colcon-cd==0.1.1 \
	colcon-cmake==0.2.22 \
	colcon-common-extensions==0.2.1 \
	colcon-core==0.5.9 \
	colcon-defaults==0.2.5 \
	colcon-lcov-result==0.4.0 \
	colcon-library-path==0.2.1 \
	colcon-metadata==0.2.4 \
	colcon-mixin==0.1.8 \
	colcon-notification==0.2.13 \
	colcon-output==0.2.9 \
	colcon-package-information==0.3.3 \
	colcon-package-selection==0.2.6 \
	colcon-parallel-executor==0.2.4 \
	colcon-pkg-config==0.1.0 \
	colcon-powershell==0.3.6 \
	colcon-python-setup-py==0.2.5 \
	colcon-recursive-crawl==0.2.1 \
	colcon-ros==0.3.17 \
	colcon-test-result==0.3.8 \
	coverage \
	cryptography \
	empy \
	"flake8<3.8" \
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


if [ "$IGN_DISTRO" != "none" ]; then
  mkdir -p workspace/src
  cd workspace
  wget https://raw.githubusercontent.com/ignition-tooling/gazebodistro/master/collection-$IGN_DISTRO.yaml 
  vcs import src < collection-$IGN_DISTRO.yaml

  ALL_PACKAGES=$( \
    sort -u $(find . -iname 'packages-'$UBUNTU_VERSION'.apt' -o -iname 'packages.apt') | grep -Ev $EXCLUDE_APT | tr '\n' ' ')

  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends --quiet --yes \
    $ALL_PACKAGES

  cd .. && rm -rf workspace
fi

rm -rf "/var/lib/apt/lists/*"
