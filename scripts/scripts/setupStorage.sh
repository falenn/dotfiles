#!/bin/bash

MPL="dev_"
VGL="_vg"
LVL="_lv"
RESTART="n"
DEV_NAME=""
MOUNT_NAME="/data"
MOUNTWOS="data"
HOST=""
USERNAME=$USER

while getopts ":h:m:n:rd" opt;
do 
  case $opt in
	h)
		HOST="$OPTARG"
		;;
	m)
		if [ "$OPTARG" == "" ]; then
			echo "Cannot pas in a null value for the mount name.  Exiting"
			exit 1
		else
			MOUNT_NAME="$OPTARG"
			MOUNTWOS=`echo "$MOUNT_NAME" | cut -d "/" -f 2`
			echo "MOUNT name: $MOUNT_NAME, $MOUNTWOS"
		fi
		;;
	n)
		if [ "$OPTARG" == "" ]; then
			echo "Cannot pass in a null value for the device name.  Exiting"
			exit 1
		else
			DEV_NAME="$OPTARG"
			echo "Device name: $DEV_NAME"
		fi
		;;
	r)
		RESTART="y"
		;;
	d)
		DEBUG=1
		;;
	?)
		echo "Usage: -m <mount name> -n <device name> -r <reboot if needed>"
		;;
	*)
		;;
  esac
done

if [ "$HOST" == "" ]; then
	HOST=`hostname`
fi

#dsiplay current block devices
sudo lsblk

OUT=`ls /dev | grep -e "$DEV_NAME"`
if [[ $? -eq 1 ]]; then
	if [[ "$RESTART" == "y" ]]; then
		echo "SCSI LUN Mount '/dev/$DEV_NAME' not found - rebooting to hopefully export the mount"
		sudo reboot now
	else
		echo "Searching for devie '/dev/$DEV_NAME' turned up nothing"
	fi
else
	echo "/dev/$DEV_NAME exists..."
	echo "checking to see if partitioned..."
	/bin/mount | grep -e "$MOUNT_NAME"
	if [[ $? -eq 1 ]]; then
		echo "storage is currently not partitioned."
		MP="$DEV_NAME""1"

		sudo fdisk -l /dev/$MP
		
		echo "Searching for device /dev/$MP.."
		OUT=`ls /dev | grep -e "$MP"`
		if [ ! $? -eq 0 ]; then
			echo "Device /dev/$MP not found.  Creating partition."
			echo "Running fdisk."
#
# Do not alter input below!
#
			sudo -s /sbin/fdisk /dev/$DEV_NAME <<< "n
p
1

t
8e
w
"
#
# Done with input
#
			echo "Device and primary partition /dev/$MP does exist"
		fi
		
		# Create the partition volume
		echo "Running pvcreate to initialize primary partition for use by LVM"
		sudo /sbin/pvcreate -d /dev/$MP

		# Display exising volume groups
		sudo /sbin/pvdisplay

		# Create the volume group
		echo "Running vgcreate to create volume group"
		sudo /sbin/vgcreate $MPL$MOUNTWOS$VGL /dev/$MP

		sudo /sbin/vgdisplay

		# Existing logical volumes
		sudo /sbin/lvscan
	
		# creat the logical volume in the group
		sudo /sbin/lvcreate -l 100%VG $MPL$MOUNTWOS$VGL -n $MPL$MOUNTWOS$LVL

		# display the new volume group
		sudo /sbin/lvdisplay -v /dev/$MP

		# format the logical volume
		echo "Running mkfs.ext4..."
		sudo /sbin/mkfs.ext4 /dev/$MPL$MOUNTWOS$VGL/$MPL$MOUNTWOS$LVL

		# Make the dir for the mount location
		if [[ ! -e "$MOUNT_NAME" ]]; then
			echo "Making the mount dir: $MOUNT_NAME"
			sudo /bin/mkdir -p $MOUNT_NAME
		fi

		# Add the mount to /etc/fstab so mount is automatic
		ADD_STRING="/dev/$MPL$MOUNTWOS$VGL/$MPL$MOUNTWOS$LVL $MOUNT_NAME ext4 defaults 0 0"
		echo "Add the following to /etc/fstab as root"
		echo "$ADD_STRING"

		sleep 5

		sudo /bin/mount -t ext4 /dev/$MPL$MOUNTWOS$VGL/$MPL$MOUNTWOS$LVL $MOUNT_NAME

		echo "Show mounts"
		df 	
		
		sudo chown $USERNAME: $MOUNT_NAME
	fi
fi

