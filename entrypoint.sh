#!/bin/sh

set -e

# start logging
service rsyslog start
service pptpd start

# enable IP forwarding
service pptpconfig start

exec "$@"