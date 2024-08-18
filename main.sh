#!/bin/bash

cd `dirname $0`

for org in original/*.m3u
do
	cp "$org" ./output
	#echo "$org"
	TARGET=`echo ${org/original/output}`
	#echo "$TARGET"

	# 改行コードがおかしくて cat で読めなくなっているので変換
	nkf -Lu --overwrite "$TARGET"

	# remove unnessesary lines
	sed -i "" -e '/\#EXTINF/d' "$TARGET"
	
	cat "$TARGET" | while read line						  
	do
		#echo "${line}"
		if [ "$line" != "#EXTM3U" ]; then
			MUSIC="${line##*/}"
			ALBUM=$(echo "$line" | awk -F "/" '{ print $(NF - 1) }')
			ARTIST=$(echo "$line" | awk -F "/" '{ print $(NF - 2) }')
			
			# escape "&"
			DSTPATH=$(echo "$ARTIST\/$ALBUM\/$MUSIC" | sed -e 's/\&/\\&/g')

			# music name for compare
			C_MUSIC=$(echo "$MUSIC" | sed -e 's/\[/\\[/g' -e 's/\]/\\]/g')
			
			# relpace whole file paths for Android
			sed -i "" -e "/$C_MUSIC/s|.*|$DSTPATH|" "$TARGET"

			# copy music file to proper folder
			if [ "$1" != "-dc" ]; then
				mkdir -p output/music/"$ARTIST"/"$ALBUM"
				cp "$line" ./output/music/"$ARTIST"/"$ALBUM"
			fi
		fi
	done
done
