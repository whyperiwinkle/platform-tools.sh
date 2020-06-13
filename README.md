# platform-tools.sh
Easy installation of adb and fastboot compatible with most popular Linux distributions.

# About
This is a bash script which pulls the latest version of Google's platform-tools direct from their repository, installs the binaries, and sets up the system for adb/fastboot functionality.  It can also be used to update to the latest version assuming it was used for initial installation.

Tested distributions include Fedora, RHEL, CentOS, Debian, and Ubuntu.  However, it should work on any Fedora-based or Debian-based system, so please let me know if it works for you on another distribution.

# How to use
**Note:** This script does not account for other installations, so any previous versions of adb/fastboot should be removed using your local package manager.

Packages 'wget' and 'unzip' are used in this script and it will error out if you don't have them.  They're typically part of the base install, but you may need to install them on some distros.

## Installing adb/fastboot
1. Download the repo zip file.
2. Extract to whichever directory you would like to save the script.
2. Navigate to the extracted repo directory.
3. Make the script executable.
4. Execute the script with root permissions.

Terminal example:
```
$ wget https://github.com/whyperiwinkle/platform-tools.sh/archive/master.zip
$ mkdir $HOME/Android
$ unzip master.zip -d $HOME/Android
$ cd $HOME/Android/platform-tools.sh-master
$ chmod +x platform-tools.sh
$ sudo ./platform-tools.sh
```

## 51-android.rules
### CAUTION
This script writes new udev rules to the 51-android.rules file located in the "/usr/lib/udev/rules.d/" directory.  If this file already exists, it will be overwritten.  If you have added rules to this file, it is strongly recommended you back it up.

### Adding your own rules
This script adds udev rules for all the most common Android device vendors, so if you have a common device, you shouldn't have to worry about this.  However, if you have an uncommon device, you can add it to the script.

Simply edit the script in your preferred text editor, locate the vendor array, and add your vendor id to the list using the same format.  The vendor array looks like this:
```
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
```

If you don't know your vendor id, you can find it using the 'lsusb' command.  It will look something like this:  
```
$ lsusb
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 004: ID 0a5c:4500 Broadcom Corp. BCM2046B1 USB 2.0 Hub (part of BCM2046 Bluetooth)
Bus 002 Device 005: ID 413c:8161 Dell Computer Corp. Integrated Keyboard
Bus 002 Device 006: ID 413c:8162 Dell Computer Corp. Integrated Touchpad [Synaptics]
Bus 002 Device 007: ID 413c:8160 Dell Computer Corp. Wireless 365 Bluetooth
```

The first four hex digits are the vendor id.  In this example, you can see that all the Dell devices share the vendor id of '413c'.  If your having trouble figuring out which device is your Android device, try disconnecting it, running the command, then reconnecting it and running the command again to see what changed.

# Contributions
Anyone is welcome to help improve the script in whatever way they feel most comfortable.  I would especially like for users to report any bugs they find or issues they run into.  Thanks!
