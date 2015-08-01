#!/usr/bin/env bash

# Requires bash, and you'll probably need git to get this :-)
PATH=${PATH}
echo "Make sure you add your clients (puppet agents) to the puppet.master"
echo "config file, located in ~etc/puppet/manifests/site.pp"
sleep 10
# Tested on Freebsd 10.1 and 10.2-BETA.
freebsd-installer() {
	cd installer
	bash freebsd-installer.sh
}

# Tested on CentOS 7.
linux-installer() {
	cd installer
	bash linux-installer.sh
}

# Determine OS as base system layout differs between FreeBSD and CentOS.  Not much
# logic here though.
if [ "`uname`" == "FreeBSD" ]; then
	echo "`uname` Detected."
	freebsd-installer
else
	echo "`uname` Detected."
	linux-installer
fi
exit 0
