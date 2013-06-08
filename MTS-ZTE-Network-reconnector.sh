#!/bin/bash
#Author : Srikanth.S
#Purpose : To automate the reconnecting of network connection for MTS connection
#	   when network fails, using ZTE usb modem. 	

#killall modem-manager;
#killall NetworkManager;
#service network-manager stop;
#sleep 5;
#service network-manager start;
#sleep 10;
#nmcli con up id MTS2


function checkconnection()
{
	echo "---> Checking for Internet Connectivity <---";
	notify-send "Checking the Internet";	
	ping -c 3 www.google.com
		    if [ $? == 0 ]; 
			then  
			echo "Wow, We got Internet, Exiting"; exit;
			/usr/bin/notify-send "We got Internet";
		    else 
			echo "No Connection YET.";
			echo ;
		    fi
}

function starthisnetwork()
{		
		echo;
		echo "---> Program Loop Started <---";
		
		checkconnection

		echo ;
		echo "---> First trying to connect to MTS2 without restarting NM <---"
		#nmcli con up id MTS2
		checkconnection
	
		echo "---> Waiting for three seconds <---";
		sleep 3;
		
		echo "---> Entering the Main infinite loop <---"
		a=0; while [ $a == 0 ]
		do
			checkconnection

			notify-send "Killing all NMs and restarting";
			echo "---> Killing all network processes and restarting NM <---";
			killall modem-manager;
			killall NetworkManager;
			service network-manager stop;
			sleep 5;
			service network-manager start;
			
			echo "---> Waiting for 33 seconds and later try connecting to MTS2  <---";
	      	        sleep 33;
			checkconnection
			echo "---> Connecting to MTS2 <--"
		        nmcli con up id MTS2;
			checkconnection

			nmcli con up id MTS2;
			if [ $? == 0 ]
				checkconnection
				then echo not yet enabled;
				sleep 10;		
				nmcli con up id MTS2;
				exit;
			else
				nmcli con up id MTS2; 
				echo "---> Checking for Internet Connectivity <---";
				ping -c 3 www.google.com
				    if [ $? == 0 ]; 
					then
		  			   echo "Wow, We got Internet, Exiting"; exit;
				        else 
					   starthisnetwork
	       		      	    fi
			fi     
		 done
}

starthisnetwork
