#!/bin/sh

# This is a quick little script for showing what process is doing what when the script is called. I found that I was using the ps command per the below quite often, and simply opted to scriptify it for ease.

ps aux | awk '(NR == 1){print} ((NR > 1) && ($3 > 0)){print} ((NR > 1) && ($4 > 0)){print}' | less

exit 0
