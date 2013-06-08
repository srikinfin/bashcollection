#/bin/bash

set -x

whattime=`date +%H`

case $whattime in

02|03|04|05|06|07) 
		  /usr/bin/notify-send 'Good morning!!';
	      	  /usr/bin/notify-send 'Nice time to start downloads in your desktop' ;
#xterm -e 'cd /home/nova/Downloads; streamripper http://www.radioparadise.com/musiclinks/rp_128.m3u -o larger --with-id3v1 -u totem -r'&
#xterm -e 'cd /home/nova/Downloads; streamripper http://yp.shoutcast.com/sbin/tunein-station.pls?id=118870 -o larger --with-id3v1 -u totem -r'&
#xterm -e 'streamripper http://yp.shoutcast.com/sbin/tunein-station.pls?id=785235 -o larger --with-id3v1 -u totem -r'&
#qbittorrent&
		       	
		;;




08|09|10|11) /usr/bin/notify-send 'Good Morning!!';
	     
 	     progn=`zenity --entry --title="The Catapult" --text="Your Wish is My Command"`;
             nohup $progn;;




 		
12|13|14|15|16|17|18|19|20) 
		/usr/bin/notify-send "Good Afternoon!!";
		progn=`zenity --entry --title="The Catapult" --text="Your Wish is My Command"`;
		nohup $progn;;





21|22|23) /usr/bin/notify-send "Good Night !";
	  progn=`zenity --entry --title="The Catapult" --text="At your service"`;;
	  # /usr/bin/notify-send "Internet is free only between 02-08 A.M, Please use it with care,\
	  Thank you. " "The_Downloader";;
esac

exit




TODO: 
#- At 8.00am, check for current downloads with wget,qbittorrent,transmission,kget... and kill them.
#  
#
#

#if [ -f lockfile.lck ]; 
#  then /usr/bin/notify-send "delete the lockfile, and try again."; 
#	    
#	 else 
#	touch lockfile.lck;
#	  if [ ps -e | grep wget ] then exit 
#	   else	{
#  			/home/nova/The_Downloader/downloader.sh; 
#		}
#	  fi 
