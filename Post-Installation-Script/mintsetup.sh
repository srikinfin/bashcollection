#!/bin/bash
########## packages and procedures needed for installing Linux Mint ##########

function installthis()
{
	echo
	echo '\\\\\\\\ installing $* ////////// '
	apt-get install -y --force-yes $*
}

function yesorno()
{
	echo '(y/n)?'
	read yesorno
	case $yesorno in
		[yY][eE][sS]) continue;;
		*) break ;;
	esac
}

function common_both()           #######        for both DMs              #######
{

# dictionary
installthis artha

# screen red tinter
installthis *redshift*

# network monitor cli
installthis nethogs

# multi paned terminal
installthis terminator

# web browser and accesorries
installthis firefox flashplayer elinks chromium-browser midori  qbittorrent 
installthis opera   # wrote in a new line bcoz not all repos would have this

# for journalling files and etc
installthis zeitgeist 

# for setting auto updating of time from servers
installthis ntp

# for  radio application
installthis  radiotray 

# locate command
installthis mlocate

# improved vi editor
installthis vim

# rip online radio stations
installthis streamripper 

# a gui application for installing packages
installthis packagekit

# to download subtitles of movies from internet
installthis subdownloader


# for installing windows applications (.exe) in linux like wordweb, microsoft office
installthis wine winetricks 

# an onscreen system monitor
installthis conky-all

#  office software
installthis libreoffice

# zip and rar
installthis p7zip zip unzip unrar

#  downloaders
installthis wget curl

#players
installthis vlc clementine smplayer banshee rhythmbox 

}


function kde_install()           #######        for kde only              #######
{

# full kde family packages
installthis kde-full 
installthis kdeartwork kdebindings kdeedu kdegames kdegraphics kdemultimedia kdenetwork kdepim kdeplasma-addons kdesdk kdetoys kdeutils kdewebdev
installthis kdeoffice 

# drop-down terminal
installthis yakuake

# media players
installthis smplayer kaffeine amarok clementine

common_both
}



function gnome_install()         ######        for gnome only             #######
{
echo '---- installing the apps common for both ----'
common_both

#previlged access to graphical applications
installthis gksu

#editing context(right-click) menu in file browser
installthis nautilus-actions

# web browsers, chat,
installthis xchat pidgin 

# etc and miscellaneous applications
installthis anjuta glade devhelp

# drop-down terminal
installthis guake

# gui partition tool
installthis gparted


}


function procedures()
{
# mounting partitions on fstab 

echo adding ntfs partitions to /etc/fstab
cp /etc/fstab  /etc/FSTAB
cat /etc/fstab
blkid | grep LABEL | cut -d ' ' -f 3 --complement  | sed 's/: LABEL="/ \/media\//g' | sed 's/" TYPE="ntfs"/ ntfs-3g defaults 0 0/g' >> /etc/fstab
cat /etc/fstab


# in gnome 3 shell, to reduce the title bar height, where value starts from 0 to increase or decrease the height
	# yesorno reducing title bar height
#   echo 'do you want to reduce the title bar height ?'
	#yesorno
 	# echo 'reduce title bar a bit smaller ?'
# 	 sed -i '/title_vertical_pad/s|value="[0-9]\{1,2\}"|value="4"|g' /usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml

# removing /media in exception path of locate command 
#( adding /media to the search path of locate command)
echo ' adding /media to locate command '
sed -i 's/\/media//g' /etc/updatedb.conf 
 echo 'updating the database of locate command -- updatedb'
updatedb

#adding repositories 
{	
	add-apt-repository -y ppa:me-davidsansome/clementine
}

echo '---- Assigning a Default icon theme ----'
echo ' This is the current index.theme file '
cat /usr/share/icons/default/index.theme;
mkdir -p  /usr/share/icons/default/
echo '[Icon Theme]' > /usr/share/icons/default/index.theme

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
	*) break ;;

esac
}



main()
{
echo 'What should i install ? 
Gnome?    Kde?    Both?    Procedures? 
  1        2        3          4

Type any above numbers  '
read whichone

case  $whichone in
	1) gnome_install;;
        2) kde_install;;
        3) gnome_install; kde_install;; 
	4) procedures;;
	
esac
}
main



#TODO :  implementing these by sed, echo, awk etc
#
#  
#
#
#
#
# 
#################    TODO  write functions for configuring installed applications like, modifying .conf file of clementine to hide last.fm, etc
# 
#
#####################################   EXTRA INFOs    #######################################
# 
#
#  install  software 	  				--->    apt-get install software     
#  searches for the software in internet repository     --->    aptitude search  software
#  searches for software in cache 			--->    apt-cache search software
#

#  changing the defaults display manager for a user 
#   edit the file  /var/lib/AccountService/users/username 
#	and edit the Xsession value
#
#
# Explanation 
#
#---> sed -i 's/\/media//g' /etc/updatedb.conf  <----
#
# What does this command do? 
#   deletes the string   /media from the file /etc/updatedb.conf
#
#    -i option does the substitution operation inside the file just instead of 
#     sending the output to screen
#    
#     the   g   inside means global substitution throught the file
#
#

