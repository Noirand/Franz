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

	sed -i -e '/#EXTINF/d' "$TARGET"
	cat "$TARGET" | while read line						  
	do
		echo "${line}"
	done
done
