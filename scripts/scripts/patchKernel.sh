

Update kernel
https://phoenixnap.com/kb/how-to-upgrade-kernel-centos

If grub2-efi.cfg, then is host booted in UEFI mode?
https://askubuntu.com/questions/992606/difference-between-grub2-for-efi-and-grub2-in-bootloader

See if /sys/firmare/efi exists
https://askubuntu.com/questions/162564/how-can-i-tell-if-my-system-was-booted-as-efi-uefi-or-bios

if does!



Select and boot kernel
https://www.thegeekdiary.com/centos-rhel-7-change-default-kernel-boot-with-old-kernel/

Fix repos
https://unix.stackexchange.com/questions/52666/how-do-i-install-the-stock-centos-repositories

yum clean all

yum update -y

yum -y install yum-plugin-fastestmirror

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum repolist
yum --enablerepo=elrepo-kernel install kernel-ml
yum repolist all

sudo awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg

sudo grub2-set-default 0
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
 sudo reboot


If stalled, 
yum-complete-transaction --cleanup-only


Remove old kernels
yum install yum-utils
package-cleanup --oldkernels
