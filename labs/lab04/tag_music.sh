#!/bin/sh

for directory in "$@"
do
    ablum=`echo $directory | cut -d"/" -f2 `
    year=`echo $ablum | cut -d", " -f2`
    for file in "$directory"/*.mp3
    do
        mid=`echo $file | sed 's/ - /#/g' | sed 's/\/\//\//g'`
        title=`echo $mid | cut -d"#" -f2`
        track=`echo $mid | cut -d"-" -f1 | cut -d"/" -f3`
        artist=`echo $mid | cut -d"#" -f3 | sed 's/\.mp3//'`
        id3 -t "$title" "$file">/dev/null
        id3 -a "$artist" "$file">/dev/null
        id3 -T "$track" "$file">/dev/null
        id3 -A "$ablum" "$file">/dev/null
        id3 -y $year "$file">/dev/null
    done
done
exit 0
