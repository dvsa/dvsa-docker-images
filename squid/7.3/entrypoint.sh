#!/bin/sh
set -e

# Use single brackets for BusyBox compatibility
if [ ! -d "${SQUID_CACHE_DIR}/00" ]; then
    echo "Initialising cache..."
    # Run initialization as a one-off
    squid -N -f /etc/squid/conf.d/squid.conf -z
fi

echo "Starting squid..."
# -N: No-daemon mode (required for Docker)
# -Y: Only use internal DNS if multiple are provided
# -C: Don't catch signals (let Docker handle them)
exec squid -NYC -f /etc/squid/conf.d/squid.conf