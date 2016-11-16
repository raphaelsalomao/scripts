#!/bin/bash
scp root@10.62.2.27:/root/pebble_conntest.log /data/www/freeboard/scripts/pebble_conntest.log

STATUS=$(tail -n1 /data/www/freeboard/scripts/pebble_conntest.log | cut -d ' ' -f7)

echo -e "{\"Status\":\"$STATUS\"}" > /data/www/freeboard/pages/ftppebble_status.html
