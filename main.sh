#!bin/bash

for org in original/*.m3u
do
	cp "$org" ./output
	#cp "$org" "${org%.m3u}".txt
	#mv "${org%.m3u}".txt ./output
	echo "$org"
	TARGET=`echo ${org/original/output}`
	#TARGET=`echo ${TARGET/m3u/txt}`
	echo "$TARGET"

	# 改行コードがおかしくて cat で読めなくなっているので変換
	nkf -Lu --overwrite "$TARGET"

	# remove unnessesary lines
	sed -i -e '/#EXTINF/d' "$TARGET"
	
	cat "$TARGET" | while read line						  
	do
		#echo "${line}"
		if [ "$line" != "#EXTM3U" ]; then
			MUSIC="${line##*/}"
			#ALBUM="${line##*/MUSIC}"
			ALBUM=`echo "$line" | awk -F "/" '{ print $(NF - 1) }'`
			#ARTIST="${line##*/ALBUM}"
			ARTIST=`echo "$line" | awk -F "/" '{ print $(NF - 2) }'`
			echo MUSIC = "$MUSIC"
			echo ALBUM = "$ALBUM"
			echo ARTIST = "$ARTIST"

			# relpace whole file paths for Android
			sed -i -e "/$MUSIC\$/s/.*/$ARTIST\/$ALBUM\/$MUSIC/" "$TARGET"

			# copy music file to proper folder
			mkdir -p output/music/"$ARTIST"/"$ALBUM"
			cp "$line" ./output/music/"$ARTIST"/"$ALBUM"
		fi
	done
done
