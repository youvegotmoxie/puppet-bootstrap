#!/usr/bin/env bash

# Requires bash, and you'll probably need git to get this :-)
PATH=${PATH}

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
