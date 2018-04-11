#!/bin/sh

set -e

echo "Starting vpn-server ..."

modprobe nf_conntrack_pptp \
    && modprobe nf_conntrack_proto_gre \
    && modprobe ppp_mppe \
    && modprobe ip_gre

# enable configuration service
service pptp-config start
/etc/init.d/radius-config start

# start logging
service rsyslog start
service pptpd start
service freeradius restart

tail -f /var/log/syslog