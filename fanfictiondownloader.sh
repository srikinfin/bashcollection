#!/bin/bash
# Convert Fanction.net stories to text format, send them to connected memory card.

set -x

echo $1 | grep www > /dev/null 
# check whether given is desktop website url

if  [ $? -eq 0 ] ; then  
#Converts desktop version to mobile version of website 
{
	url=`echo $1  | cut -d '/' --complement -f 7 | sed 's/www/m/g'`
	echo $url
}
fi


	if [ -e file.htm ]; then
		mv file.htm filebac.htm
		echo file.htm found,  backed up as filebac.htm
		echo 
	fi

echo $url	
curl $url > file.htm 
# save the webpage offline

fname=`grep '<center><b>' file.htm | head -1 | cut -d '>' -f 6 | tr -d '</b>' | sed 's/ /-/g'`
#find the story name by parsing the downloaded web page

totalchap=`grep 'var chs' file.htm | head -1 | tr -d 'var chs =' | tr -d '\t' | tr -d ';'`
#find the total number of chapters of story

echo
echo total chapters is $totalchap 	
echo filename would be $fname
echo url is $url
echo


url=`echo $url | cut -d '/' --complement -f 6`
url="${url}/[2-$totalchap]/"
curl $url >> file.htm 
# Modify the URL to download the whole story via curl


fname="${fname}.txt"
lynx file.htm -dump >> $fname
echo file name saved as $fname
echo $fname $url >> DownloadedStories


# send the text file to the memory card and register the sent story in a file named 'list'

#TODO: dynamically recognize devices to be sent
if [ -d /media/BH1/ebooks/stories/ ] ; then
{
	mv $fname /media/BH1/ebooks/stories/
	#TODO: giving single filename with spaces won't work, replace them with underscores
	
	mv $fname /media/BH1/ebooks/stories/
	echo $fname >> list
echo moved file $fname along with all text files to Memcard
}
else echo memory card not inserted file not moved
fi
