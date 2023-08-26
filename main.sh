#!bin/bash

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
			ALBUM=`echo "$line" | awk -F "/" '{ print $(NF - 1) }'`
			ARTIST=`echo "$line" | awk -F "/" '{ print $(NF - 2) }'`

			# relpace whole file paths for Android
			sed -i "" -e "/$MUSIC\$/s/.*/$ARTIST\/$ALBUM\/$MUSIC/" "$TARGET"

			# copy music file to proper folder
			mkdir -p output/music/"$ARTIST"/"$ALBUM"
			cp "$line" ./output/music/"$ARTIST"/"$ALBUM"
		fi
	done
done
