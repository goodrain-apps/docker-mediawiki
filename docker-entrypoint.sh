#!/bin/bash

echo "now config mediawiki ..."

export WIKI_NAME=${WIKI_NAME:-'MyWiki'}
export WIKI_NAME_SPACE=${WIKI_NAME_SPACE:-'MyWiki'}

sed -i \
    -e "s|WIKI_NAME|${WIKI_NAME}|" \
    -e "s|WIKI_NAME_SPACE|${WIKI_NAME_SPACE}|" \
    /app/media/LocalSettings.php

if [ ! -d "/data/config" ];then
	mv /app/config/ /data/config
fi

rm -r /app/data

ln -s /data/config /app/data

apache2-foreground