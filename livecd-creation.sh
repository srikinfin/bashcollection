#!/bin/bash
#Purpose : Creating livecd from current installed OS(ubuntu)
#Source : http://ubuntuforums.org/showthread.php?t=688872

/usr/bin/nofiy-send 'Live-CD creation started'

export WORK=~/work   #temporary workplace 
export CD=~/cd       #livecd location
export FORMAT=squashfs
export FS_DIR=casper


sudo mkdir -p ${CD}/{${FS_DIR},boot/grub} ${WORK}/rootfs

sudo apt-get update

sudo apt-get install grub2 xorriso squashfs-tools qemu

sudo rsync -av --one-file-system --exclude=/proc/* --exclude=/dev/* \
--exclude=/sys/* --exclude=/tmp/* --exclude=/home/* --exclude=/lost+found \
--exclude=/var/tmp/* --exclude=/boot/grub/* --exclude=/root/* \
--exclude=/var/mail/* --exclude=/var/spool/* --exclude=/media/* \
--exclude=/etc/fstab --exclude=/etc/mtab --exclude=/etc/hosts \
--exclude=/etc/timezone --exclude=/etc/shadow* --exclude=/etc/gshadow* \
--exclude=/etc/X11/xorg.conf* --exclude=/etc/gdm/custom.conf \
--exclude=/etc/lightdm/lightdm.conf --exclude=${WORK}/rootfs / ${WORK}/rootfs

CONFIG='.config .bashrc .vimrc'  # copies the .config and .bashrc .vimrc files of user

sudo mount  --bind /dev/ ${WORK}/rootfs/dev
sudo mount -t proc proc ${WORK}/rootfs/proc
sudo mount -t sysfs sysfs ${WORK}/rootfs/sys

sudo chroot ${WORK}/rootfs /bin/bash       # chrooting to new system
# execute below commands in chroot
 
LANG=

apt-get update
apt-get install casper lupin-casper 		# needed for taking care of scripts to initramfs
apt-get install ubiquity ubiquity-frontend-gtk  # the ubuntu live cd installer

# add extras softwares needed in livecd
apt-get install gparted ms-sys testdisk wipe partimage xfsprogs reiserfsprogs jfsutils ntfs-3g ntfsprogs dosfstools mtools
apt-get install vim vlc clementine xchm qbittorrent 


depmod -a $(uname -r)  # updating modules.dep
update-initramfs -u -k $(uname -r)

# removing non sytem users as to not conflict with creating livecd user which has uid preserved as 999 by standards
for i in `cat /etc/passwd | awk -F":" '{print $1}'`
do
	uid=`cat /etc/passwd | grep "^${i}:" | awk -F":" '{print $3}'`
	[ "$uid" -gt "998" -a  "$uid" -ne "65534"  ] && userdel --force ${i} 2>/dev/null
done

apt-get clean

#cleaning extra log files
find /var/log -regex '.*?[0-9].*?' -exec rm -v {} \;

#  The remaining log files are going to be zeroed lest the system complain if they are deleted.
find /var/log -type f | while read file
do
	cat /dev/null | tee $file
done

rm /etc/resolv.conf /etc/hostname


# exit chroot environment
exit

# 1. Copy the kernel, the updated initrd and memtest prepared in the chroot:
export kversion=`cd ${WORK}/rootfs/boot && ls -1 vmlinuz-* | tail -1 | sed 's@vmlinuz-@@'`
sudo cp -vp ${WORK}/rootfs/boot/vmlinuz-${kversion} ${CD}/${FS_DIR}/vmlinuz
sudo cp -vp ${WORK}/rootfs/boot/initrd.img-${kversion} ${CD}/${FS_DIR}/initrd.img
sudo cp -vp ${WORK}/rootfs/boot/memtest86+.bin ${CD}/boot

#2.Generate manifest -- needed if only installed the ubuntu livecd installer
sudo chroot ${WORK}/rootfs dpkg-query -W --showformat='${Package} ${Version}\n' | sudo tee ${CD}/${FS_DIR}/filesystem.manifest
sudo cp -v ${CD}/${FS_DIR}/filesystem.manifest{,-desktop}

# these will remove packages which are useful in only livecd

#REMOVE='ubiquity casper user-setup os-prober libdebian-installer4'
#for in $REMOVE 
#do
#	sudo sed -i "/${i}/d" ${CD}/${FS_DIR}/filesystem.manifest-desktop
#done


# 3. Unmount bind mounted dirs:
sudo umount ${WORK}/rootfs/proc
sudo umount ${WORK}/rootfs/sys
sudo umount ${WORK}/rootfs/dev

# 4. Convert the directory tree into a squashfs: make sure this can fit into CD or DVD or USB (your choice)
sudo mksquashfs ${WORK}/rootfs ${CD}/${FS_DIR}/filesystem.${FORMAT} -noappend

#Make filesystem.size
echo -n $(sudo du -s --block-size=1 ${WORK}/rootfs | tail -1 | awk '{print $1}') | sudo tee ${CD}/${FS_DIR}/filesystem.size

# Calculating MD5
find ${CD} -type f -print0 | xargs -0 md5sum | sed "s@${CD}@.@" | grep -v md5sum.txt | sudo tee -a ${CD}/md5sum.txt



# Creating the grub menu of the livecd

sudo cat > ${CD}/boot/grub/grub.cfg <<EOF
set default="0"
set timeout=10

menuentry "Ubuntu GUI" {
linux /casper/vmlinuz boot=casper quiet splash
initrd /casper/initrd.img
}


menuentry "Ubuntu in safe mode" {
linux /casper/vmlinuz boot=casper xforcevesa quiet splash
initrd /casper/initrd.img
}


menuentry "Ubuntu CLI" {
linux /casper/vmlinuz boot=casper textonly quiet splash
initrd /casper/initrd.img
}


menuentry "Ubuntu GUI persistent mode" {
linux /casper/vmlinuz boot=casper persistent quiet splash
initrd /casper/initrd.img
}


menuentry "Ubuntu GUI from RAM" {
linux /casper/vmlinuz boot=casper toram quiet splash
initrd /casper/initrd.img
}

menuentry "Check Disk for Defects" {
linux /casper/vmlinuz boot=casper integrity-check quiet splash
initrd /casper/initrd.img
}


menuentry "Memory Test" {
linux16 /boot/memtest86+.bin
}


menuentry "Boot from the first hard disk" {
set root=(hd0)
chainloader +1
}

EOF


#building the livecd ISO file
sudo grub-mkrescue -o ~/live-cd.iso ${CD}

/usr/bin/notify-send 'live cd Created at your home directory' 

#testing the live cd
#qemu -cdrom ~/live-cd.iso -boot d
