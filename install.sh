#!/bin/sh
PATH="${PATH}"
pkg update
pkg install puppet
echo 'puppet_enable="YES"' >> /etc/rc.conf
echo 'puppet_flags="-v --listen --server fbsd-srv02.servebeer.info"' >> /etc/rc.conf
cp ~/puppet-bootstrap/configs/auth.conf /usr/local/etc/puppet/auth.conf
puppet agent -v --server fbsd-srv02.servebeer.info --waitforcert 60 --test
service puppet start
exit 0
