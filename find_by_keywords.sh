#!/bin/bash
if [ "$#" -le 0 ]
then
	echo "This script requires at least 1 argument"
elif [ "$#" -eq 1 ] && [ "$1" == "-all" ]
then
	echo "At least one word argument must be provided in addition to the all flag"
elif [ "$1" == "-all" ] 
then
	#new directory variable name 
	dir+="$2"
	
	#find first word in tweets file and create temp file with line numbers
	egrep -win "$2" tweets.txt > tweets_temp.txt
	
	#more than 1 word to find
	if [ "$#" -gt 2 ]
	then
		for f in $(seq 3 1 "$#")
		do
			dir+="_${!f}"
			#trim temp tweets with new word matches only
			egrep -wi "${!f}" tweets_temp.txt > another_temp.txt
			cp another_temp.txt tweets_temp.txt
		done

	fi

	#create directory and text files
	mkdir "$dir"
	while read LINE 
	do
		echo "${LINE#*:}" > "$dir/tweet_${LINE%%:*}.txt"
	done < tweets_temp.txt
	rm tweets_temp.txt
	rm another_temp.txt
else 
	#create directories
	for i in $(seq 1 1 "$#")
	do
		mkdir "${!i}"
		#search tweets for words and add .txt file if found
		egrep -win "${!i}" tweets.txt | while read LINE
		do
			echo "${LINE#*:}" > "${!i}/tweet_${LINE%%:*}.txt"
		done
	done
fi
