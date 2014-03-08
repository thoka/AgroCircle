#!/bin/bash

# extract scenes changes from youtube-video 
# requires real ffmpeg, not libav, which is bundled with debian

INF="$1"

echo processing $INF

ID=`basename $INF .mp4`
DIR=`dirname $INF`

ffmpeg -v debug -i "$INF" -vf "select='gt(scene\,0.35)'" -vsync 0 -f image2  "$DIR/$ID-%04d.jpg" 2>&1 | cat > "$DIR/$ID.frames"
grep select:1 "$DIR/$ID.frames" > "$DIR/$ID.scenes"
cat "$DIR/$ID.scenes"


