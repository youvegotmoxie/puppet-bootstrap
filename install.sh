#!/bin/sh
PATH="${PATH}

pkg update
pkg install puppet
echo 'puppet_enable="YES"' >> /etc/rc.conf
echo 'puppet_flags="-v --listen --server fbsd-srv02.servebeer.info"

