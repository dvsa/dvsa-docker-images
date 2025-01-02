#!/bin/sh
set -e

  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initialising cache..."
    echo ${SQUID_CACHE_DIR}
    squid -N -f /etc/squid/conf.d/squid.conf -z
  fi
  echo "Starting squid..."
  squid -NYC -f /etc/squid/conf.d/squid.conf