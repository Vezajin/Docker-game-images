#!/bin/bash

mcrcon -H 127.0.0.1 -P 25575 -p $MC_RCON_PASSWORD -w 1 'say Backing up server' save-off save-all
tar -cvpzf /mnt/game/backup/server-$(date +%F-%H-%M).tar.gz /mnt/game/backup
mcrcon -H 127.0.0.1 -P 25575 -p $MC_RCON_PASSWORD -w 1 save-on 'say Backed up server' 

## Delete older backups
find /mnt/game/backup/ -type f -mtime +7 -name '*.gz' -delete