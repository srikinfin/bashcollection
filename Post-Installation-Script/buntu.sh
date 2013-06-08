#!/bin/bash
#Author	     : Srikanth.S
#Purpose     : Post Os installation script to add prefered programs and tweaks.
#Contact     : Srikanth9infinity@gmail.com

function installthis()
{
	echo
	echo ---------- installing $* ---------- 
	apt-get install -y --force-yes $*
}

function common_both()           #######        for both DMs              #######
{


# restricted installs
#installthis ubuntu-restricted-extras
#installthis cabextract gstreamer0.10-plugins-bad-multiverse libavcodec-extra-53 libavutil-extra-51 libfaac0  libmjpegtools-1.9 libopenjpeg2 libquicktime unrar

#command -line installer with search option
installthis aptitude

# html ebook reader
installthis xchm

# tweaker
installthis ubuntu-tweak

# a dock
installthis docky avant-window-navigator gnome-do

# dictionary
installthis artha

# screen red tinter
installthis redshift

# network monitor cli
installthis nethogs

# multi paned terminal
installthis terminator

# web browser and accesorries
installthis firefox elinks midori lynx
installthis chromium-browser 
installthis opera   # wrote in a new line because not its repo does not work always 

# for setting auto updating of time from servers
installthis ntp

# for internet radio application
installthis  radiotray 

# locate command
installthis mlocate

# improved vi editor
installthis vim 

# mp3 and video codecs
#installthis gstreamer0.10 gstreamer0.10-plugins
#installthis gstreamer0.10-base gstreamer0.10-base-plugins
#installthis gstreamer0.10-bad  gstreamer0.10-bad-plugins
#installthis gstreamer0.10-good gstreamer0.10-good-plugins
#installthis gstreamer0.10-ugly gstreamer0.10-ugly-plugins
#installthis gstreamer0.10-ffmpeg
#installthis gstreamer0.10-python



# rip online radio stations
installthis streamripper 

# a gui application for installing packages
installthis packagekit

# to download subtitles of movies from internet
installthis subdownloader

# an onscreen system monitor
installthis conky-all

#  office software
installthis libreoffice

# zip and rar opener and codecs
installthis p7zip zip unzip unrar

# downloaders
installthis wget curl

#players
installthis vlc subdownloader
installthis clementine smplayer banshee rhythmbox mplayer

#tinkering automation key manipulation
installthis xdotool
installthis xbindkeys
installthis xbindkeys-*
installthis xvkbd
installthis dosbox

echo ' ---- installing lineakd ---- '
#wget http://ftp.us.debian.org/debian/pool/main/l/lineakd/lineakd_0.9-6_i386.deb
#sudo dpkg -i lineakd_0.9-6_i386.deb

# for installing windows applications (.exe) in linux like wordweb, microsoft office
installthis wine    
installthis winetricks
installthis wisotool
installthis wine-gecko


#development
 echo;
 echo " ---> Installing Development Tools <--- "   
installthis openjdk-7-jdk;
installthis netbeans;
installthis eclipse-jdt;
installthis idle;
installthis git-all;
installthis ipython python-wxtools;

      
}


function kde_install()           #######        for kde only              #######
{
common_both

# full kde family packages
installthis kde-full 
# installthis kdeartwork kdebindings kdeedu kdegames kdegraphics kdemultimedia kdenetwork kdepim kdeplasma-addons kdesdk kdetoys kdeutils kdewebdev
installthis kdeoffice 

# drop-down terminal
installthis yakuake

# media players
installthis smplayer kaffeine amarok 


}



function gnome_install()         ######        for gnome only             #######
{

common_both

installthis gnome-tweak-tool

# a quick search to application launcher
installthis gnome-do

#previlged access to graphical applications
installthis gksu

#editing context(right-click) menu in file browser
installthis nautilus-actions nautilus-open-terminal

# web browsers, chat,
installthis xchat pidgin 

# etc and miscellaneous applications
installthis  qbittorrent 

# drop-down terminal
installthis guake

# gui partition tool
installthis gparted

#virtual guest os testing...
installthis virtualbox 
installthis virtualbox-guest-additions

#development tools
echo 'install development tools ?'
read yesorno
case $yesorno in

	y|Y)    installthis gnome-platform-devel gnome-devel 
		installthis devel;
		installthis ipython python-wxtools;
		installthis git-all;
#web development
installthis apache2 libapache2-mod-perl2 mysql-server libapache2-mod-php5
		 
		installthis anjuta glade devhelp ;
	        installthis qt4-designer;
	        installthis openjdk-7-jdk;
	        installthis eclipse-jdt;;
	  *) ;;
esac 

}

function repos()
{



#adding repositories 
echo
echo ' ---- adding clementine repository ---- '
add-apt-repository ppa:me-davidsansome/clementine --yes
echo

echo 
echo ' --- adding sunflower filemanager repository --- '
sudo add-apt-repository ppa:atareao/sunflower  --yes
echo

echo
echo ' ---- adding ubuntu-tweak repository ---- '
sudo add-apt-repository ppa:tualatrix/ppa --yes
echo

#echo
#echo ' ---- adding opera repository ---- '
#wget -O - http://deb.opera.com/archive.key | sudo apt-key add -
#echo "deb http://deb.opera.com/opera etch non-free" | sudo tee -a /etc/apt/sources.list.d/opera.list 
#echo

#echo
#echo ' ---- adding remastersys repository ---- '
#wget -O - http://www.remastersys.com/ubuntu/remastersys.gpg.key | apt-key add -
#echo "deb http://www.remastersys.com/ubuntu precise main" | sudo tee -a /etc/sources.list.d/remastersys.list 
#echo

echo 'Update repository ?'
read yesorno
case $yesorno in

	y|Y) sudo apt-get update;;
	*);;
esac

}

function procedures()
{

#enabling atheros ethernet driver

echo 'install ethernet driver?' [y/n]
read yesorno
case $yesorno in

y|Y)
mkdir /media/TheDrive/;
mount /dev/sda5/ /media/TheDrive/;
cd /media/TheDrive/Linux_softwares/;
cp compat-wireless-3.5.1-1-snpc.tar.bz2 /tmp/;
cd /tmp;
tar -xvf compat-wireless-3.5.1-1-snpc.tar.bz2;
cd compat-wireless-3.5.1-1-snpc;
./scripts/driver-select alx;
make;
make install;
modprobe alx;;

*);;

esac

# mounting partitions on fstab 
echo 'mount partitions?' [y/n]
read yesorno
case $yesorno in

	y|Y) #cp /etc/fstab  /etc/fstab.BACKUP ;
#blkid | grep LABEL | grep ntfs | cut -d ' ' -f 3 --complement  | sed 's/: LABEL="/ \/media\//g' | sed 's/" TYPE="ntfs"/ ntfs-3g defaults 0 0/g' >> /etc/fstab

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
;;
	*);;
esac


echo 'Enable autologin? [y/n]'
read yesorno
case $yesorno in
        y*|Y*)echo "---- Enabling autologin for user=$usersname ----" ;

usersname=`ls /home/`
nofusers=`ls /home/ |wc -w `

case $nofusers in
        1) echo "autologin-user=$usersname" ;
           echo;
           echo 'autologin-user-timeout=0' ;;
        *) break ;;
esac

esac


echo
echo 'Fix laptop brightness in /etc/default and update grub? [y/n] '
read yesorno 
case $yesorno in 
    y*|Y*)echo '---- Fixing laptop brightness and updating grub ---- '
    sed -i 's/splash/splash acpi_backlight=vendor/'  /etc/default/grub
    echo 'Entry modified'
    echo
    cp /boot/grub/grub.cfg /boot/grub.BACKUP
    echo
    echo 'Backed up /boot/grub/grub.cfg to /boot/grub/grub.BACKUP'

    grub-mkconfig -o /boot/grub/grub.cfg
    echo
    echo '/boot/grub/grub.cfg updated'
    echo 'please restart for changes to work'
    echo

esac

# disable guest user


echo
echo '---- Disabling Guest User ---- '
echo 'allow-guest=false' >> /etc/lightdm/lightdm.conf



# removing /media in exception path of locate command 
#( adding /media to the search path of locate command)
echo
echo 'add /media/ to locate ? '
read whichone

case $whichone in
    1)	echo ' adding /media to locate command '
	sed -i 's/\/media//g' /etc/updatedb.conf 
	echo ' updating database with /media ' 
	updatedb ;; # updating the database of locate command
    *) ;;
 esac
 
 
echo " Which should be the default icon theme ?
Adwaita ==== 1 *
Macbuntu --- 2 
DMZ-White -- 3 
DMZ-Black -- 4 
Don't change anything--- 5"
read whichone

case    $whichone in

	1) echo '[Inherits]=Adwaita' >> /usr/share/icons/default/index.theme ;;
	2) echo '[Inherits]=Macbuntu-Cursors' >> /usr/share/icons/default/index.theme ;;
	3) echo '[Inherits]=DMZ-White' >> /usr/share/icons/default/index.theme ;;
	4) echo '[Inherits]=DMZ-Black' >> /usr/share/icons/default/index.theme ;;

	*) ;;

esac
 
}



#Enable hibernate

#sudo pm-hibernate command when we want to hibernate.

#You can also enable the hibernate option in the menus. To do that, use your favorite text editor to create /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla. Add the following to the file and save:

echo
echo '----> Enabling Hibernate by default <----'

sudo touch /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
echo "[Re-enable hibernate by default]
Identity=unix-user:*
Action=org.freedesktop.upower.hibernate
ResultActive=yes" > /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla








echo 'What should i install ? 
Gnome?    Kde?    Add repos?    Procedures?  Exit 
  1        2        3          4         5
  *
Type any above numbers  '
read whichone

case  $whichone in
 	2) kde_install;;
        3) repos ;; 
	4) procedures;;
	5) exit ;;
	*) gnome_install;;
esac


#TODO :  implementing these by sed, echo, awk etc
#
# adding dvorak keyboard layout
# assigning scroll lock to switch two layouts
# enabling guake/yakuake to autostart


#
# 
#################    TODO  write functions for configuring installed applications like, modifying .conf file of clementine to hide last.fm, etc
# 
#
#  changing the defaults display manager for a user 
#   edit the file  /var/lib/AccountService/users/username 
#	and edit the Xsession value
#
#
#####################################   EXTRA INFOs    #######################################
# 
#
#  install  software 	  				--->    apt-get install software     
#  searches for the software in repository		--->    aptitude search  software
#  getting a software/file info				--->    apt-cache showpkg software
