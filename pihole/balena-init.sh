#!/usr/bin/env bash

set -e

# avoid port conflicts with resin-dns
# https://docs.pi-hole.net/ftldns/interfaces/
mkdir -p /etc/dnsmasq.d
echo "bind-interfaces" >/etc/dnsmasq.d/90-resin-dns.conf
echo "except-interface=resin-dns" >>/etc/dnsmasq.d/90-resin-dns.conf
# remove deprecated dnsmasq config files if they exist
rm -f /etc/dnsmasq.d/balena.conf /etc/dnsmasq.d/01-pihole.conf

# Use EDNS_PACKET_MAX=1232 to avoid unbound DNS packet size warnings
# https://docs.pi-hole.net/guides/dns/unbound/
# https://docs.pi-hole.net/ftldns/dnsmasq_warn/#reducing-dns-packet-size-for-nameserver-address-to-safe_pktsz
if [[ ${EDNS_PACKET_MAX:-} =~ [0-9]+$ ]]; then
   echo "Reducing DNS packet size to ${EDNS_PACKET_MAX}..."
   echo "edns-packet-max=${EDNS_PACKET_MAX}" >/etc/dnsmasq.d/99-edns.conf
fi

# execute the Pi-hole entrypoint
exec /usr/bin/start.sh
