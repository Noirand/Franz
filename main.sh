#!bin/bash

for org in original/*.m3u
do
	cp "$org" ./output/
	echo "$org"
	TARGET=`echo ${org/original/output}`
	echo "$TARGET"
	#cat "$TARGET"
	cat "$TARGET" | while read line						  
	do
		echo "${line}"
	done
done
