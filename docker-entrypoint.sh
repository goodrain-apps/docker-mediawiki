#!/bin/bash

echo "now config mediawiki ..."

if [[ -z $SITE_URL ]]; then
    echo "please set your wiki site, through system env 'SITE_URL' to set"
    exit 1
fi


export WIKI_NAME=${WIKI_NAME:-'MyWiki'}
export WIKI_SPACE=${WIKI_SPACE:-'MyWiki'}

sed -i \
    -e "s|WIKI_NAME|${WIKI_NAME}|" \
    -e "s|WIKI_NAME_SPACE|$WIKI_SPACE}|" \
    -e "s|SITE_URL|$SITE_URL|" \
    /app/mediawiki/LocalSettings.php

if [ ! -d "/data/config" ];then
	mv /app/config/ /data/config
	chmod -R 777 /data/config
	mv /app/mediawiki/images /data/images
	chmod -R 777 /data/images
fi

rm -r /app/data
ln -s /data/config /app/data
rm -r /app/mediawiki/images
ln -s /data/images /app/mediawiki/images

apache2-foreground