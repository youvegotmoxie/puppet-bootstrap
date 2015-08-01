#!/bin/sh
PATH=${PATH}

# Tested on Freebsd 10.1 and 10.2-BETA.
freebsd-installer() {
	sh installer/freebsd-installer.sh
}

# Tested on CentOS 7.
linux-installer() {
	sh installer/linux-installer.sh
}

# Determine OS as base system layout differs between FreeBSD and CentOS.  Not much
# logic here though.
if ["`uname`" == "FreeBSD"]; then
	echo "`uname` Detected."
	freebsd-installer
else
	echo "`uname` Detected."
	linux-installer
fi
exit 0
