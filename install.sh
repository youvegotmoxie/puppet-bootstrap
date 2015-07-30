#!/bin/sh
PATH="${PATH}"

if [ `uname` == 'FreeBSD' ]; then
echo "`uname` detected"

puppet-install() {
	pkg update
	pkg install puppet
}

puppet-config() {
	echo 'puppet_enable="YES"' >> /etc/rc.conf
	echo 'puppet_flags="-v --listen --server fbsd-srv02.servebeer.info"' >> /etc/rc.conf
	cp ~/puppet-bootstrap/configs/freebsd/auth.conf /usr/local/etc/puppet/auth.conf
}

puppet-cert() {
	puppet agent -v --server fbsd-srv02.servebeer.info --waitforcert 60 --test
}

puppet-start() {
	service puppet start
}

#Only supporting CentOS currently

else
	echo "`uname` detected"
puppet-install() {
	rpm -ivh https://yum.puppetlabs.com/el/7/products/x86_64/puppetlabs-release-7-10.noarch.rpm
	yum install puppet
}
puppet-config() {
	echo 'PUPPET_SERVER=fbsd-srv02.servebeer.info' >> /etc/sysconfig/puppet
	cp ~/puppet-bootstrap/configs/linux/auth.conf /etc/puppet/auth.conf
	echo 'server=fbsd-srv02.servebeer.info' >> /etc/puppet/puppet.conf
}
puppet-cert() {
	puppet agent -v --server fbsd-srv02.servebeer.info --waitforcert 60 --test
}
puppet-start() {
	systemctl enable puppet
	systemctl start puppet
}
fi

if [ uid == 0 ]; then
	puppet-install
	puppet-config
	puppet-cert
	puppet-start
else
	echo "This script must be run as root."
fi
exit 0
