#!/bin/bash

# download videos from youtube

mkdir -p youtube
grep youtube.com/watch "Existing Documentation.txt" | xargs -n 1 youtube-dl -o 'youtube/%(id)s.%(ext)s'
