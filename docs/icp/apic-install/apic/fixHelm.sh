#
# Run this script only once 
#

#!/bin/bash
FILE=/usr/local/bin/helmICP

if [ ! -f "$FILE" ]
then
    echo "File $FILE does not exist"
    cp /usr/local/bin/helm /usr/local/bin/helmICP
    cp ./helm  /usr/local/bin/helm
fi