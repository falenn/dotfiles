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
  echo "Storage is not partitioned."

 -- partition it


# create parition volume
sudo /sbin/pvcreate -d /dev/"$DEV_NAME""1"

# display volume group
sudo vgdisplay

# create the volume group
sudo /sbin/vgcreate $VOLGROUPNAME /dev/"$DEV_NAME""1"

# scan for existing logical volumes
sudo lvscan

#create the logicalvolume in the group
sudo /sbin/lvcreate -l 100%VG $VOLGROUPNAME -n $VOLUMENAME

# display volume groups
sudo lvdisplay -v /dev/"$DEV_NAME""1"

# format logical volume
sudo /sbin/mkfs.ext4 /dev/$VOLGROUPNAME/$VOLUMENAME

# make mount location, a.k.a /data
mkdir -p $MOUNT_PATH

cat /etc/fstab | grep /dev/$VOLGROUPNAME/$VOLUMENAME
if [ $? -eq 1 ]; then
  # not in fstab.  write entry.  have to use spec thing for sudo into root-owned file
echo " /dev/$VOLGROUPNAME/$VOLUMENAME $MOUNT_NAME ext4 defaults 0 0"

sudo /bin/mount -a

#change perms so you can write to the storage
sudo chmod ugoa+rx $MOUNT_NAME

