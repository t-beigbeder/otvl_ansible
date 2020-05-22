#!/bin/sh

# otvl_apt_subs.sh
# substitute for ansible apt module
# that cannot be used from a virtualenv (python3-apt not in pip repository)

export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
apt-get update && \
  apt-get install -yqq --no-install-recommends \
  $* && \
  true || \
  exit 1
