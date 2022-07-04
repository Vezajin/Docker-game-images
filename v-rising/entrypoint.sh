#!/bin/bash

set -o errexit
set -o pipefail

function ensure_steamcmd() {
	mkdir -vp /tmp/steamcmd
	cd /tmp/steamcmd

	if [ ! -f "./steamcmd.sh" ]; then
		wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
		tar -xvzf steamcmd_linux.tar.gz
		rm steamcmd_linux.tar.gz
	fi

	# Workaround for https://www.reddit.com/r/SteamCMD/comments/nv9oey/error_failed_to_install_app_xxx_disk_write_failure/
	mkdir -vp /home/steam-user/steamapps
}

function update_validate() {
	echo 'validating update'
	ensure_steamcmd
	cd /tmp/steamcmd
	./steamcmd.sh +force_install_dir /home/steam-user +login anonymous +app_update $GameId validate +quit
	echo 'validated update'
}

function update() {
	echo 'updating game'
	ensure_steamcmd
	cd /tmp/steamcmd
	./steamcmd.sh +force_install_dir /home/steam-user +login anonymous +app_update $GameId +quit
	echo 'updated game'
}


function start() {
	echo 'starting v-rising'
	local start_command="xvfb-run -a wine VRisingServer.exe -persistentDataPath /mnt/game"
	
	cd /home/steam-user
	echo "$start_command"
	eval "$start_command"
}

case "$1" in
update)
	update
	;;
update_validate)
	update_validate
	;;
start)
	start
	;;
*)
	update_validate
	start
	;;
esac
