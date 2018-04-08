#!/bin/sh

set -e

echo "Starting vpn-server ..."

modprobe nf_conntrack_pptp \
    && modprobe nf_conntrack_proto_gre \
    && modprobe ppp_mppe \
    && modprobe ip_gre

# start logging
service rsyslog start
service pptpd start

# enable IP forwarding
service pptpconfig start

tail -f /var/log/syslog