#!/bin/sh

if [ -n "${GPG_PUB_KEYS}" ]; then
  for KEY in ${GPG_PUB_KEYS}; do
    gpg --keyserver hkps.pool.sks-keyservers.net --recv ${KEY};
  done
fi

if [ -n "${1}" ]; then
  ${1}
else
  sh /data/commands.sh
fi
