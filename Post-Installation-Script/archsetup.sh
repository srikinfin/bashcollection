#!/bin/bash
########## packages and procedures needed for installing Arch Linux ##########

function installthis()
{
	pacman -S --noconfirm --needed $*
}

function base_install()
{

# needed to get the sytem running 
echo starting install_ xorg -server -xinit -utils -server-utils
installthis xorg xterm xorg-server xorg-xinit xorg-utils xorg-server-utils 

# video drivers related 
installthis mesa mesa-demos xf86-video-intel 

# required for both Display Manager(gnome and kde) 
installthis dbus

# the ' at ' command scheduling command 
installthis at 

# sudo command
installthis sudo
}


function common_both()           #######        for both DMs              #######
{

# to get the network applet on tray
installthis networkmanager

# a multipaned terminal
installthis terminator

# web browser and accesorries
installthis firefox flashplayer elinks chromium midori deluge
installthis opera   

# for journalling files and etc
installthis zeitgeist 

# for setting auto updating of time from servers
installthis ntp

# for compiling things from AUR
installthis base-devel

# for entrying ntfs drives in fstab, a radio application
installthis ntfs-3g 
installthis  radiotray 

# locate command
installthis mlocate

# improved vi editor
installthis vim
# mp3 and video codecs
installthis gstreamer0.10 gstreamer0.10-plugins
installthis gstreamer0.10-base gstreamer0.10-base-plugins
installthis gstreamer0.10-bad  gstreamer0.10-bad-plugins
installthis gstreamer0.10-good gstreamer0.10-good-plugins
installthis gstreamer0.10-ugly gstreamer0.10-ugly-plugins
installthis gstreamer0.10-ffmpeg
installthis gstreamer0.10-python
installthis phonon-gstreamer

# rip online radio stations
installthis streamripper 

# a gui application for installing packages
installthis packagekit

# to download subtitles of movies from internet
installthis subdownloader


# for installing windows applications (.exe) in linux like wordweb, microsoft office
installthis wine 

# onscreen system monitor
installthis conky-all

#  office software
installthis libreoffice

# zip and rar
installthis p7zip zip unzip unrar

# downloaders
installthis wget curl transmission-gtk geoip

#players
installthis vlc clementine smplayer banshee rhythmbox 

}


function kde_install()           #######        for kde only              #######
{

# full kde family packages
installthis -y kde-meta kdebase kdeadmin
installthis -y kdeartwork kdebindings kdeedu kdegames kdegraphics kdemultimedia kdenetwork kdepim kdeplasma-addons kdesdk kdetoys kdeutils kdewebdev
installthis kdeoffice 

# for gtk applications like xchat pidgin, to have cleaner look in kde environment 
installthis archlinux-themes-kdm oxygen-gtk gtk-kde4 gtk-chtheme gtk-theme-switch2 chakra-gtk-config
installthis  lxappearance   

# drop-down terminal
installthis yakuake

# media players
installthis smplayer kaffeine amarok clementine

#internet
installthis transmission-qt

common_both
}



function gnome_install()         ######        for gnome only             #######
{

#previlged access to graphical applications
installthis gksu

# gnome family packages
installthis gnome gnome-extra 

# web browsers, chat,
installthis xchat pidgin 

# etc and miscellaneous applications
installthis anjuta glade devhelp qbittorrent 

# drop-down terminal
installthis guake

# gui partition tool
installthis gparted

common_both
}

function procedures()
{
# mounting partitions on fstab
cp /etc/fstab  cp /etc/FSTAB
blkid | grep LABEL | cut -d ' ' -f 3 --complement  | sed 's/: LABEL="/ \/media\//g' | sed 's/" TYPE="ntfs"/ ntfs-3g defaults 0 0/g' >> /etc/fstab

# in gnome 3 shell, to reduce the title bar height, where value starts from 0 to increase or decrease the height
sed -i '/title_vertical_pad/s|value="[0-9]\{1,2\}"|value="4"|g' /usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml

# making default cursor to gnome adwaita
mkdir /usr/share/icons/default/
echo '[Icon Theme]' >> /usr/share/icons/default/index.theme
echo 'Inherits=Adwaita' >> /usr/share/icons/default/index.theme

# removing /media in exception path of locate command 
#( adding /media to the search path of locate command)
echo ' adding /media to locate command '
sed -i 's/\/media//g' /etc/updatedb.conf 
echo ' updating database with /media '
updatedb  # updating the database of locate command

}


base_install
gnome_install





#TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO
#
#  add  atd dbus network bluetooth networkmanager alsa ----> in the DAEMONS(....) line of /etc/skel/.xinitrc
#  
#
# changing the default runlevel  AND Display manager  in /etc/inittab
#
# function finddistro()
# {
#   dist=$(cat /etc/issue | cut -d ' ' -f 1 )
#
#	if [ "$dist" == "Arch" ]   pacman -S --needed -y *
#       if [ "$dist" == "Ubuntu" ] apt-get -y install * 
# }
#
#
################################## EXTRA Packages to install from AUR (Arch User Repository) ######################################
##################################                                                           ######################################
#-------------------------->                                                                 <------------------------------------#
#-------------------------->                                                                 <------------------------------------#
#-------------------------->                          artha apper                            <------------------------------------#
#-------------------------->                                                                 <------------------------------------#
#-------------------------->                                                                 <------------------------------------#
#
#
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
#  install  software 	  				--->    pacman -S    software     
#  searches for the software in repository		--->    pacman -Ss  software
#  installs software from website url of local files	--->    pacman -U   url/path
#  lists all files installed by packages 		--->    pacman -Q1  package 
#  detailed info of package 				--->    pacman -Si  package 
#  search all installed packages in system 		--->    pacman -Qs  package 
#  install packages from an local directory             --->    pacman -S   package --cachedir /directory
#  to find which package a command belongs to		--->    pacman -Qo  command




#  atd daemon is for ' at ' command 
