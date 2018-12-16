#
# Run this script only once 
#

#!/bin/bash
FILE=/usr/local/bin/helmOrig

if [ ! -f "$FILE" ]
then
    echo "File $FILE does not exist"
    cp /usr/local/bin/helm /usr/local/bin/helmOrig
    cp ./helm  /usr/local/bin/helm
fi