#!/bin/bash
# Installation script for adb and fastboot
# Uses Google repository and does NOT install a managed package
# Updates to latest version if originally installed with this script
# Required software: unzip wget
# Must be ran with root permissions

# Exit on errors
set -e

# Declare tested distros
tested=(
	'fedora'
	'rhel'
	'centos'
	'debian'
	'ubuntu'
	)

# Learn distro
distro=$(hostnamectl | grep 'Operating System')
distro=${distro,,} # Change to lower case

# Determine if distro is supported
support='no'
for x in ${tested[@]}
do
	if [[ "$distro" =~ .*"$x".* ]]; then
		support='yes'
		break
	fi
done

if [[ "$support" == "no" ]]; then
	echo
	echo "This distibution has not been tested and installation may result in unusual behavior."
	read -p "Are you sure you want to continue? [y/n]  " -n 1 -r
	echo
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
 		exit 1
 	else
 		echo
	fi
fi

# Check root permissions
if [[ "$EUID" -ne 0 ]]; then
	echo
	echo "Script must be ran with root permissions"
	echo
	exit
fi

# Declare common vendor IDs
vendor=(
	'18d1'
	'0bb4'
	'04e8'
	'22b8'
	'1004'
	'12d1'
	'0502'
	'0fce'
	'413c'
	'0486'
	)

# Install software, overwriting if it exists
wget -q https://dl.google.com/android/repository/platform-tools-latest-linux.zip -O /tmp/platform-tools-latest.zip
unzip -o -q /tmp/platform-tools-latest.zip -d /opt

# Create symlinks for adb and fastboot (unless updating)
if [[ ! -L /usr/local/bin/adb ]]; then
	ln -s /opt/platform-tools/adb /usr/local/bin/adb
fi

if [[ ! -L /usr/local/bin/fastboot ]]; then
	ln -s /opt/platform-tools/fastboot /usr/local/bin/fastboot
fi

# Remove current udev rules if they exist
if [[ -f /usr/lib/udev/rules.d/51-android.rules ]]; then
	rm /usr/lib/udev/rules.d/51-android.rules
fi

# Write new udev rules
# Always writing new rules ensures any added vendor IDs are included when updating
for id in ${vendor[@]}
do
	echo "SUBSYSTEM==\"usb\", ATTR{idVendor}==\"${id}\", TAG+=\"uaccess\""
done > /usr/lib/udev/rules.d/51-android.rules

# Update rule permissions	
chmod a+r /usr/lib/udev/rules.d/51-android.rules

# Reload device rules
udevadm control --reload-rules
udevadm trigger

# Cleanup tmp files
rm /tmp/platform-tools-latest.zip

# Let user know it worked (hopefully)
echo
echo "SUCCESS!"
echo

exit
