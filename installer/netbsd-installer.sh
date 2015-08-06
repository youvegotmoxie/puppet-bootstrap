#!/usr/bin/env bash

PATH=${PATH}
source installer/configs/global/install.conf

# Pkgin and pkgsrc required
puppet-install() {
	pkgin update
	pkgin install wget cvs

if [ -d "/usr/pkgsrc"]; then
    cd /usr/pkgsrc/sysutils/puppet
    # Fails here as NetBSD has port set to PKG_FAIL
    make install clean
else
    wget ftp://ftp.NetBSD.org/pub/pkgsrc/pkgsrc-2015Q2/pkgsrc.tar.gz
    gunzip pkgsrc.tar.gz && tar -xvf pkgsrc.tar -C /usr
    cd /usr/pkgsrc && env CVS_RSH=ssh cvs up -dP
    cd /usr/pkgsrc/sysutils/puppet
    # Fails here as NetBSD has port set to PKG_FAIL
    make install clean
fi

  cp /usr/pkg/share/examples/rc.d/puppetd /etc/rc.d/puppetd
  chmod 0755 /etc/rc.d/puppetd
}

puppet-config() {
	echo 'puppetd=YES' >> /etc/rc.conf
  echo 'puppetd_flags="agent --confdir /usr/pkg/etc/puppet --rundir /var/run"' >> /etc/rc.conf
	cp installer/configs/netbsd/auth.conf /usr/pkg/etc/puppet/auth.conf
  cp /usr/pkg/share/etc/puppet/puppet.conf /usr/pkg/etc/puppet/puppet.conf
}

puppet-cert() {
	echo ""
	echo "Check your puppet.master for a pending cert"
	echo ""
	puppet agent -v --server ${SERVER} --waitforcert ${TIMEOUT} --test
}

puppet-start() {
	/etc/rc.d/puppetd start
}

# Determine if root is running script.
if [ "$(id -u)" == "0" ]; then

	puppet-install
	puppet-config
	puppet-cert
	puppet-start

else
	echo "This script must be run as root."
fi
exit 0
