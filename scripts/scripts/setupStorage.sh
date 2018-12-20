#!/bin/bash

DEV_NAME=sdf
RESTART=n

# Display current block devices
function displayBlock() {
  sudo lsblk
}

# Parition device - don't change the carriage returns!!
# $1 device
# returns NA
function partitionDevice() {
  sudo -s /sbin/fdisk $1 <<< "n
p
1


t
83
w
"
}


# mount device
# $1 deviceName
# returns NA
function mountDevice() {
  sudo /bin/mount $1
}


OUT=`ls /dev | grep -e "$DEV_NAME"`
if [[ $? -eq 1 ]]; then
  if [ "$RESTART" == "y" ]; then
    echo "SCSI Dev not found.  restarting host..."
    sudo reboot now
  else
    echo "Searching for device in /dev/$DEV_NAME found nothing.  Check param and path.  You may have to reboot."
    exit 1
  fi
fi

echo "out: $OUT"

echo "Device exists. Continuing.."

sudo /bin/mount | grep -e "$MOUNT_NAME"
if [[ $? -eq 1 ]]; then
  echo "Storage is not partitioned.
