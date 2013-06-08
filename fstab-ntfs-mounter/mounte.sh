#!/bin/bash
#Program name: Partition mounter to fstab
#Author	     : Srikanth.S
#Purpose     : Automatically adding partition entries one by one to /etc/fstab file
#	       so they are mounted on startup, without asking for password
#	       and enable applications to use partitions without giving
#	       file not found errors
		
echo 
echo " 	---- fstab mounter --- "
echo 

echo "Do you want to view you fstab file? (y/n)"
read yesorno
case $yesorno in
	y*|Y*) cat /etc/fstab ;;
	*);;
esac

echo
echo ' Backing up /etc/fstab ... '
cp /etc/fstab /etc/FSTAB.backup
echo ' Backed up /etc/fstab to /etc/FSTAB.backup '
echo 

blkid | grep LABEL| grep ntfs | cut -d ' ' -f 3 --complement  | sed 's/: LABEL="/ \/media\//g' | sed 's/" TYPE="ntfs"/ ntfs-3g defaults 0 0/g' > tmp

lines=$(wc -l tmp | cut -d ' ' -f 1)

echo 

for (( i=1; i<=lines; i++ )) 
do
 	echo `sed -n "$i p" tmp`
	echo "Do you want to add this to the fstab file ?"
	read yesorno
	case $yesorno in
	y*|Y*) sed -n "$i p" tmp >> /etc/fstab
			 echo ;;
        *)echo 
	  continue;;

        esac

echo
done

echo "Do you want to view you fstab file? (y/n)"
read yesorno
case $yesorno in
	y*|Y*) cat /etc/fstab ;;
	*);;
esac

# labelling a ext* partitions  -- sudo e2label /drive label
#http://tldp.org/HOWTO/html_single/Partition/


#current way -  ask whether to print the current fstab file
#		backs up /etc/fstab
#		searches for labelled ntfs partitions
#		computes all ntfs partitions to fstab
#		shows and asks every single entry to be added to fstab


#new way 1-	print the blkid 
#		ask which line to add to fstab - for ext2,3,4, ntfs,
#		ask mount points - sleep for 5 second - then add labels as mountpoints


#new way 2-	print all the partitions added (all types)
#		ask which to remove from them
#		again print all 		
