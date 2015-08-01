#!/usr/bin/env bash

# Change to sh for FreeBSD unless shells/bash is already installed.
if which bash &> /dev/null; then
	echo "Bash Detected."
else
	echo "Please change identifier to sh."
fi

PATH=${PATH}

# Define puppet.master.
source configs/global/install.conf

# FreebBSD.
if [ `uname` == 'FreeBSD' ]; then
	echo "`uname` detected"

# Pkgng format only.
puppet-install() {
	pkg update
	pkg install puppet
}

puppet-config() {
	echo 'puppet_enable="YES"' >> /etc/rc.conf
	echo 'puppet_flags="-v --listen --server ${SERVER}"' >> /etc/rc.conf
	cp configs/freebsd/auth.conf /usr/local/etc/puppet/auth.conf
}

puppet-cert() {
	puppet agent -v --server ${SERVER} --waitforcert 60 --test
}

puppet-start() {
	service puppet start
}

# Only supporting CentOS 7 currently.

else

	echo "`uname` detected"

puppet-install() {
	rpm -ivh https://yum.puppetlabs.com/el/7/products/x86_64/puppetlabs-release-7-10.noarch.rpm
	yum install puppet
}
puppet-config() {
	echo 'PUPPET_SERVER=${SERVER}' >> /etc/sysconfig/puppet
	cp configs/linux/auth.conf /etc/puppet/auth.conf
	echo 'server=${SERVER}' >> /etc/puppet/puppet.conf
}
puppet-cert() {
	puppet agent -v --server ${SERVER} --waitforcert 60 --test
}
puppet-start() {
	systemctl enable puppet
	systemctl start puppet
}
fi

if [ "$(id -u)" != "0" ]; then

	puppet-install
	puppet-config
	puppet-cert
	puppet-start

else
	echo "This script must be run as root."
fi
exit 0